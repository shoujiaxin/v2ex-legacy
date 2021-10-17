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

    var content: NSAttributedString? = nil
}

extension NSAttributedString {
    convenience init?(_ html: String) {
        guard let data = html.data(using: .unicode),
              let str = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        else {
            return nil
        }

        str.updateFont(.preferredFont(forTextStyle: .body), color: UIColor(.primary))

        self.init(attributedString: str)
    }
}

private extension NSMutableAttributedString {
    func updateFont(_ font: UIFont, color: UIColor) {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: length)) { value, range, _ in
            guard let currentFont = value as? UIFont else {
                return
            }

            // Only update font family & size
            let fontDescriptor = currentFont.fontDescriptor.withFamily(font.familyName)
            let newFont = UIFont(descriptor: fontDescriptor, size: font.pointSize)
            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)

            removeAttribute(.foregroundColor, range: range)
            addAttribute(.foregroundColor, value: color, range: range)
        }
        endEditing()
    }
}
