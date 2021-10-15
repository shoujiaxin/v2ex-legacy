//
//  TopicDetailFetcherTests.swift
//  V2EXTests
//
//  Created by Jiaxin Shou on 2021/10/13.
//

@testable import V2EX

import Combine
import XCTest

class TopicDetailFetcherTests: XCTestCase {
    private var fetcher: TopicDetailFetcher!

    private var session: URLSession!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        let author = Author(name: "shoujiaxin", avatarURL: URL(string: "https://cdn.v2ex.com/avatar/f9b7/ef66/257377_large.png?m=1514370922")!)
        let topic = Topic(id: 707_378, title: "所以 iPad Air 4 和 iPad Pro 2020 该怎么选呢？", author: author, postDate: "2020-09-16 02:32:03 +08:00", numberOfReplies: 31)
        fetcher = TopicDetailFetcher(topic: topic)

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }

    func testFetch() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "TopicDetailFetcherTests", withExtension: "html")!)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
            return (data, response, nil)
        }

        await fetcher.fetch(with: session)

        let topicsExpectation = expectation(description: "TopicDetailFetcherTests.testFetch.topics")
        fetcher.$topic
            .collect(2)
            .sink { topics in
                XCTAssertNotNil(topics.first)
                XCTAssertNil(topics.first?.content)
                XCTAssertNil(topics.first?.attributedContent)

                XCTAssertNotNil(topics.last?.content)
                XCTAssertNotNil(topics.last?.attributedContent)

                topicsExpectation.fulfill()
            }
            .store(in: &cancellables)

        let repliesExpectation = expectation(description: "TopicDetailFetcherTests.testFetch.replies")
        fetcher.$replies
            .collect(2)
            .sink { repliesArray in
                XCTAssertEqual(repliesArray.first?.count, 0)
                XCTAssertEqual(repliesArray.last?.count, 31)

                let reply = repliesArray.last?.first
                XCTAssertNotNil(reply)
                XCTAssertEqual(reply?.id, 1)
                XCTAssertEqual(reply?.content, "官网有对比功能。动动手买东西就 ok")
                XCTAssertEqual(reply?.author.name, "youngpier")
                XCTAssertEqual(reply?.author.avatarURL.absoluteString, "https://cdn.v2ex.com/avatar/5de1/e08f/301322_large.png?m=1537970469")
                XCTAssertEqual(reply?.postDate, "2020-09-16 02:37:46 +08:00")

                repliesExpectation.fulfill()
            }
            .store(in: &cancellables)

        await waitForExpectations(timeout: 5)
    }
}
