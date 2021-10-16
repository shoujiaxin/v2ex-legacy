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

            ContentInfoRow(author: fetcher.topic.author, date: fetcher.topic.postDate)
                .padding(.horizontal)

            if let content = fetcher.topic.attributedContent {
                ContentView(attributedText: content)
                    .padding()
            } else {
                ProgressView()
                    .padding()
            }

            numberOfReplies

            replies
        }
        .refreshable {
            // FIXME: ScrollView has no default implementation of .refreshable, maybe use List
            await fetcher.fetch()
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

    var numberOfReplies: some View {
        HStack {
            Text("\(fetcher.topic.numberOfReplies) Replies")
                .font(.footnote)
                .foregroundColor(.secondary)

            Spacer()
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
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(fetcher.replies) { reply in
                replyRow(of: reply)
                    .padding()
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {} label: {
                            Label("Reply", systemImage: "arrowshape.turn.up.left")
                        }

                        Button {} label: {
                            Label("Like", systemImage: "hand.thumbsup")
                        }

                        Button {} label: {
                            Label("Block", systemImage: "hand.raised")
                        }
                    }

                Divider()
            }
            .transition(.slide)
        }
    }

    @ViewBuilder
    func replyRow(of reply: Reply) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ContentInfoRow(author: reply.author, date: reply.postDate)

                Text("#\(reply.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .capsuled()
            }

            // TODO: Display rich text & image
            Text(reply.content)
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let author = Author(name: "shoujiaxin", avatarURL: URL(string: "https://cdn.v2ex.com/avatar/f9b7/ef66/257377_large.png?m=1514370922")!)
        let topic = Topic(id: 707_378, title: "所以 iPad Air 4 和 iPad Pro 2020 该怎么选呢？", author: author, postDate: "2020-09-16 02:32:03 +08:00", numberOfReplies: 31)
        TopicDetailView(of: topic)
    }
}
