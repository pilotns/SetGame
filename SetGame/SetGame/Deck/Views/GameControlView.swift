//
//  GameControlView.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI
import ComposableArchitecture

struct GameControlView: View {
    let store: StoreOf<Deck>
    let namespace: Namespace.ID
    
    var body: some View {
        HStack {
            WithViewStore(self.store.actionless, observe: \.discarded) { deck in
                ZStack {
                    ForEachStore(self.store.scope(state: \.discarded, action: Deck.Action.card(id:action:))) { card in
                        WithViewStore(self.store.actionless, observe: \.geometry) { geometryStore in
                            WithViewStore(card.actionless, observe: \.id) { id in
                                CardView(store: card)
                                    .matchedGeometryEffect(id: id.state, in: namespace)
                                    .transition(.identity.animation(.default))
                                    .rotationEffect(
                                        .degrees(rotationAmount(for: id.state, in: deck.state) * geometryStore.cardRotationMultiplier),
                                        anchor: .bottomTrailing
                                    )
                            }
                        }
                    }
                    .animation(.default, value: deck.state)
                }
                .frame(height: 150)
            }
            
            Spacer()
            
            WithViewStore(self.store, observe: \.undealt) { deck in
                ZStack {
                    ForEachStore(self.store.scope(state: \.undealt, action: Deck.Action.card(id:action:))) { card in
                        WithViewStore(card.actionless, observe: \.id) { id in
                            let index = index(of: id.state, in: deck.state)
                            WithViewStore(self.store, observe: \.geometry) { geometryStore in
                                CardView(store: card)
                                    .matchedGeometryEffect(id: id.state, in: namespace)
                                    .transition(.identity.animation(.default))
                                    .rotationEffect(
                                        .degrees(rotationAmount(for: id.state, in: deck.state) * geometryStore.cardRotationMultiplier),
                                        anchor: .bottomLeading)
                                    .zIndex(Double(-index))
                                    .animation(nil, value: id.state)
                                    .onTapGesture {
                                        deck.send(.deal, animation: .default)
                                    }
                            }
                        }
                    }
                    .animation(.default, value: deck.state)
                }
                .frame(height: 150)
            }
        }
    }
    
    private func rotationAmount(for cardId: UUID, in deck: IdentifiedArrayOf<Card.State>) -> Double {
        let offset = 3.0
        let slicedCards = 8
        
        let card = deck.first { $0.id == cardId }
        let index = index(of: cardId, in: deck)
        
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
    
    private func index(of cardId: UUID, in deck: IdentifiedArrayOf<Card.State>) -> Int {
        deck.first { $0.id == cardId }
            .flatMap(deck.firstIndex(of:)) ?? 0
    }
}

fileprivate extension Card.State {
    var rotationAnchor: UnitPoint {
        switch state {
        case .dealt: return .center
        case .undealt: return .bottomLeading
        case .discarded: return .bottomTrailing
        }
    }
}

struct GameControlView_Previews: PreviewProvider {
    @Namespace static var n
    static var previews: some View {
        GameControlView(
            store: Store(initialState: Deck.State(), reducer: Deck()),
            namespace: n)
    }
}
