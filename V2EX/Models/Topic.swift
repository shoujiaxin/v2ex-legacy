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

    let numberOfReplies: Int

    var content: String? = nil
}
