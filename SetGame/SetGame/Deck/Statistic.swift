//
//  Statistic.swift
//  SetGame
//
//  Created by pilotns on 14.04.2023.
//

import Foundation
import ComposableArchitecture

struct Statistic: Reducer {
    struct GameStatistic: Equatable {
        var secondsElapsed: UInt = 0
        var foundSets: UInt = 0
    }
    
    @Dependency(\.continuousClock) private var clock
    struct State: Equatable {
        var currentGame = GameStatistic()
        var bestGame = GameStatistic()
    }
    
    enum Action: Equatable {
        case begin
        case end
        case tick
        case reset
        case foundSet
    }

    private struct TimerID: Hashable {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .begin:
                state.currentGame = GameStatistic()
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.tick)
                    }
                }
                .cancellable(id: TimerID(), cancelInFlight: true)
                
            case .end:
                let currentGame = state.currentGame
                let bestGame = state.bestGame
                if bestGame.secondsElapsed > currentGame.secondsElapsed
                    && bestGame.foundSets < currentGame.foundSets
                    || (bestGame.secondsElapsed == 0 && currentGame.secondsElapsed > 0)
                {
                    state.bestGame = currentGame
                }

                return .cancel(id: TimerID())
            
            case .tick:
                state.currentGame.secondsElapsed += 1
                return .none
                
            case .reset:
                state.currentGame = GameStatistic()
                
                return .send(.end)
                
            case .foundSet:
                state.currentGame.foundSets += 1
                return .none
            }
        }
    }
}

extension Statistic.GameStatistic {
    var timeElapsed: String {
        var calendar = Calendar.current
        let formatter = DateComponentsFormatter()
        
        calendar.locale = Locale(identifier: "en_US")
        formatter.calendar = calendar
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: TimeInterval(secondsElapsed)) ?? ""
    }
}
