//
//  V2EXApp.swift
//  V2EX
//
//  Created by Jiaxin Shou on 2021/10/10.
//

import SwiftUI

@main
struct V2EXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
