//
//  Topic.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Foundation

struct Topic: Codable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case content = "content_rendered"
        case id
        case numberOfReplies = "replies"
        case title
    }

    let content: String

    let id: Int

    let numberOfReplies: Int

    let title: String

    var renderedCcontent: NSAttributedString? {
        content
            .data(using: .unicode)
            .flatMap { try? NSAttributedString(data: $0, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) }
    }
}
