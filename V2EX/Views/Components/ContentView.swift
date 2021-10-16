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
        <div class="markdown_body"><p>我不是当事人，知乎上的<a href="https://www.zhihu.com/question/489703797" rel="nofollow">那个问题</a>是我提的，在知乎上有一定的阅读量，现在自称是公司法人的私信我，说我造谣惹事，已经交给王晶处理。</p>
        <p>对于这事情，我的态度一贯是硬刚到底，我的行为并未触犯任何法律，单纯的描述客观事实罢了，所以他们的私信也不会吓到我，另外知乎的回答里面有当事人，也爆料了公司有人注册小号洗地以及跟他要证据。这个公司真的烂透了，早点死吧。</p>
        <p><a href="https://www.v2ex.com/t/805110?p=1" rel="nofollow">镜像问题</a></p>
        <p><img alt="2361634266486_.pic.jpg" class="embedded_image" loading="lazy" referrerpolicy="no-referrer" rel="noreferrer" src="https://i.loli.net/2021/10/15/OZMQlak8sYnUIbm.jpg"></p>
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
