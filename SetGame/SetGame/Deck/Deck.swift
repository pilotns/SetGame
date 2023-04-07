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
            .concatenate(
                toDeal.map {
                    .send(.card(id: $0.id, action: .deal), animation: .easeInOut.delay(0.1))
                }
            )
        }
        
        func discard() -> Effect<Action> {
            .concatenate(
                selected.map {
                    .send(.card(id: $0.id, action: .select))
                }
                +
                selected.map {
                    .send(.card(id: $0.id, action: .discard), animation: .easeInOut.delay(0.1))
                }
            )
        }
        
        func deselectSelected() -> Effect<Action> {
            .concatenate(
                selected.map {
                    .send(.card(id: $0.id, action: .select), animation: .easeInOut.delay(0.1))
                }
            )
        }
        
        var isSet: Bool {
            return Set(cards.map(\.face.symbol)).count.isOdd
                || Set(cards.map(\.face.shading)).count.isOdd
                || Set(cards.map(\.face.color)).count.isOdd
                || Set(cards.map(\.face.number)).count.isOdd
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
    }
    
    enum Action: Equatable {
        case deal
        case isSet
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
