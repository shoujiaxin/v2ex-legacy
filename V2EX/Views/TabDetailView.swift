//
//  TabDetailView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import SwiftUI

struct TabDetailView: View {
    @StateObject private var fetcher: TabDetailFetcher

    init(topicTab: String) {
        _fetcher = StateObject(wrappedValue: TabDetailFetcher(topicTab: topicTab))
    }

    var body: some View {
        List {
            ForEach(fetcher.topics) { topic in
                NavigationLink(topic.title) {
                    TopicDetailView(topic: topic)
                }
            }
        }
        .listStyle(InsetListStyle())
        .toolbar {
            ToolbarItem {
                if fetcher.isFetching {
                    ProgressView()
                } else {
                    Button(action: fetcher.fetch) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            fetcher.fetch()
        }
    }
}

struct TabDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TabDetailView(topicTab: "all")
    }
}
