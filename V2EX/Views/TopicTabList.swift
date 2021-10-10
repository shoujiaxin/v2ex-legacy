//
//  TopicTabList.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import SwiftUI

struct TopicTabList: View {
    var body: some View {
        NavigationView {
            List {
                // TODO: Fetch topic tabs
                ForEach(topicTabs, id: \.self) { topicTab in
                    NavigationLink(topicTab) {
                        Text(topicTab)
                    }
                }
            }
            .navigationTitle("Topic")
        }
    }

    // MARK: - Constants

    private let topicTabs = [
        "tech",
        "creative",
        "play",
        "apple",
        "jobs",
        "deals",
        "city",
        "qna",
        "hot",
        "all",
        "r2",
        "nodes",
        "members",
    ]
}

struct TopicTabList_Previews: PreviewProvider {
    static var previews: some View {
        TopicTabList()
    }
}
