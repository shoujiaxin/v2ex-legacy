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

    private var cancellable: AnyCancellable?

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
    }

    func testCancel() throws {
        fetcher.fetch(with: session)
        XCTAssertTrue(fetcher.isFetching)

        fetcher.cancel()
        XCTAssertFalse(fetcher.isFetching)
    }

    func testFetch() throws {
        MockURLProtocol.requestHandler = { request in
            let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "testFetch", withExtension: "html")!)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
            return (data, response, nil)
        }

        let expectation = expectation(description: "testFetch")
        fetcher.fetch(with: session)

        cancellable = fetcher.$topics
            .collect(2)
            .sink { topicsArray in
                let topics = topicsArray.last
                XCTAssertEqual(topics?.count, 49)

                let topic = topics?.first
                XCTAssertNotNil(topic)
                XCTAssertNil(topic?.content)
                XCTAssertEqual(topic?.id, 807_369)
                XCTAssertEqual(topic?.numberOfReplies, 25)
                XCTAssertEqual(topic?.title, "国庆节最后一天一千公里电动汽车长途驾驶体验")

                expectation.fulfill()
            }

        waitForExpectations(timeout: 5)
    }
}
