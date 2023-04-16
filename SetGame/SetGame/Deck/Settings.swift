//
//  Settings.swift
//  SetGame
//
//  Created by pilotns on 15.04.2023.
//

import Foundation
import ComposableArchitecture

struct Settings: Reducer {
    struct State: Equatable {
        var isShowHint: Bool = true
    }
    
    enum Action: Equatable {
        case showHintToggle
    }
    
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
