//
//  TaskToolbarView.swift
//  QuickUp
//
//  Created by Justin Xin on 2023/01/27.
//

import SwiftUI

struct TaskToolbarView: View {
    
    @Binding var task: CUTask?
    
    var body: some View {
        if let task = task {
            HStack(spacing: 4.0) {
                Button {
                    #if os(iOS)
                    UIPasteboard.general.string = task.url
                    #elseif os(macOS)
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(task.url, forType: .string)
                    #endif
                } label: {
                    Text("Copy Link")
                }
                #if os(iOS)
                Spacer()
                #endif
                Button {
                    #if os(iOS)
                    UIApplication.shared.open(URL(string: task.url)!)
                    #elseif os(macOS)
                    NSWorkspace.shared.open(URL(string: task.url)!)
                    #endif
                } label: {
                    #if os(iOS)
                    Image(systemName: "safari")
                    #elseif os(macOS)
                    Text("Open in Website")
                    #endif
                }
                #if os(macOS)
                Button {
                    NSWorkspace.shared.open(URL(string: task.desktopClientURL())!)
                } label: {
                    Text("Open in ClickUp.app")
                }
                #endif
            }
        }
    }
}
