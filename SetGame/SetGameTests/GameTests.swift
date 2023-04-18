//
//  GameTests.swift
//  SetGameTests
//
//  Created by pilotns on 18.04.2023.
//

import XCTest
import ComposableArchitecture
@testable import SetGame

@MainActor
final class GameTests: XCTestCase {
    
    func testDealing() async {
        let store = TestStore(
            initialState: Game.State(),
            reducer: Game()) {
                $0.uuid = .incrementing
                $0.continuousClock = ImmediateClock()
                $0.dataManager = .testValue
            }
        
        store.exhaustivity = .off
        
        await store.send(.canDeal)
        await store.receive(.deck(.deal))
        await store.receive(.statistic(.begin))
        
        await store.send(.canDeal)
        await store.receive(.geometry(.shake))
    }
    
    func testFoundMatchingSet() async {
        let store = TestStore(
            initialState: Game.State(),
            reducer: Game()) {
                $0.uuid = .incrementing
                $0.continuousClock = ImmediateClock()
                $0.dataManager = .testValue
            }
        
        store.exhaustivity = .off
        
        await store.send(.canDeal)
        await store.receive(.deck(.deal))
        await store.receive(.statistic(.begin))
        
        await store.send(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)))
        await store.send(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)))
        await store.send(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)))
        
        await store.receive(.isSet)
        await store.receive(.deck(.discard))
    }
    
    func testFoundWrongSet() async {
        let store = TestStore(
            initialState: Game.State(),
            reducer: Game()) {
                $0.uuid = .incrementing
                $0.continuousClock = ImmediateClock()
                $0.dataManager = .testValue
            }
        
        store.exhaustivity = .off
        
        await store.send(.canDeal)
        await store.receive(.deck(.deal))
        await store.receive(.statistic(.begin))
        
        await store.send(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)))
        await store.send(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)))
        await store.send(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .select)))
        
        await store.receive(.isSet)
        await store.receive(.deck(.deselect))
    }
    
    func testShowHint() async {
        let store = TestStore(
            initialState: Game.State(),
            reducer: Game()) {
                $0.uuid = .incrementing
                $0.continuousClock = ImmediateClock()
                $0.dataManager = .testValue
            }
        
        store.exhaustivity = .off
        
        await store.send(.canDeal)
        await store.receive(.deck(.deal))
        await store.receive(.statistic(.begin))
        
        await store.send(.showHint)
        await store.receive(.statistic(.useHint))
        await store.receive(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)))
        await store.receive(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)))
        await store.receive(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)))
        await store.receive(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)))
        await store.receive(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)))
        await store.receive(.deck(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)))
        
        // Turn off hint
        await store.send(.settings(.showHintToggle))
        await store.send(.showHint)
    }
    
    func testGameOver() async {
        let store = TestStore(
            initialState: Game.State(),
            reducer: Game()) {
                $0.uuid = .incrementing
                $0.continuousClock = ImmediateClock()
                $0.dataManager = .testValue
            }
        
        store.exhaustivity = .off
        
        await store.send(.canDeal)
        await store.receive(.deck(.deal))
        await store.receive(.statistic(.begin))
        
        for card in store.state.deck.cards {
            await store.send(.deck(.card(id: card.id, action: .discard)))
        }
        
        await store.receive(.gameOver)
        await store.receive(.statistic(.end))
    }
    
    func testNewGame() async {
        let store = TestStore(
            initialState: Game.State(),
            reducer: Game()) {
                $0.uuid = .incrementing
                $0.continuousClock = ImmediateClock()
                $0.dataManager = .testValue
            }
        
        store.exhaustivity = .off
        
        await store.send(.canDeal)
        await store.receive(.deck(.deal))
        await store.receive(.statistic(.begin))
        
        let cards = store.state.deck.cards
        
        for index in 0..<cards.count - 10 {
            await store.send(.deck(.card(id: cards[index].id, action: .discard)))
        }
        
        await store.send(.newGame)
        await store.receive(.statistic(.reset))
    }
}
































