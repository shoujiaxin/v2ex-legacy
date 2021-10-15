//
//  Topic.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Foundation

struct Topic: Identifiable {
    let id: Int

    let title: String

    let author: Author

    let postDate: String

    let numberOfReplies: Int

    var content: String? = nil {
        willSet {
            attributedContent = newValue
                .flatMap { $0.data(using: .unicode) }
                .flatMap { try? NSAttributedString(data: $0, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) }
        }
    }

    var attributedContent: NSAttributedString? = nil
}
