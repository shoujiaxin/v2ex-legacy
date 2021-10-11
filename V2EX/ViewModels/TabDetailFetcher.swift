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
    }

    func cancel() {
        isFetching = false
        cancellable?.cancel()
    }

    func fetch() {
        cancel()

        isFetching = true
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
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
            try document.select(".cell.item").forEach { item in
                if let topic = try self.parseTopicInfo(item) {
                    withAnimation(.easeInOut) {
                        self.topics.append(topic)
                    }
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

        let numberOfReplies = try Int(item.select(".count_livid").text()) ?? 0

        let title = try item.select(".item_title").text()

        return Topic(id: id, numberOfReplies: numberOfReplies, title: title)
    }

    // MARK: - Constants

    static let baseURL: String = "https://www.v2ex.com"
}
