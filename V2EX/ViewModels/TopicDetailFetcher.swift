//
//  TopicDetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/12.
//

import Foundation
import SwiftSoup
import SwiftUI

class TopicDetailFetcher: DetailFetcher {
    @Published private(set) var topic: Topic

    @Published private(set) var replies: [Reply] = []

    private let url: URL

    init(topic: Topic) {
        _topic = Published(wrappedValue: topic)

        url = Self.baseURL.appendingPathComponent(String(topic.id))

        super.init()

        fetch()
    }

    func fetch(with session: URLSession = .shared) {
        task = Task(priority: .high) {
            let document = try await fetch(with: session, from: url)
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try self.parseContent(document)
                }
                group.addTask {
                    try self.parseReplies(document)
                }
            }
        }
    }

    // MARK: - Private functions

    private func parseContent(_ document: Document?) throws {
        guard let document = document else {
            return
        }

        let contents = try document.select(".topic_content")
        let markdownBody = try contents.select(".markdown_body")
        let contentHTML = try markdownBody.first?.html() ?? contents.html()

        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.topic.content = contentHTML
            }
        }
    }

    private func parseReplies(_ document: Document?) throws {
        guard let document = document else {
            return
        }

        let replies: [Reply] = try document.select("[id~=^r_[0-9]+$]")
            .enumerated()
            .compactMap { index, item in
                let content = try item.select(".reply_content").text()

                guard let authorName = try item.select(#"[href~=^\/member\/.+]"#).first?.text(), let avatarURL = try URL(string: item.select(".avatar").attr("src")) else {
                    return nil
                }
                let author = Author(name: authorName, avatarURL: avatarURL)

                return Reply(id: index + 1, content: content, author: author)
            }

        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.replies = replies
            }
        }
    }

    // MARK: - Constants

    private static let baseURL = URL(string: "https://www.v2ex.com/t")!
}
