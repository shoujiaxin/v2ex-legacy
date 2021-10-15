//
//  TopicDetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/12.
//

import Foundation
import SwiftSoup
import SwiftUI

class TopicDetailFetcher: ObservableObject {
    @Published private(set) var topic: Topic

    @Published private(set) var replies: [Reply] = []

    private let url: URL

    init(topic: Topic) {
        _topic = Published(wrappedValue: topic)

        url = Constants.topicBaseURL.appendingPathComponent(String(topic.id))

        Task {
            await self.fetch()
        }
    }

    func fetch(with session: URLSession = .shared) async {
        do {
            let document = try await V2EXRequest.document(with: session, from: url)
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try self.parseContent(document)
                }
                group.addTask {
                    try self.parseReplies(document)
                }
            }
        } catch {
            print(error.localizedDescription)
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

                let postDate = try item.select(".ago").attr("title")

                return Reply(id: index + 1, content: content, author: author, postDate: postDate)
            }

        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.replies = replies
            }
        }
    }
}
