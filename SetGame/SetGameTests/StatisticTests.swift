//
//  StatisticTests.swift
//  SetGameTests
//
//  Created by pilotns on 16.04.2023.
//

import XCTest
import ComposableArchitecture
@testable import SetGame

@MainActor
final class StatisticTests: XCTestCase {

    func testBeginTickEnd() async {
        let store = TestStore(
            initialState: Statistic.State(),
            reducer: Statistic()
        ) {
            $0.continuousClock = ImmediateClock()
            $0.dataManager = .testValue
        }
        
        store.exhaustivity = .off
        
        await store.send(.begin)
        await store.receive(.tick) {
            $0.currentGame.secondsElapsed = 1
        }
        await store.receive(.tick) {
            $0.currentGame.secondsElapsed = 2
        }
        await store.receive(.tick) {
            $0.currentGame.secondsElapsed = 3
        }
        await store.receive(.tick) {
            $0.currentGame.secondsElapsed = 4
        }
        
        await store.send(.end)
    }
    
    func testFoundSet() async {
        let store = TestStore(
            initialState: Statistic.State(),
            reducer: Statistic()
        ) {
            $0.continuousClock = ImmediateClock()
            $0.dataManager = .testValue
        }
        
        await store.send(.setFound) {
            $0.currentGame.foundSets = 1
        }
    }

    func testReset() async {
        let store = TestStore(
            initialState: Statistic.State(),
            reducer: Statistic()
        ) {
            $0.continuousClock = ImmediateClock()
            $0.dataManager = .testValue
        }
        
        store.exhaustivity = .off
        
        await store.send(.begin)
        
        await store.send(.setFound) {
            $0.currentGame.foundSets = 1
        }
        
        await store.send(.setFound) {
            $0.currentGame.foundSets = 2
        }
        
        await store.send(.reset) {
            $0.currentGame = Statistic.State.GameStatistic()
        }
    }
}
