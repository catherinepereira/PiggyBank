//
//  PiggyBankApp.swift
//  PiggyBank
//
//  Created by Catherine Pereira on 11/27/24.
//

import SwiftUI

@main
struct PiggyBankApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
