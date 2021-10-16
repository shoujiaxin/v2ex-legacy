//
//  Topic.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Foundation
import SwiftUI

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
                .flatMap { try? NSMutableAttributedString(data: $0, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) }
                .map { $0.updateFont(size: UIFont.preferredFont(forTextStyle: .body).pointSize, color: .primary) }
        }
    }

    var attributedContent: NSAttributedString? = nil
}

private extension NSMutableAttributedString {
    func updateFont(size: CGFloat, color: Color) -> Self {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: length)) { value, range, _ in
            guard let font = value as? UIFont else {
                return
            }

            let newFont = UIFont(descriptor: font.fontDescriptor, size: size)
            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)

            removeAttribute(.foregroundColor, range: range)
            addAttribute(.foregroundColor, value: UIColor(color), range: range)
        }
        endEditing()
        return self
    }
}
