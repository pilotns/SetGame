//
//  SetGameDeskView.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI
import ComposableArchitecture

struct SetGameDeskView: View {
    let store: StoreOf<Game>
    
    @Namespace private var dealing
    
    var body: some View {
        ZStack {
            WithViewStore(self.store, observe: \.deck.dealt) { deck in
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                        ForEachStore(self.store.scope(state: \.deck.dealt, action: { .deck(.card(id: $0.0, action: $0.1)) })) { card in
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
                .onLongPressGesture {
                    deck.send(.showHint)
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
    
    private func dragGesture(_ geometryStore: ViewStore<Geometry.State, Game.Action>) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                let amount = value.translation.height - previousTranslation.height
                geometryStore.send(
                    .geometry(
                        .beganDragGesture(
                            translationAmount: amount
                        )
                    )
                )
                
                previousTranslation = value.translation
            }
            .onEnded { value in
                previousTranslation = .zero
                geometryStore.send(.geometry(.endDragGesture))
            }
    }
}

struct SetGameDeskView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameDeskView(
            store: Store(
                initialState: Game.State(),
                reducer: Game()
            )
        )
    }
}
