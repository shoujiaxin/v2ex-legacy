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
                NavigationLink(destination: TopicDetailView(of: topic)) {
                    topicRow(of: topic)
                        .padding(.vertical, 6)
                    #if DEBUG
                        .contextMenu {
                            Button {
                                UIApplication.shared.open(Constants.topicBaseURL.appendingPathComponent(String(topic.id)))
                            } label: {
                                Label("Open in Safari", systemImage: "safari")
                            }
                        }
                    #endif
                }
            }
        }
        .listStyle(InsetListStyle())
        .refreshable {
            await fetcher.fetch()
        }
        .toolbar {
            ToolbarItem {
                if fetcher.topics.isEmpty {
                    ProgressView()
                } else {
                    Button {
                        // TODO: Post a topic
                    } label: {
                        Image(systemName: "plus.bubble")
                    }
                }
            }
        }
    }

    // MARK: - Views

    @ViewBuilder
    func topicRow(of topic: Topic) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(topic.title)

                HStack {
                    Text(topic.author.name)

                    Text(topic.postDate)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }

            Spacer()

            Text(String(topic.numberOfReplies))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .capsuled()
        }
    }
}

struct TabDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TabDetailView(topicTab: "apple")
    }
}
