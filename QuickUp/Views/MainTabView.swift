//
//  MainTabView.swift
//  QuickUp
//
//  Created by 堅書 on 2023/01/27.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            SpacesView(appState: .constant(.spaces))
                .tabItem {
                    Image("IconSpace")
                    Text("Spaces")
                }
            SettingsView(appState: .constant(.settings)) // TODO: Implement view for inputting API key
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
