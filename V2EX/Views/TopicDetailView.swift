//
//  TopicDetailView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/11.
//

import ActivityIndicatorView
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

            if let content = fetcher.topic.content {
                ContentView(attributedText: content)
                    .padding()
            } else {
                ActivityIndicatorView(isVisible: .constant(true), type: .rotatingDots)
                    .frame(width: indicatorSize, height: indicatorSize)
                    .padding()
                    .foregroundColor(.accentColor)
            }

            numberOfReplies

            replies

            if fetcher.hasNextPage {
                Button {
                    Task {
                        await fetcher.fetchNextPage()
                    }
                } label: {
                    Text("Load more")
                        .padding()
                }
            }
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
        // ContentView has size issue in LazyVStack
        VStack(alignment: .leading, spacing: 0) {
            ForEach(fetcher.replies) { reply in
                replyRow(of: reply)
                    .padding()
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {} label: {
                            Label("Reply", systemImage: "arrowshape.turn.up.left")
                        }

                        Button {} label: {
                            Label("Like", systemImage: "heart")
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

                if reply.numberOfLikes > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .opacity(0.8)

                        Text(String(reply.numberOfLikes))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Text("#\(reply.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .capsuled()
            }

            if let content = reply.content {
                ContentView(attributedText: content)
            }
        }
    }

    // MARK: - Constants

    private let indicatorSize: CGFloat = 64
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let author = Author(name: "shoujiaxin", avatarURL: URL(string: "https://cdn.v2ex.com/avatar/f9b7/ef66/257377_large.png?m=1514370922")!)
        let topic = Topic(id: 707_378, title: "?????? iPad Air 4 ??? iPad Pro 2020 ??????????????????", author: author, postDate: "2020-09-16 02:32:03 +08:00", numberOfReplies: 31)
        TopicDetailView(of: topic)
    }
}
