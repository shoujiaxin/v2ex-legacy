//
//  TabDetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Combine
import Foundation
import SwiftSoup
import SwiftUI

class TabDetailFetcher: ObservableObject {
    @Published private(set) var topics: [Topic] = []

    @Published private(set) var isFetching: Bool = false

    private let url: URL

    private var cancellable: AnyCancellable?

    init(topicTab: String) {
        var components = URLComponents(string: Self.baseURL)!
        components.queryItems = [URLQueryItem(name: "tab", value: topicTab)]
        url = components.url!

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
            .sink { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] html in
                if let html = html {
                    self?.parse(html)
                }
            }
    }

    // MARK: - Private functions

    private func parse(_ html: String) {
        do {
            let document = try SwiftSoup.parse(html)
            try withAnimation(.easeInOut) {
                self.topics = try document.select(".cell.item").compactMap { [weak self] item in
                    try self?.parseTopicInfo(item)
                }
            }
        } catch {
            print(error)
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

        guard let authorName = try item.select(".topic_info").select(#"[href~=^\/member\/.+]"#).first?.text(), let avatarURL = try URL(string: item.select(".avatar").attr("src")) else {
            return nil
        }
        let author = Author(name: authorName, avatarURL: avatarURL)

        let numberOfReplies = try Int(item.select(".count_livid").text()) ?? 0

        return Topic(id: id, title: title, author: author, numberOfReplies: numberOfReplies)
    }

    // MARK: - Constants

    private static let baseURL: String = "https://www.v2ex.com"
}
