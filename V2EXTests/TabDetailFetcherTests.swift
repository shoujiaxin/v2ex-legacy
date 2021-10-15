//
//  TabDetailFetcherTests.swift
//  V2EXTests
//
//  Created by Jiaxin Shou on 2021/10/12.
//

@testable import V2EX

import Combine
import XCTest

class TabDetailFetcherTests: XCTestCase {
    private let fetcher = TabDetailFetcher(topicTab: "apple")

    private var session: URLSession!

    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

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
            let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "TabDetailFetcherTests", withExtension: "html")!)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
            return (data, response, nil)
        }

        await fetcher.fetch(with: session)

        let topicsExpectation = expectation(description: "TabDetailFetcherTests.testFetch.topics")
        fetcher.$topics
            .sink { topics in
                XCTAssertEqual(topics.count, 49)

                let topic = topics.first
                XCTAssertNotNil(topic)
                XCTAssertEqual(topic?.id, 807_369)
                XCTAssertEqual(topic?.title, "国庆节最后一天一千公里电动汽车长途驾驶体验")
                XCTAssertEqual(topic?.author.name, "DeadLion")
                XCTAssertEqual(topic?.author.avatarURL.absoluteString, "https://cdn.v2ex.com/avatar/938f/ffb2/133367_large.png?m=1621408222")
                XCTAssertEqual(topic?.postDate, "2021-10-12 20:44:19 +08:00")
                XCTAssertEqual(topic?.numberOfReplies, 25)
                XCTAssertNil(topic?.content)
                XCTAssertNil(topic?.attributedContent)

                topicsExpectation.fulfill()
            }
            .store(in: &cancellables)

        await waitForExpectations(timeout: 5)
    }
}
