//
//  SettingsView.swift
//  QuickUp
//
//  Created by 堅書 on 28/1/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var appState: QuickUpState
    
    @State var apiToken: String = ""
    
    var body: some View {
        #if os(macOS)
        VStack(alignment: .trailing, spacing: 24.0) {
            HStack(spacing: 8.0) {
                Text("ClickUp Personal API Token")
                TextField(text: $apiToken) {
                    Text("pk_12345678_ABCD1234")
                }
            }
            HStack(spacing: 8.0) {
                Button {
                    NSWorkspace.shared.open(URL(string: "https://clickup.com/api/developer-portal/authentication/#generate-your-personal-api-token")!)
                } label: {
                    Text("Generate Personal API Token")
                }
                Spacer()
                Button {
                    appState = .spaces
                } label: {
                    Text("Cancel")
                }
                .keyboardShortcut(.cancelAction)
                Button {
                    defaults.setValue(apiToken, forKey: "Token.Personal")
                    appState = .spaces
                } label: {
                    Text("Save")
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .onAppear {
            apiToken = defaults.string(forKey: "Token.Personal") ?? ""
        }
        .frame(minWidth: 500.0)
        .padding(24.0)
        #else
        NavigationStack {
            List {
                Section("ClickUp Personal API Token") {
                    TextField(text: $apiToken) {
                        Text("pk_12345678_ABCD1234")
                    }
                    Button {
                        defaults.setValue(apiToken, forKey: "Token.Personal")
                    } label: {
                        Text("Save")
                    }
                }
                Section {
                    Button {
                        UIApplication.shared.open(URL(string: "https://clickup.com/api/developer-portal/authentication/#generate-your-personal-api-token")!)
                    } label: {
                        HStack {
                            Image(systemName: "safari")
                            Text("Generate Personal API Token")
                        }
                    }
                }
            }
            .onAppear {
                apiToken = defaults.string(forKey: "Token.Personal") ?? ""
            }
            .navigationTitle("Settings")
        }
        #endif
    }
}
