//
//  Deck.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation
import ComposableArchitecture

struct Deck: Reducer {
    struct State: Equatable {
        // MARK: -
        // MARK: Properties
        var cards: IdentifiedArrayOf<Card.State> = Self.cards
        var geometry = Geometry.State()
        var statistic = Statistic.State()
        var settings = Settings.State()

        // MARK: -
        // MARK: Public
        func deal() -> Effect<Action> {
            return isSetsAvailable
            ? .send(.geometry(.shake))
            : dealingEffect
        }
        
        func discard() -> Effect<Action> {
            return .concatenate(
                selected.map {
                    .send(.card(id: $0.id, action: .select))
                }
                +
                selected.map {
                    .send(.card(id: $0.id, action: .discard), animation: .easeInOut)
                }
            )
        }
        
        func deselectSelected() -> Effect<Action> {
            .concatenate(
                selected.map {
                    .send(.card(id: $0.id, action: .select), animation: .easeInOut)
                }
            )
        }
        
        func showHint() -> Effect<Action> {
            @Dependency(\.continuousClock) var clock
            return settings.isShowHint
            ? .concatenate(
                hint.map { card in
                        .run { send in
                            await send(.card(id: card.id, action: .select))
                            try await clock.sleep(for: .milliseconds(100))
                            await send(.card(id: card.id, action: .select))
                        }
                }
            )
            : .none
        }
        
        var isSet: Bool {
            isSet(of: selected)
        }
        
        // MARK: -
        // MARK: Private
        private var toDeal: [Card.State] {
            Array(undealt[0..<dealSize])
                .map { $0 }
        }
        
        private var dealSize: Int {
            dealt.isEmpty && discarded.isEmpty
            ? 12
            : min(3, undealt.count)
        }
        
        private func isSet(of cards: IdentifiedArrayOf<Card.State>) -> Bool {
            let result = Set(cards.map(\.face.symbol)).count.isOdd
                && Set(cards.map(\.face.shading)).count.isOdd
                && Set(cards.map(\.face.color)).count.isOdd
                && Set(cards.map(\.face.number)).count.isOdd
            
            return result
        }
        
        private var dealingEffect: Effect<Action> {
            @Dependency(\.continuousClock) var clock
            let deal: Effect<Action> = .run(priority: .high) { [cards = toDeal] send in
                for card in cards {
                    try await clock.sleep(for: .milliseconds(100))
                    await send(.card(id: card.id, action: .deal), animation: .default)
                }
            }
            
            return dealt.isEmpty && discarded.isEmpty
            ? .merge(.send(.statistic(.begin)), deal)
            : deal
        }
    }
    
    enum Action: Equatable {
        case deal
        case isSet
        case showHint
        case gameOver
        case newGame
        case card(id: Card.State.ID, action: Card.Action)
        case geometry(Geometry.Action)
        case statistic(Statistic.Action)
        case settings(Settings.Action)
    }
    
    var body: some ReducerOf<Self> {
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
            case .deal:
                return state.deal()
                
            case .isSet:
                return state.isSet
                ? .merge(.send(.statistic(.foundSet)), state.discard())
                : state.deselectSelected()
                
            case .showHint:
                return state.showHint()
                
            case .gameOver:
                // TODO: Slide up GameControlView
                return .send(.statistic(.end))
                
            case .newGame:
                let cards = state.cards.filter { $0.state != .undealt }
                
                return .merge(
                    // TODO: Slide down GameControlView
                    .send(.statistic(.reset)),
                    .run { send in
                        for card in cards {
                            await send(.card(id: card.id, action: .reset))
                        }
                    }
                )
                
            case .geometry(_):
                return .none
                
            case let .card(id: _, action: action) where action == .select:
                return state.selected.count == 3
                ? .send(.isSet)
                : .none
                
            case .card:
                return .none
                
            case let .statistic(action) where action == .tick:
                return state.undealt.isEmpty && !state.isSetsAvailable
                ? .send(.gameOver)
                : .none
                
            case .statistic:
                return .none
                
            case .settings:
                return .none
            }
        }
        .forEach(\.cards, action: /Action.card(id:action:)) {
            Card()
        }
    }
}

extension Deck.State {
    static var cards: IdentifiedArrayOf<Card.State> {
        IdentifiedArrayOf(
            uniqueElements: Card.Face.allFaces
//                .shuffled()
                .map { Card.State(face: $0) }
        )
    }
}

extension Deck.State {
    var hint: IdentifiedArrayOf<Card.State> {
        hints(.atLeast(1)).first ?? []
    }
    
    var isSetsAvailable: Bool {
        !hint.isEmpty
    }
    
    enum HintQuantity {
        case all
        case atLeast(_ quantity: UInt)
    }
    
    func hints(_ quantity: HintQuantity) -> [IdentifiedArrayOf<Card.State>] {
        findHint(dealt, quantity: quantity)
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

extension Deck.State {
    var dealt: IdentifiedArrayOf<Card.State> { cards.filter(\.isDealt) }
    var undealt: IdentifiedArrayOf<Card.State> { cards.filter(\.isUndealt) }
    var discarded: IdentifiedArrayOf<Card.State> { cards.filter(\.isDiscarded) }
    var selected: IdentifiedArrayOf<Card.State> { dealt.filter(\.isSelected) }
}
