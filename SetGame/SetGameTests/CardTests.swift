//
//  CardTests.swift
//  SetGameTests
//
//  Created by pilotns on 07.04.2023.
//

import XCTest
import ComposableArchitecture
@testable import SetGame

@MainActor
final class CardTests: XCTestCase {
    func testCreation() async {
        let store = TestStore(
            initialState: Card.State(face: .mock),
            reducer: Card()) {
                $0.uuid = .incrementing
            }
        
        XCTAssertEqual(
            Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .undealt,
                isSelected: false,
                face: .mock),
            store.state
        )
    }
    
    func testDealing() async {
        let store = TestStore(
            initialState: Card.State(face: .mock),
            reducer: Card()) {
                $0.uuid = .incrementing
            }
        
        await store.send(.deal) {
            $0.state = .dealt
        }
    }
    
    func testDiscarding() async {
        let store = TestStore(
            initialState: Card.State(face: .mock),
            reducer: Card()) {
                $0.uuid = .incrementing
            }
        
        await store.send(.discard) {
            $0.state = .discarded
        }
    }
    
    func testSelecting() async {
        let store = TestStore(
            initialState: Card.State(face: .mock),
            reducer: Card()) {
                $0.uuid = .incrementing
            }
        
        
        await store.send(.select) {
            $0.isSelected = true
        }
        
        await store.send(.select) {
            $0.isSelected = false
        }
    }
    
    func testResetingUnselected() async {
        let store = TestStore(
            initialState: Card.State(face: .mock),
            reducer: Card()) {
                $0.uuid = .incrementing
            }
    
        await store.send(.deal) {
            $0.state = .dealt
        }
        
        await store.send(.reset) {
            $0.state = .undealt
        }
    }
    
    func testResetingSelected() async {
        let store = TestStore(
            initialState: Card.State(face: .mock),
            reducer: Card()) {
                $0.uuid = .incrementing
            }
    
        await store.send(.deal) {
            $0.state = .dealt
        }
        
        await store.send(.select) {
            $0.isSelected = true
        }
        
        await store.send(.reset) {
            $0.state = .undealt
        }
        
        await store.receive(.select) {
            $0.isSelected = false
        }
    }
}
