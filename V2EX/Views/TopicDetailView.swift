//
//  TopicDetailView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/11.
//

import SwiftUI

struct TopicDetailView: View {
    @StateObject private var fetcher: TopicDetailFetcher

    init(of topic: Topic) {
        _fetcher = StateObject(wrappedValue: TopicDetailFetcher(topic: topic))
    }

    var body: some View {
        ScrollView {
            title

            Divider()

            content

            numberOfReplies

            replies
        }
        .toolbar {
            ToolbarItem {
                if fetcher.isFetching {
                    ProgressView()
                } else {
                    Button {
                        fetcher.fetch()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }

    // MARK: - Views

    var title: some View {
        HStack {
            Text(fetcher.topic.title)
                .font(.title3)

            Spacer(minLength: 0)
        }
        .padding()
    }

    var content: some View {
        HStack {
            if let content = fetcher.topic.content {
                Text(content)
            }

            Spacer(minLength: 0)
        }
        .padding()
    }

    var numberOfReplies: some View {
        HStack(spacing: 2) {
            Group {
                Text(String(fetcher.topic.numberOfReplies))

                Text("Replies")
            }
            .font(.footnote)
            .foregroundColor(.secondary)

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background {
            Color.gray
                .opacity(0.2)
                .shadow(radius: 4)
        }
    }

    var replies: some View {
        LazyVStack(alignment: .leading) {
            ForEach(fetcher.replies) { reply in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(reply.author.name)

                        Spacer()

                        Text("#\(reply.id)")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()

                    Text(reply.content)
                        .padding()
                }

                Divider()
            }
            .transition(.slide)
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let topic = Topic(id: 707_378, title: "所以 iPad Air 4 和 iPad Pro 2020 该怎么选呢？", author: Author(name: "shoujiaxin"), numberOfReplies: 31)
        TopicDetailView(of: topic)
    }
}
