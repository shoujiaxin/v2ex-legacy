//
//  ContentView.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import CoreData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Topic Tab")
                .tabItem {
                    Label("Topic", systemImage: "captions.bubble.fill")
                }

            Text("Me Tab")
                .tabItem {
                    Label("Me", systemImage: "person.text.rectangle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
