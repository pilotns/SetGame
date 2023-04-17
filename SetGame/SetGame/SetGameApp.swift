//
//  SetGameApp.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameDeskView(
                store: Store(
                    initialState: Game.State(),
                    reducer: Game()
                )
            )
        }
    }
}
