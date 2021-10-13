//
//  Author.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/13.
//

import Foundation

struct Author: Identifiable {
    var id: String {
        return name
    }

    let name: String

    let avatarURL: URL
}
