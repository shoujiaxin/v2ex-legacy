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
            if let content = topic.renderedCcontent {
                Text(AttributedString(content))
            } else {
                Text(topic.content)
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
        let topic = Topic(content: """
        刚刚没事查了下 U2720 的保修期，发现 9 月底发布 Mac 版 Dell Display Manager 了，还支持 M1，试用了一下真不错。
        还有固件更新，更新了 20 多分钟，我去刷牙了回来黑屏了半天还以为坏了，更新完了也没恢复，最后拔电源了事。OSD 菜单里没有肉眼可见的更新。

        最后，用 U2720 的朋友，可以说说都是怎么设置的吗？现在用标准模式，RGB，描述文件用的 DCI-P3，色彩还是不太满意（与 Mac 屏幕有点差距）。还有 SmartHDR 这玩意一开就色偏，是不是就没用？
        """, id: 806_920, numberOfReplies: 10, title: "Dell Display Manager 支持 Mac 啦")
        TopicDetailView(topic: topic)
    }
}
