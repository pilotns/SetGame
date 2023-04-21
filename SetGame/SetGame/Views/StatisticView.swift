//
//  StatisticView.swift
//  SetGame
//
//  Created by pilotns on 19.04.2023.
//

import SwiftUI
import ComposableArchitecture

fileprivate typealias P = Page.State.Page

struct StatisticView: View {
    let store: StoreOf<Game>
    
    var body: some View {
        VStack {
            Form {
                WithViewStore(self.store, observe: \.page) { page in
                    Picker(
                        "Picker", selection: page.binding(
                            get: \.selected,
                            send: { .page(.select($0)) }
                        )
                        .animation()
                    ) {
                        ForEach(P.allCases, id: \.self) { p in
                            Text(p.rawValue.capitalized)
                                .tag(p)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(.zero)
                    .listRowBackground(Color.clear)
                }
                
                WithViewStore(self.store, observe: \.page) { page in
                    switch page.state.selected {
                    case .statistic:
                        Group {
                            WithViewStore(self.store.actionless, observe: \.statistic.currentGame) { game in
                                Section("Current game") {
                                    gameInfo(
                                        for: game.state,
                                        missedGameDescription: "Deal cards to start game..."
                                    )
                                }
                            }
                            
                            WithViewStore(self.store.actionless, observe: \.statistic.bestGame) { game in
                                Section("Best game") {
                                    gameInfo(
                                        for: game.state,
                                        missedGameDescription: "No records found about previous games."
                                    )
                                }
                            }
                        }
                        .environment(\.locale, .init(identifier: "en_US"))
                        
                    case .settings:
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
                            
                            Section {
                                Button("New game") {
                                    settings.send(.newGame)
                                }
                            }
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
        }
    }
    
    @ViewBuilder
    private func gameInfo(for game: Statistic.State.GameStatistic, missedGameDescription: String) -> some View {
        if game.secondsElapsed == 0 {
            Text(missedGameDescription)
                .italic()
                .foregroundColor(.secondary)
        } else {
            LabeledContent("Time elapsed:", value: game.timeElapsed)
            LabeledContent("Sets found:", value: game.foundSets, format: .number)
            LabeledContent("Used hints:", value: "\(game.usedHints)")
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(store: Store(
            initialState: Game.State(),
            reducer: Game())
        )
    }
}
