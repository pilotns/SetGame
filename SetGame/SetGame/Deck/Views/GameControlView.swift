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
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                HStack {
                    DeckView(
                        store: self.store,
                        type: .discardPile,
                        namespace: namespace
                    )
                    
                    Spacer()
                    
                    DeckView(
                        store: self.store,
                        type: .deck,
                        namespace: namespace
                    )
                    .onTapGesture {
                        ViewStore(
                            self.store.stateless
                        )
                        .send(.deal)
                    }
                }
                .frame(height: 120)
            }
            
            Form {
                Group {
                    WithViewStore(self.store, observe: \.statistic.currentGame) { game in
                        Section("Game statistic") {
                            if game.state.secondsElapsed == 0 {
                                Text("Deal cards to start game..")
                            } else {
                                LabeledContent("Time elapsed:", value: game.timeElapsed)
                                LabeledContent("Sets found:", value: game.foundSets, format: .number)
                            }
                        }
                    }
                    
                    WithViewStore(self.store, observe: \.statistic.bestGame) { game in
                        Section("Best game") {
                            if game.state.secondsElapsed == 0 {
                                Text("No records found about previous games.")
                            } else {
                                LabeledContent("Time elapsed:", value: game.timeElapsed)
                                LabeledContent("Sets found:", value: game.foundSets, format: .number)
                            }
                        }
                    }
                }
                .environment(\.locale, .init(identifier: "en_US"))
                
                WithViewStore(self.store, observe: \.settings) { settings in
                    Section {
                        Toggle("Show hints?", isOn: settings.binding(
                            get: { $0.isShowHint },
                            send: .settings(.showHintToggle)
                            )
                        )
                    } header: {
                        Text("Settings")
                    } footer: {
                        Text("You can ask for a hint by long pressing on the game table.")
                    }
                }
                
                Section {
                    Button("New game") {
                        ViewStore(self.store.stateless).send(.newGame)
                    }
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
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
    @Namespace static var namespace
    static var previews: some View {
        GameControlView(
            store: Store(initialState: Deck.State(), reducer: Deck()),
            namespace: namespace
        )
    }
}
