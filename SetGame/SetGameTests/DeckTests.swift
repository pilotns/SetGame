//
//  DeckTests.swift
//  DeckTests
//
//  Created by pilotns on 07.04.2023.
//

import XCTest
import ComposableArchitecture
@testable import SetGame

@MainActor
final class DeckTests: XCTestCase {
    func testDealind() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck()
        ) {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        XCTAssertEqual(store.state.toDeal.count, 12)
        XCTAssertEqual(store.state.dealt.count, 0)
        XCTAssertEqual(store.state.discarded.count, 0)
        XCTAssertEqual(store.state.selected.count, 0)
        
        await store.send(.deal)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .deal)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .deal)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .deal)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .deal)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, action: .deal)) {
            $0.cards[4] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, action: .deal)) {
            $0.cards[5] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, action: .deal)) {
            $0.cards[6] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, action: .deal)) {
            $0.cards[7] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, action: .deal)) {
            $0.cards[8] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, action: .deal)) {
            $0.cards[9] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!, action: .deal)) {
            $0.cards[10] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!, action: .deal)) {
            $0.cards[11] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .three))
        }
        
        XCTAssertEqual(store.state.toDeal.count, 3)
        XCTAssertEqual(store.state.dealt.count, 12)
        XCTAssertEqual(store.state.discarded.count, 0)
        XCTAssertEqual(store.state.selected.count, 0)
    }
    
    func testDiscarding() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck()
        ) {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        await store.send(.deal)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .deal)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .deal)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .deal)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .deal)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, action: .deal)) {
            $0.cards[4] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, action: .deal)) {
            $0.cards[5] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, action: .deal)) {
            $0.cards[6] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, action: .deal)) {
            $0.cards[7] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, action: .deal)) {
            $0.cards[8] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, action: .deal)) {
            $0.cards[9] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!, action: .deal)) {
            $0.cards[10] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!, action: .deal)) {
            $0.cards[11] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .three))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        XCTAssertEqual(store.state.selected.count, 3)
        
        await store.send(.discard)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .discard)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .discard)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .discard)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        XCTAssertEqual(store.state.selected.count, 0)
        XCTAssertEqual(store.state.discarded.count, 3)
    }
    
    func testDeselecting() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck()
        ) {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        await store.send(.deal)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .deal)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .deal)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .deal)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .deal)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, action: .deal)) {
            $0.cards[4] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, action: .deal)) {
            $0.cards[5] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, action: .deal)) {
            $0.cards[6] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, action: .deal)) {
            $0.cards[7] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, action: .deal)) {
            $0.cards[8] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, action: .deal)) {
            $0.cards[9] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!, action: .deal)) {
            $0.cards[10] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!, action: .deal)) {
            $0.cards[11] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .three))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        XCTAssertEqual(store.state.selected.count, 3)
        
        await store.send(.deselect)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select)) {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        XCTAssertEqual(store.state.selected.count, 0)
    }
}

