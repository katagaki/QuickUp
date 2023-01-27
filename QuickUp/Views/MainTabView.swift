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
            SpacesView()
                .tabItem {
                    Image("IconSpace")
                    Text("Spaces")
                }
            Color.clear // TODO: Implement view for inputting API key
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
