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
        // FIXME: List has confit with animations, change to ScrollView & LazyVStack
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
            .transition(.slide)
        }
        .listStyle(InsetListStyle())
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
                .padding(.horizontal, capsuledTextHorizontalPadding)
                .padding(.vertical, capsuledTextVerticalPadding)
                .background {
                    Capsule()
                        .foregroundColor(.gray)
                        .opacity(capsuledTextBackgroundOpacity)
                }
        }
    }

    // MARK: - Constants

    private let capsuledTextHorizontalPadding: CGFloat = 8
    private let capsuledTextVerticalPadding: CGFloat = 2
    private let capsuledTextBackgroundOpacity: Double = 0.2
}

struct TabDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TabDetailView(topicTab: "apple")
    }
}
