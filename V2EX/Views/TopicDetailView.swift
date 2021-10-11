//
//  TopicDetailView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/11.
//

import SwiftUI

struct TopicDetailView: View {
    let topic: Topic

    var body: some View {
        ScrollView {
            title

            Divider()

            content

            Divider()

            replies
        }
    }

    // MARK: - Views

    var title: some View {
        HStack {
            Text(topic.title)
                .font(.title3)

            Spacer()
        }
        .padding()
    }

    var content: some View {
        HStack {
            if let content = topic.content {
                Text(content)
            }

            Spacer()
        }
        .padding()
    }

    var replies: some View {
        Text(String(topic.numberOfReplies))
            .font(.footnote)
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let topic = Topic(id: 707_378, numberOfReplies: 31, title: "所以 iPad Air 4 和 iPad Pro 2020 该怎么选呢？")
        TopicDetailView(topic: topic)
    }
}
