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
                WithViewStore(self.store, observe: \.dealt) { deck in
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                        ForEachStore(self.store.scope(state: \.dealt, action: Deck.Action.card(id:action:))) { card in
                            WithViewStore(card, observe: \.id) { id in
                                CardView(store: card)
                                    .matchedGeometryEffect(id: id.state, in: dealing)
                                    .transition(.identity.animation(.default))
                                    .onTapGesture {
                                        id.send(.select, animation: .easeInOut)
                                    }
                            }
                        }
                    }
                    .animation(.default, value: deck.state)
                    .padding(.horizontal)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            WithViewStore(self.store, observe: \.geometry) { geometryStore in
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(.clear)
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .frame(maxHeight: 15)
                        .overlay {
                            Capsule()
                                .frame(maxWidth: 30, maxHeight: 5)
                                .foregroundColor(.gray)
                        }
                        .gesture(dragGesture(geometryStore))
                    
                    GameControlView(store: self.store, namespace: dealing)
                }
                .background(.ultraThinMaterial)
                .frame(height: geometryStore.state.gameControlHeight)
                .offset(geometryStore.state.gameControlOffset)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @State private var previousTranslation: CGSize = .zero
    
    private func dragGesture(_ geometryStore: ViewStore<Geometry.State, Deck.Action>) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                let translationAmount = value.translation.height - previousTranslation.height
                let newHeight: CGFloat
                
                let currentHeight = geometryStore.state.gameControlHeight
                
                if currentHeight - translationAmount < Constants.GameControl.height {
                    newHeight = currentHeight - translationAmount * 0.2
                } else {
                    newHeight = currentHeight - translationAmount
                }
                
                geometryStore.send(.geometry(.updateGameControlHeight(newHeight)))
                previousTranslation = value.translation
            }
            .onEnded { value in
                previousTranslation = .zero
                let currentHeight = geometryStore.state.gameControlHeight
                _ = currentHeight < Constants.GameControl.height
                ? geometryStore.send(.geometry(.resetGameControlHeight))
                : geometryStore.send(.geometry(.updateGameControlHeight(currentHeight)))
            }
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
