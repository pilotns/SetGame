//
//  Settings.swift
//  SetGame
//
//  Created by pilotns on 15.04.2023.
//

import Foundation
import ComposableArchitecture

struct Settings: Reducer {
    
    // MARK: -
    // MARK: State
    struct State: Equatable {
        var isShowHint: Bool = true
    }
    
    // MARK: -
    // MARK: Action
    enum Action: Equatable {
        case showHintToggle
    }
    
    // MARK: -
    // MARK: Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showHintToggle:
                state.isShowHint.toggle()
                
                return .none
            }
        }
    }
}
