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
                // TODO: Tab icon
                ForEach(topicTabs, id: \.self) { tab in
                    NavigationLink(tab) {
                        TabDetailView(topicTab: tab)
                            .navigationTitle(tab)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
            .navigationTitle("Topic")

            welcomeView
        }
    }

    // MARK: - Views

    private var welcomeView: some View {
        VStack(spacing: 24) {
            Text("Welcome to V2EX")
                .font(.title)

            Text("V2EX is a community of start-ups, designers, developers and creative people.")
                .foregroundColor(.secondary)
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
