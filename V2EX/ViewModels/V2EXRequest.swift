//
//  V2EXRequest.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/13.
//

import Foundation
import SwiftSoup

struct V2EXRequest {
    static func document(with session: URLSession = .shared, from url: URL) async throws -> Document? {
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
