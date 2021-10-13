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

    @Published private(set) var replies: [Reply] = []

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
                self.replies = try document.select("[id~=^r_[0-9]+$]")
                    .enumerated()
                    .compactMap { index, item in
                        let content = try item.select(".reply_content").text()

                        guard let authorName = try item.select(#"[href~=^\/member\/.+]"#).first?.text(), let avatarURL = try URL(string: item.select(".avatar").attr("src")) else {
                            return nil
                        }
                        let author = Author(name: authorName, avatarURL: avatarURL)

                        return Reply(id: index + 1, content: content, author: author)
                    }
            }
        } catch {
            print(error)
        }
    }

    // MARK: - Constants

    private static let baseURL = URL(string: "https://www.v2ex.com/t")!
}
