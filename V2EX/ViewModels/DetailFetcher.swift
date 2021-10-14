//
//  DetailFetcher.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/13.
//

import Foundation
import SwiftSoup

class DetailFetcher: ObservableObject {
    @Published var isFetching: Bool = true

    var task: Task<Void, Error>?

    func cancel() {
        task?.cancel()
        isFetching = false
    }

    func fetch(with session: URLSession = .shared, from url: URL) async throws -> Document? {
        let (data, response) = try await session.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            // TODO: Throw error
            return nil
        }

        let html = String(data: data, encoding: .utf8)
        let document = try html.map(SwiftSoup.parse)
        return document
    }
}
