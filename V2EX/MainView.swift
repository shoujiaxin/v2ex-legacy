//
//  MainView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TopicTabList()
                .tabItem {
                    Label("Topic", systemImage: "bubble.left")
                }

            Text("Me Tab")
                .tabItem {
                    Label("Me", systemImage: "person")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
