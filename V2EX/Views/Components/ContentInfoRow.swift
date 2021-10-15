//
//  ContentInfoRow.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/14.
//

import Kingfisher
import SwiftUI

struct ContentInfoRow: View {
    let author: Author

    let date: String

    var body: some View {
        HStack(spacing: 12) {
            KFImage(author.avatarURL)
                .resizable()
                .frame(width: avatarSize, height: avatarSize)
                .cornerRadius(avatarCornerRadius)

            VStack(alignment: .leading) {
                Text(author.name)

                Spacer(minLength: 0)

                Text(date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .frame(height: avatarSize)
    }

    // MARK: - Constants

    private let avatarSize: CGFloat = 40
    private let avatarCornerRadius: CGFloat = 4
}

struct ContentInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        let author = Author(name: "shoujiaxin", avatarURL: URL(string: "https://cdn.v2ex.com/avatar/f9b7/ef66/257377_large.png?m=1514370922")!)
        let date = "2021-10-10 23:48:30 +08:00"
        ContentInfoRow(author: author, date: date)
            .previewLayout(.sizeThatFits)
    }
}
