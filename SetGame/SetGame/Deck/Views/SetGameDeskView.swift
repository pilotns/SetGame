//
//  SetGameDeskView.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI
import ComposableArchitecture

struct SetGameDeskView: View {
    let store: StoreOf<Deck>
    
    @Namespace private var dealing
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEachStore(self.store.scope(state: \.dealt, action: Deck.Action.card(id:action:))) { card in
                        WithViewStore(card, observe: \.id) { id in
                            CardView(store: card)
                                .matchedGeometryEffect(id: id.state, in: dealing)
                                .transition(.identity.animation(.easeInOut))
                                .onTapGesture {
                                    id.send(.select, animation: .easeInOut)
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .safeAreaInset(edge: .bottom) {
            GameControlView(store: self.store, namespace: dealing)
                .frame(maxHeight: 140)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SetGameDeskView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameDeskView(
            store: Store(
                initialState: Deck.State(),
                reducer: Deck()
            )
        )
    }
}
