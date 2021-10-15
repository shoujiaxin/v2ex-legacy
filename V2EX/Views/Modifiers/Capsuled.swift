//
//  Capsuled.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/15.
//

import SwiftUI

struct Capsuled: ViewModifier {
    let opacity: CGFloat

    let horizontalPadding: CGFloat

    let verticalPadding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background {
                Capsule()
                    .foregroundColor(.secondary)
                    .opacity(opacity)
            }
    }
}

extension Text {
    func capsuled(opacity: CGFloat = 0.2, horizontalPadding: CGFloat = 8, verticalPadding: CGFloat = 2) -> some View {
        modifier(Capsuled(opacity: opacity, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding))
    }
}
