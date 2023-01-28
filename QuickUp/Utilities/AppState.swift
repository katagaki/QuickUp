//
//  AppState.swift
//  QuickUp
//
//  Created by 堅書 on 28/1/23.
//

import Foundation

class AppState: ObservableObject, Equatable {
    
    @Published var current: QuickUpState = .spaces
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.current == rhs.current
    }
    
}

enum QuickUpState {
    case spaces
    case workspaceSelection
    case settings
}
