//
//  GeometryTests.swift
//  SetGameTests
//
//  Created by pilotns on 16.04.2023.
//

import XCTest
import ComposableArchitecture
@testable import SetGame

@MainActor
final class GeometryTests: XCTestCase {
    
    func testUpdateViewState() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let deck = Geometry.State.GameControlState.deck
        let statistic = Geometry.State.GameControlState.statistic
        
        XCTAssertEqual(store.state.viewState, .deck)
        await store.send(.updateViewState(.statistic)) {
            $0.viewState = .statistic
        }
        
        await store.receive(.updateGameControlHeight(statistic.rawValue)) {
            $0.gameControlHeight = statistic.rawValue
        }
        
        XCTAssertEqual(store.state.viewState, statistic)
        XCTAssertEqual(store.state.gameControlHeight, statistic.rawValue)
    }
    
    func testUpdateGameControlHeight() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let newHeight: CGFloat = 125
        
        await store.send(.updateGameControlHeight(newHeight)) {
            $0.gameControlHeight = newHeight
        }
    }
    
    func testUpdateGameControlOffset() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let newOffset = CGSize(width: 0, height: 20)
        
        await store.send(.updateGameControlOffset(newOffset)) {
            $0.gameControlOffset = newOffset
        }
    }
    
    func testUpdateCardRotationMultiplier() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let multiplier = 0.9
        
        await store.send(.updateCardRotationMultiplier(multiplier)) {
            $0.cardRotationMultiplier = multiplier
        }
    }
    
    func testShake() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let offset = CGSize(width: 0, height: 30)
        
        await store.send(.shake)
        await store.receive(.updateGameControlOffset(offset)) {
            $0.gameControlOffset = offset
        }
        await store.receive(.updateCardRotationMultiplier(0.9)) {
            $0.cardRotationMultiplier = 0.9
        }
        await store.receive(.updateGameControlOffset(.zero)) {
            $0.gameControlOffset = .zero
        }
        await store.receive(.updateCardRotationMultiplier(Constants.GameControl.rotationMultiplier)) {
            $0.cardRotationMultiplier = Constants.GameControl.rotationMultiplier
        }
    }
    
    func testResetGameControlHeight() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let height: CGFloat = 100
        
        await store.send(.updateGameControlHeight(height)) {
            $0.gameControlHeight = height
        }
        
        await store.send(.resetGameControlHeight)
        
        await store.receive(.updateCardRotationMultiplier(0.9)) {
            $0.cardRotationMultiplier = 0.9
        }
        
        await store.receive(.updateGameControlHeight(Constants.GameControl.height)) {
            $0.gameControlHeight = Constants.GameControl.height
        }
        
        await store.receive(.updateCardRotationMultiplier(Constants.GameControl.rotationMultiplier)) {
            $0.cardRotationMultiplier = Constants.GameControl.rotationMultiplier
        }
    }
    
    func testBeganDragGesture() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let amount: CGFloat =  -20
        let newHeight = Constants.GameControl.height - amount
        await store.send(.beganDragGesture(translationAmount: amount))
        await store.receive(.updateGameControlHeight(newHeight)) {
            $0.gameControlHeight = newHeight
        }
    }
    
    func testEndDragGesture() async {
        let store = TestStore(
            initialState: Geometry.State(),
            reducer: Geometry()
        ) {
            $0.continuousClock = ImmediateClock()
        }
        
        let amount: CGFloat =  20
        let newHeight = Constants.GameControl.height - amount / 5
        await store.send(.beganDragGesture(translationAmount: amount))
        await store.receive(.updateGameControlHeight(newHeight)) {
            $0.gameControlHeight = newHeight
        }
        
        await store.send(.endDragGesture)
        await store.receive(.resetGameControlHeight)
        await store.receive(.updateCardRotationMultiplier(0.9)) {
            $0.cardRotationMultiplier = 0.9
        }
        
        await store.receive(.updateGameControlHeight(Constants.GameControl.height)) {
            $0.gameControlHeight = Constants.GameControl.height
        }
        
        await store.receive(.updateCardRotationMultiplier(Constants.GameControl.rotationMultiplier)) {
            $0.cardRotationMultiplier = Constants.GameControl.rotationMultiplier
        }
    }
}
