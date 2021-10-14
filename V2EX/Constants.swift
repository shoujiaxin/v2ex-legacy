//
//  Constants.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/14.
//

import Foundation

struct Constants {
    static let baseURL = URL(string: "https://www.v2ex.com")!

    static let topicBaseURL: URL = baseURL.appendingPathComponent("t")
}
