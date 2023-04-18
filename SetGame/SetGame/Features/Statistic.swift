//
//  Statistic.swift
//  SetGame
//
//  Created by pilotns on 14.04.2023.
//

import Foundation
import ComposableArchitecture

struct DataManager: Sendable {
    var save: @Sendable (Data, URL) throws -> Void
    var load: @Sendable (URL) throws -> Data
}

extension DataManager: DependencyKey {
    static let liveValue = Self(
        save: { data, url in try data.write(to: url) },
        load: { url in try Data(contentsOf: url) }
    )
}

extension DependencyValues {
    var dataManager: DataManager {
        get { self[DataManager.self] }
        set { self[DataManager.self] = newValue }
    }
}

fileprivate extension URL {
    static var statistic: URL {
        URL.documentsDirectory.appending(path: "statistin.json")
    }
}

struct Statistic: Reducer {
    @Dependency(\.continuousClock) private var clock
    
    // MARK: -
    // MARK: State
    struct State: Equatable {
        var currentGame = GameStatistic()
        var bestGame = GameStatistic(url: .statistic) {
            didSet {
                bestGame.save()
            }
        }
        
        struct GameStatistic: Equatable, Codable {
            var secondsElapsed: UInt
            var foundSets: UInt
            var usedHints: UInt
            
            init() {
                self.secondsElapsed = 0
                self.foundSets = 0
                self.usedHints = 0
            }
            
            init(url: URL) {
                @Dependency(\.dataManager) var dataManager
                
                do {
                    let data = try dataManager.load(url)
                    self = try JSONDecoder().decode(Self.self, from: data)
                } catch {
                    self = GameStatistic()
                }
            }
            
            func isBetter(then game: GameStatistic) -> Bool {
                self.secondsElapsed <= game.secondsElapsed
                    && self.foundSets >= game.foundSets
                    && self.usedHints <= game.usedHints
                    || (self.secondsElapsed > 0 && game.secondsElapsed == 0)
            }
            
            func save() {
                @Dependency(\.dataManager) var dataManager
                do {
                    let data = try JSONEncoder().encode(self)
                    try dataManager.save(data, .statistic)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: -
    // MARK: State
    enum Action: Equatable {
        case begin
        case end
        case tick
        case reset
        case setFound
        case useHint
    }

    private struct TimerID: Hashable {}
    
    // MARK: -
    // MARK: Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .begin:
                state.currentGame = State.GameStatistic()
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.tick)
                    }
                }
                .cancellable(id: TimerID(), cancelInFlight: true)
                
            case .end:
                let currentGame = state.currentGame
                let bestGame = state.bestGame
                
                if currentGame.isBetter(then: bestGame) {
                    state.bestGame = currentGame
                }

                return .cancel(id: TimerID())
            
            case .tick:
                state.currentGame.secondsElapsed += 1
                return .none
                
            case .reset:
                state.currentGame = State.GameStatistic()
                
                return .none
                
            case .setFound:
                state.currentGame.foundSets += 1
                return .none
                
            case .useHint:
                state.currentGame.usedHints += 1
                return .none
            }
        }
    }
}

extension Statistic.State.GameStatistic {
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
