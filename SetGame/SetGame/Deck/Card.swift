//
//  Card.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation
import ComposableArchitecture

struct Card: Reducer {
    struct State: Equatable, Identifiable {
        enum State {
            case dealt
            case undealt
            case discarded
        }
        
        var id: UUID = UUID()
        var state: State
        var isSelected = false
        let face: Face
        
        init(id: UUID? = nil,
             state: State = .undealt,
             isSelected: Bool = false,
             face: Face)
        {
            @Dependency(\.uuid) var uuid
            self.id = id ?? uuid()
            self.state = state
            self.isSelected = isSelected
            self.face = face
        }
    }
    
    enum Action: Equatable {
        case deal
        case select
        case discard
        case reset
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .deal:
            state.state = .dealt
            
            return .none
        case .select:
            state.isSelected.toggle()
            
            return .none
        case .discard:
            state.state = .discarded
            
            return .none
            
        case .reset:
            state.state = .undealt
            
            return state.isSelected
            ? .send(.select)
            : .none
        }
    }
}

extension Card.State {
    var isDealt: Bool { state == .dealt }
    var isUndealt: Bool { state == .undealt }
    var isDiscarded: Bool { state == .discarded }
}
