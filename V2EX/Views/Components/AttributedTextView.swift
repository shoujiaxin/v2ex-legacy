//
//  AttributedTextView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/16.
//

import SwiftUI

struct AttributedTextView: UIViewRepresentable {
    typealias UIViewType = UIView

    let attributedText: NSAttributedString

    let width: CGFloat

    @Binding var height: CGFloat

    func makeUIView(context _: Context) -> UIViewType {
        let textView = UITextView()
        textView.attributedText = attributedText
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .justified
        textView.textContainer.lineFragmentPadding = 0

        let containerView = UIView()
        containerView.addSubview(textView)

        return containerView
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        let textView = uiView.subviews.first as! UITextView
        textView.attributedText = attributedText

        DispatchQueue.main.async {
            height = textView.sizeThatFits(CGSize(width: width, height: height)).height
            let size = CGSize(width: width, height: height)
            uiView.frame.size = size
            textView.frame.size = size
        }
    }
}
