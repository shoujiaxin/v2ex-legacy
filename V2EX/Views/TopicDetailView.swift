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

            Divider()

            Text(String(fetcher.topic.numberOfReplies))
                .font(.footnote)

            Divider()

            replies
        }
    }

    // MARK: - Views

    var title: some View {
        HStack {
            Text(fetcher.topic.title)
                .font(.title3)

            Spacer()
        }
        .padding()
    }

    var content: some View {
        HStack {
            if let content = fetcher.topic.content {
                Text(content)
            }

            Spacer()
        }
        .padding()
    }

    var replies: some View {
        ForEach(fetcher.replies, id: \.self) { reply in
            HStack {
                Text(reply)
                    .padding()

                Spacer()
            }

            Divider()
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let topic = Topic(id: 707_378, numberOfReplies: 31, title: "所以 iPad Air 4 和 iPad Pro 2020 该怎么选呢？")
        TopicDetailView(of: topic)
    }
}
