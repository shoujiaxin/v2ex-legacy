//
//  Topic.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import Foundation

struct Topic: Identifiable {
    let content: String? = nil

    let id: Int

    let numberOfReplies: Int

    let title: String
}
