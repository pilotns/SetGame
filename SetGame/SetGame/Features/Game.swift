//
//  Game.swift
//  SetGame
//
//  Created by pilotns on 17.04.2023.
//

import Foundation
import ComposableArchitecture

struct Game: Reducer {
    @Dependency(\.continuousClock) private var clock
    
    // MARK: -
    // MARK: State
    struct State: Equatable {
        var deck = Deck.State()
        var geometry = Geometry.State()
        var statistic = Statistic.State()
        var settings = Settings.State()
    }
    
    // MARK: -
    // MARK: Action
    enum Action: Equatable {
        case newGame
        case gameOver
        case canDeal
        case isSet
        case showHint
        case deck(Deck.Action)
        case geometry(Geometry.Action)
        case statistic(Statistic.Action)
        case settings(Settings.Action)
    }
    
    // MARK: -
    // MARK: Reducer
    var body: some ReducerOf<Self> {
        Scope(state: \.deck, action: /Action.deck) {
            Deck()
        }
        
        Scope(state: \.geometry, action: /Action.geometry) {
            Geometry()
        }
        
        Scope(state: \.statistic, action: /Action.statistic) {
            Statistic()
        }
        
        Scope(state: \.settings, action: /Action.settings) {
            Settings()
        }
        
        Reduce { state, action in
            switch action {
            case .newGame:
                state.deck = Deck.State()
                return .send(.statistic(.reset))
                
            case .gameOver:
                return .send(.statistic(.end))
                
            case .canDeal:
                let deck = state.deck
                
                return deck.dealt.isEmpty && deck.discarded.isEmpty
                ? .merge(.send(.deck(.deal)), .send(.statistic(.begin)))
                : state.isSetsAvailable
                  ? .send(.geometry(.shake))
                  : .send(.deck(.deal))
                
            case .isSet:
                let selected = state.deck.selected
                
                return state.isSet(of: selected)
                ? .merge(.send(.deck(.discard)), .send(.statistic(.setFound)))
                : .send(.deck(.deselect))
                
            case .showHint:
                let hint = state.hint
                return !state.deck.dealt.isEmpty && state.settings.isShowHint
                ? .merge(
                    .concatenate(
                        hint.map { card in
                                .run { send in
                                    await send(.deck(.card(id: card.id, action: .select)))
                                    try await clock.sleep(for: .milliseconds(100))
                                    await send(.deck(.card(id: card.id, action: .select)))
                                }
                        }
                    ),
                    .send(.statistic(.useHint))
                )
                : .none
                
            case let .deck(action):
                switch action {
                case let .card(id: _, action: cardAction) where cardAction == .select:
                    return state.deck.selected.count == 3
                    ? .send(.isSet)
                    : .none
                
                case let .card(id: _, action: cardAction) where cardAction == .discard:
                    let deck = state.deck
                    return deck.undealt.isEmpty && !state.isSetsAvailable
                    ? .send(.gameOver)
                    : .none
                
                default: return .none
                }
                
            case .geometry:
                return .none
            case .statistic:
                return .none
            case .settings:
                return .none
            }
        }
    }
}

extension Game.State {
    func isSet(of cards: IdentifiedArrayOf<Card.State>) -> Bool {
        let result = Set(cards.map(\.face.symbol)).count.isOdd
            && Set(cards.map(\.face.shading)).count.isOdd
            && Set(cards.map(\.face.color)).count.isOdd
            && Set(cards.map(\.face.number)).count.isOdd
        
        return result
    }
}

extension Game.State {
    enum HintQuantity {
        case all
        case atLeast(_ quantity: UInt)
    }
    
    var hint: IdentifiedArrayOf<Card.State> {
        hints(.atLeast(1)).first ?? []
    }
    
    var isSetsAvailable: Bool {
        !hint.isEmpty
    }
    
    func hints(_ quantity: HintQuantity) -> [IdentifiedArrayOf<Card.State>] {
        findHint(deck.dealt, quantity: quantity)
    }
    
    private func findHint(_ cards: IdentifiedArrayOf<Card.State>, quantity: HintQuantity) -> [IdentifiedArrayOf<Card.State>] {
        var hints = [IdentifiedArrayOf<Card.State>]()
        let dropped = IdentifiedArray(uniqueElements: cards.dropFirst())
        let count = cards.count
        
        if dropped.isEmpty {
            return []
        }
        
        for i in 0..<count {
            for j in 1..<count {
                if i < j && j < count - 1 {
                    if case let .atLeast(q) = quantity, hints.count == q {
                        return hints + []
                    }
                    
                    let hint: IdentifiedArrayOf<Card.State> = [cards[0], dropped[i], dropped[j]]
                    if isSet(of: hint) {
                        hints.append(hint)
                    }
                } else {
                    continue
                }
            }
        }

        if case let .atLeast(q) = quantity, q > 0 {
            return hints + findHint(dropped, quantity: .atLeast(q - UInt(hints.count)))
        }
        
        return hints + findHint(dropped, quantity: quantity)
    }
}
