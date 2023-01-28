//
//  SpaceSelectionView.swift
//  QuickUp
//
//  Created by 堅書 on 28/1/23.
//

import SwiftUI

struct SpaceSelectionView: View {
    
    @Binding var appState: QuickUpState
    @Binding var workspaces: [CUWorkspace]
    
    @Binding var workspaceIndex: Int
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 24.0) {
            Picker(selection: $workspaceIndex) {
                ForEach(0..<workspaces.count, id: \.self) { i in
                    Text(workspaces[i].name).tag(i)
                }
            } label: { }
                .pickerStyle(.menu)
                .onChange(of: workspaceIndex, perform: { newValue in
                    appState = .spaces
                })
            Button {
                appState = .spaces
            } label: {
                Text("Cancel")
            }
            .keyboardShortcut(.cancelAction)
        }
            .frame(minWidth: 250.0)
            .padding(24.0)
    }
}
