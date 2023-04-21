//
//  Page.swift
//  SetGame
//
//  Created by pilotns on 19.04.2023.
//

import Foundation
import ComposableArchitecture

struct Page: Reducer {
    struct State: Equatable {
        enum Page: String, Equatable, CaseIterable {
            case statistic
            case settings
        }
        
        var selected: Page = .statistic
    }
    
    enum Action: Equatable {
        case select(State.Page)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .select(page):
                state.selected = page
                
                return .none
            }
        }
    }
}
