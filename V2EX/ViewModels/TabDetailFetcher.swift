//
//  TabDetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Foundation
import SwiftSoup
import SwiftUI

class TabDetailFetcher: ObservableObject {
    @Published private(set) var topics: [Topic] = []

    private let url: URL

    init(topicTab: String) {
        var components = URLComponents(url: Constants.baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "tab", value: topicTab)]
        url = components.url!

        Task { [weak self] in
            await self?.fetch()
        }
    }

    func fetch(with session: URLSession = .shared) async {
        do {
            let document = try await V2EXRequest.document(with: session, from: url)
            try parse(document)
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Private functions

    private func parse(_ document: Document?) throws {
        guard let document = document else {
            return
        }

        let topics = try document.select(".cell.item").compactMap { [weak self] item in
            try self?.parseTopicInfo(item)
        }

        DispatchQueue.main.async { [weak self] in
            withAnimation(.easeInOut) {
                self?.topics = topics
            }
        }
    }

    private func parseTopicInfo(_ item: Element) throws -> Topic? {
        let href = try item.select(".topic-link").attr("href")
        let re = try NSRegularExpression(pattern: #"\/t\/([0-9]+)#reply[0-9]+$"#, options: .anchorsMatchLines)
        let result = re.firstMatch(in: href, options: .anchored, range: NSRange(href.startIndex ..< href.endIndex, in: href))
        let id = (result?.range(at: 1))
            .flatMap { Range($0, in: href) }
            .flatMap { Int(href[$0]) }
        guard let id = id else {
            return nil
        }

        let title = try item.select(".item_title").text()

        let topicInfo = try item.select(".topic_info")
        guard let authorName = try topicInfo.select(#"[href~=^\/member\/.+]"#).first?.text(), let avatarURL = try URL(string: item.select(".avatar").attr("src")) else {
            return nil
        }
        let author = Author(name: authorName, avatarURL: avatarURL)

        let postDate = try topicInfo.select("span").filter { try !$0.attr("title").isEmpty }.first?.attr("title")
        guard let postDate = postDate else {
            return nil
        }

        let numberOfReplies = try Int(item.select(".count_livid").text()) ?? 0

        return Topic(id: id, title: title, author: author, postDate: postDate, numberOfReplies: numberOfReplies)
    }
}
