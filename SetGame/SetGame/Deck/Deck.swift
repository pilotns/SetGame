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
        
        // MARK: -
        // MARK: Public
        func deal() -> Effect<Action> {
            @Dependency(\.continuousClock) var clock
            return .run(priority: .high) { send in
                for (index, card) in toDeal.enumerated() {
                    try await clock.sleep(for: .milliseconds(100))
                    await send(.card(id: card.id, action: .deal), animation: .default)
                }
            }
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
    }
    
    enum Action: Equatable {
        case deal
        case isSet
        case showHint
        case card(id: Card.State.ID, action: Card.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deal:
                return state.deal()
            
            case .isSet:
                return state.isSet
                ? state.discard()
                : state.deselectSelected()
                
            case .showHint:
                
                return .none
                
            case let .card(id: _, action: action) where action == .select:
                return state.selected.count == 3
                ? .send(.isSet)
                : .none
            
            case let .card(id: _, action: action) where action == .discard:
                return state.discard()
                
            case .card:
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
    func hints(quantity: HintQuantity) -> [IdentifiedArrayOf<Card.State>] {
        return findHint(dealt, quantity: quantity)
    }
    
    enum HintQuantity {
        case all
        case atLeast(_ quantity: UInt)
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
