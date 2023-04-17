//
//  Deck.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation
import ComposableArchitecture

struct Deck: Reducer {
    @Dependency(\.continuousClock) private var clock
    
    // MARK: -
    // MARK: State
    struct State: Equatable {
        var cards: IdentifiedArrayOf<Card.State> = Self.cards
        
        var toDeal: [Card.State] {
            Array(undealt[0..<dealSize])
                .map { $0 }
        }

        private var dealSize: Int {
            dealt.isEmpty && discarded.isEmpty
            ? 12
            : min(3, undealt.count)
        }
    }
    
    // MARK: -
    // MARK: Actions
    enum Action: Equatable {
        case deal
        case discard
        case deselect
        case card(id: Card.State.ID, action: Card.Action)
    }
    
    // MARK: -
    // MARK: Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deal:
                let cards = state.toDeal
                return .run { send in
                    for card in cards {
                        try await clock.sleep(for: .milliseconds(100))
                        await send(.card(id: card.id, action: .deal), animation: .default)
                    }
                }
                
            case .discard:
                let selected = state.selected
                return .concatenate(
                    selected.map {
                        .send(.card(id: $0.id, action: .select))
                    }
                    +
                    selected.map {
                        .send(.card(id: $0.id, action: .discard), animation: .easeInOut)
                    }
                )
                
            case .deselect:
                return .concatenate(
                    state.selected.map {
                        .send(.card(id: $0.id, action: .select), animation: .easeInOut)
                    }
                )
                
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
    var dealt: IdentifiedArrayOf<Card.State> { cards.filter(\.isDealt) }
    var undealt: IdentifiedArrayOf<Card.State> { cards.filter(\.isUndealt) }
    var discarded: IdentifiedArrayOf<Card.State> { cards.filter(\.isDiscarded) }
    var selected: IdentifiedArrayOf<Card.State> { dealt.filter(\.isSelected) }
}
