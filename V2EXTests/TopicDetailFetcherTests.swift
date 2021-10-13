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

        let topic = Topic(id: 707_378, title: "所以 iPad Air 4 和 iPad Pro 2020 该怎么选呢？", author: Author(name: "shoujiaxin"), numberOfReplies: 31)
        fetcher = TopicDetailFetcher(topic: topic)

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }

    func testCancel() throws {
        fetcher.fetch(with: session)
        XCTAssertTrue(fetcher.isFetching)

        fetcher.cancel()
        XCTAssertFalse(fetcher.isFetching)
    }

    func testFetch() throws {
        MockURLProtocol.requestHandler = { request in
            let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "TopicDetailFetcherTests", withExtension: "html")!)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
            return (data, response, nil)
        }

        fetcher.fetch(with: session)

        let topicsExpectation = expectation(description: "TopicDetailFetcherTests.testFetch.topics")
        fetcher.$topic
            .collect(2)
            .sink { topics in
                XCTAssertNotNil(topics.last?.content)
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

                repliesExpectation.fulfill()
            }
            .store(in: &cancellables)

        let isFetchingExpectation = expectation(description: "TopicDetailFetcherTests.testFetch.isFetching")
        fetcher.$isFetching
            .collect(2)
            .sink { states in
                XCTAssertEqual(states.first, true)
                XCTAssertEqual(states.last, false)

                isFetchingExpectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5)
    }
}
