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
                NavigationLink(destination: TopicDetailView(topic: topic)) {
                    topicRow(of: topic)
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
    }

    // MARK: - Views

    @ViewBuilder
    func topicRow(of topic: Topic) -> some View {
        HStack {
            Text(topic.title)

            Spacer()

            Text(String(topic.numberOfReplies))
                .font(.caption)
                .fontWeight(.black)
                .padding(.horizontal, capsuledTextHorizontalPadding)
                .padding(.vertical, capsuledTextVerticalPadding)
                .background {
                    Capsule()
                        .foregroundColor(.gray)
                        .opacity(capsuledTextBackgroundOpacity)
                }
        }
    }

    // MARK: Constants

    private let capsuledTextHorizontalPadding: CGFloat = 8
    private let capsuledTextVerticalPadding: CGFloat = 2
    private let capsuledTextBackgroundOpacity: Double = 0.6
}

struct TabDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TabDetailView(topicTab: "apple")
    }
}
