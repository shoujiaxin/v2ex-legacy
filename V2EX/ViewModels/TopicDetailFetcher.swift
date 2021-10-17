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

    var hasNextPage: Bool {
        currentPage < numberOfPages
    }

    private var components: URLComponents

    private var numberOfPages: Int = 1

    private var currentPage: Int = 1

    init(topic: Topic) {
        _topic = Published(wrappedValue: topic)

        components = URLComponents(url: Constants.topicBaseURL.appendingPathComponent(String(topic.id)), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "p", value: String(currentPage))]

        Task {
            await self.fetch()
        }
    }

    func fetch(with session: URLSession = .shared) async {
        guard let url = components.url else {
            return
        }

        do {
            let document = try await V2EXRequest.document(with: session, from: url)
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    try self.parseContent(document)
                }
                group.addTask {
                    try self.parseReplies(document)
                }
                group.addTask {
                    let maxPage = try (document?.select(".page_input").attr("max")).flatMap { Int($0) }
                    self.numberOfPages = maxPage ?? 1
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchNextPage(with session: URLSession = .shared) async {
        components.queryItems = [URLQueryItem(name: "p", value: String(currentPage + 1))]
        guard let url = components.url else {
            return
        }

        do {
            let document = try await V2EXRequest.document(with: session, from: url)
            try parseReplies(document)
            currentPage += 1
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
                self.topic.content = NSAttributedString(contentHTML)
            }
        }
    }

    private func parseReplies(_ document: Document?) throws {
        guard let document = document else {
            return
        }

        let replies: [Reply] = try document.select("[id~=^r_[0-9]+$]")
            .compactMap { item in
                guard let id = try Int(item.select(".no").text()) else {
                    return nil
                }

                let contentHTML = try item.select(".reply_content").html()

                guard let authorName = try item.select(#"[href~=^\/member\/.+]"#).first?.text(), let avatarURL = try URL(string: item.select(".avatar").attr("src")) else {
                    return nil
                }
                let author = Author(name: authorName, avatarURL: avatarURL)

                let postDate = try item.select(".ago").attr("title")

                let numberOfLikes = try Int(item.select(".small.fade").text()) ?? 0

                return Reply(id: id, content: NSAttributedString(contentHTML), author: author, postDate: postDate, numberOfLikes: numberOfLikes)
            }

        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                self.replies.append(contentsOf: replies)
            }
        }
    }
}
