//
//  TopicDetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/12.
//

import Combine
import Foundation
import SwiftSoup
import SwiftUI

class TopicDetailFetcher: ObservableObject {
    @Published private(set) var topic: Topic

    @Published private(set) var replies: [String] = []

    @Published private(set) var isFetching: Bool = false

    private let url: URL

    private var cancellable: AnyCancellable?

    init(topic: Topic) {
        _topic = Published(wrappedValue: topic)

        url = Self.baseURL.appendingPathComponent(String(topic.id))

        fetch()
    }

    func cancel() {
        isFetching = false
        cancellable?.cancel()
    }

    func fetch(with session: URLSession = .shared) {
        cancel()

        isFetching = true
        cancellable = session.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .map { String(data: $0, encoding: .utf8) }
            .replaceNil(with: "")
            .tryMap { try SwiftSoup.parse($0) }
            .sink { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] document in
                // TODO: Concurrency
                self?.parseContent(document)
                self?.parseReplies(document)
            }
    }

    // MARK: - Private functions

    private func parseContent(_ document: Document) {
        do {
            let contentHTML = try document.select(".topic_content").html()
            withAnimation(.easeInOut) {
                topic.content = contentHTML
            }
        } catch {
            print(error)
        }
    }

    private func parseReplies(_ document: Document) {
        do {
            try withAnimation(.easeInOut) {
                self.replies = try document.select(".reply_content").map { try $0.text() }
            }
        } catch {
            print(error)
        }
    }

    // MARK: - Constants

    private static let baseURL = URL(string: "https://www.v2ex.com/t")!
}
