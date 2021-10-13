//
//  Reply.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/13.
//

import Foundation

struct Reply: Identifiable {
    let id: Int

    let content: String

    let author: Author
}