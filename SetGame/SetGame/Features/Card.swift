//
//  Card.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation
import ComposableArchitecture

struct Card: Reducer {
    
    // MARK: -
    // MARK: State
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
    
    // MARK: -
    // MARK: State
    enum Action: Equatable {
        case deal
        case select
        case discard
        case reset
    }
    
    // MARK: -
    // MARK: Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
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
}

extension Card.State {
    var isDealt: Bool { state == .dealt }
    var isUndealt: Bool { state == .undealt }
    var isDiscarded: Bool { state == .discarded }
}

extension Card {
    struct Face: Hashable {
        let symbol: Symbol
        let shading: Shading
        let color: Color
        let number: Number
        
        enum Symbol: CaseIterable {
            case diamond
            case rectangle
            case ellipse
        }
        
        enum Shading: CaseIterable {
            case stroked
            case stripped
            case filled
        }
        
        enum Color: CaseIterable {
            case purple
            case green
            case red
        }
        
        enum Number: Int, CaseIterable {
            case one
            case two
            case three
        }
    }
}

extension Card.Face  {
    static var mock: Self {
        .init(symbol: .diamond,
              shading: .stripped,
              color: .purple,
              number: .three)
    }
    
    static var allFaces: [Self] {
        var result: [Self] = []
        Symbol.allCases.forEach { symbol in
            Shading.allCases.forEach { shading in
                Color.allCases.forEach { color in
                    Number.allCases.forEach { number in
                        result.append(
                            .init(
                                symbol: symbol,
                                shading: shading,
                                color: color,
                                number: number
                            )
                        )
                    }
                }
            }
        }
        
        return result
    }
}
