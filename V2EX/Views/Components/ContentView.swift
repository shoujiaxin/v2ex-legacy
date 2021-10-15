//
//  ContentView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/15.
//

import SwiftUI

struct ContentView: View {
    let attributedText: NSAttributedString

    @State private var height: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            AttributedTextView(attributedText: attributedText, width: proxy.size.width, height: self.$height)
        }
        .frame(height: height)
    }
}

struct ContentView_Previews: PreviewProvider {
    private static let html =
        """
        <div class="markdown_body"><p>今年 2 月份注册的公众号，用来作为个人博客，关于为什么不选择其他平台，主要看中了公众号的用户粘性比较大。目前并没有多少关注量，但还是想要留言功能，查询了几种方案，最实用的迁移留言号需要几千块钱（暂时不考虑），其他的植入小程序留言，广告太多了，而且听说有可能违规。 最后我是通过搭建了一个网站专门同步公众号文章（手动方式），网站内有评论模块。 具体操作是，每次公众号发文前，先更新网站，将网站链接设置为公众号文章的原文，然后群发，群发后可以得到公众号文章链接，此时再将公众号文章链接更新到网站上。用户想要留言只要点击最下方的阅读原文进行跳转即可。</p>
        <p>具体细节： <a href="https://mp.weixin.qq.com/s/pxw_tkLB--f6KFx2hP1mSw" rel="nofollow">https://mp.weixin.qq.com/s/pxw_tkLB--f6KFx2hP1mSw</a></p>
        <p>网站地址： <a href="https://www.togettoyou.com/" rel="nofollow">https://www.togettoyou.com/</a></p>
        </div>
        """

    private static let str = try! NSAttributedString(data: html.data(using: .unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)

    static var previews: some View {
        ScrollView {
            Text("Begin")
                .background(.red)

            ContentView(attributedText: str)

            Text("End")
                .background(.green)
        }
    }
}
