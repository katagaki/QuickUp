//
//  QuickUpApp.swift
//  QuickUp
//
//  Created by 堅書 on 7/10/22.
//

import SwiftUI

@main
struct QuickUpApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .commands {
            SidebarCommands()
        }
    }
}
