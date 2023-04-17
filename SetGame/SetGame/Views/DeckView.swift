//
//  DeckView.swift
//  SetGame
//
//  Created by pilotns on 15.04.2023.
//

import SwiftUI
import ComposableArchitecture

struct DeckView: View {
    let store: StoreOf<Game>
    let type: `Type`
    let namespace: Namespace.ID
    
    var body: some View {
        WithViewStore(self.store.actionless, observe: keyPath) { deck in
            ZStack {
                ForEachStore(self.store.scope(state: keyPath, action: { .deck(.card(id: $0.0, action: $0.1)) })) { card in
                    WithViewStore(self.store.actionless, observe: \.geometry) { geometryStore in
                        WithViewStore(card.actionless, observe: \.id) { id in
                            CardView(store: card)
                                .matchedGeometryEffect(id: id.state, in: namespace)
                                .transition(.identity.animation(.default))
                                .zIndex(zIndex(for: id.state, in: deck.state))
                                .rotationEffect(
                                    .degrees(rotationAmount(for: id.state, in: deck.state) * geometryStore.cardRotationMultiplier),
                                    anchor: rotationAnchor
                                )
                        }
                    }
                }
                .animation(.default, value: deck.state)
            }
        }
    }
    
    private var keyPath: (Game.State) -> IdentifiedArrayOf<Card.State> {
        switch type {
        case .deck: return \.deck.undealt
        case .discardPile: return \.deck.discarded
        }
    }
    
    private var rotationAnchor: UnitPoint {
        switch self.type {
        case .deck: return .bottomLeading
        case .discardPile: return .bottomTrailing
        }
    }
    
    private func zIndex(for cardId: UUID, in deck: IdentifiedArrayOf<Card.State>) -> Double {
        let index = Double(index(of: cardId, in: deck))
        
        return self.type == .deck ? -index : index
    }
    
    private func index(of cardId: UUID, in deck: IdentifiedArrayOf<Card.State>) -> Int {
        deck.index(id: cardId) ?? 0
    }
    
    private func rotationAmount(for cardId: UUID, in deck: IdentifiedArrayOf<Card.State>) -> Double {
        let offset = 3.0
        let slicedCards = 8
        
        let card = deck.first { $0.id == cardId }
        let index = deck.index(id: cardId) ?? 0
        
        switch card?.state {
        case let .some(state):
            switch state {
            case .undealt:
                return index < slicedCards
                ? -Double(min(slicedCards, deck.count - 1) - index) * offset
                : .zero
                
            case .discarded:
                return index < slicedCards
                ? Double(index) * offset
                : Double(slicedCards) * offset
                
            default: return .zero
            }
            
        default: return .zero
        }
    }
}

extension DeckView {
    enum `Type` {
        case deck
        case discardPile
    }
}

struct DeckView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        DeckView(
            store: Store(
                initialState: Game.State(),
                reducer: Game()),
            type: .deck,
            namespace: namespace)
    }
}
