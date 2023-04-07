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
            ZStack {
                WithViewStore(self.store, observe: \.discarded) { deck in
                    ForEachStore(self.store.scope(state: \.discarded, action: Deck.Action.card(id:action:))) { card in
                        WithViewStore(card.actionless, observe: \.id) { id in
                            CardView(store: card)
                                .matchedGeometryEffect(id: id.state, in: namespace)
                                .transition(.identity.animation(.default))
                                .rotationEffect(
                                    rotationAngle(of: id.state, in: deck.state),
                                    anchor: .bottomTrailing
                                )
                        }
                    }
                    .animation(.default, value: deck.state)
                }
            }
            
            Spacer()
            
            ZStack {
                WithViewStore(self.store, observe: \.undealt) { deck in
                    ForEachStore(self.store.scope(state: \.undealt, action: Deck.Action.card(id:action:))) { card in
                        WithViewStore(card.actionless, observe: \.id) { id in
                            let index = index(of: id.state, in: deck.state)
                            
                            CardView(store: card)
                                .matchedGeometryEffect(id: id.state, in: namespace)
                                .transition(.identity.animation(.default))
                                .rotationEffect(
                                    rotationAngle(of: id.state, in: deck.state),
                                    anchor: .bottomLeading)
                                .zIndex(Double(-index))
                                .animation(nil, value: id.state)
                                .onTapGesture {
                                    deck.send(.deal, animation: .default)
                                }
                        }
                    }
                    .animation(.default, value: deck.state)
                }
            }
        }
        .background(.ultraThinMaterial)
    }
    
    private func rotationAngle(of cardId: UUID, in deck: IdentifiedArrayOf<Card.State>) -> Angle {
        let offset = 3.0
        let slicedCards = 12
        
        let card = deck.first { $0.id == cardId }
        let index = index(of: cardId, in: deck)
        
        switch card?.state {
        case let .some(state):
            switch state {
            case .undealt:
                return index < slicedCards
                ? .degrees(-Double(slicedCards - index) * offset)
                : .degrees(0)
                
            case .discarded:
                return index < slicedCards
                ? .degrees(Double(index) * offset)
                : .degrees(Double(slicedCards) * offset)
                
            default: return .degrees(0)
            }
            
        default: return .degrees(0)
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
