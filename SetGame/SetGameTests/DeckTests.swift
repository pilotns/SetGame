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
    
    func testFirstDealing() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck()
        ) {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        XCTAssertEqual(store.state.undealt.count, 81)
        XCTAssertEqual(store.state.dealt.isEmpty, true)
        XCTAssertEqual(store.state.discarded.isEmpty, true)
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
        
        XCTAssertEqual(store.state.undealt.count, 81 - 12)
        XCTAssertEqual(store.state.dealt.count, 12)
        XCTAssertEqual(store.state.discarded.isEmpty, true)
        XCTAssertEqual(store.state.selected.count, 0)
    }
    
    func testSecondDealing() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck())
        {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        // MARK: -
        // MARK: First deal
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
        
        // MARK: -
        // MARK: Selecting first set
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
        
        await store.receive(.isSet)
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

        // MARK: -
        // MARK: Selecting second set
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .select)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }

        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, action: .select)) {
            $0.cards[4] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .two))
        }

        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, action: .select)) {
            $0.cards[5] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .three))
        }
        
        await store.receive(.isSet)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .select)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, action: .select)) {
            $0.cards[4] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .two))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, action: .select)) {
            $0.cards[5] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .discard)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, action: .discard)) {
            $0.cards[4] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .two))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, action: .discard)) {
            $0.cards[5] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .three))
        }
        
        
        // MARK: -
        // MARK: Selecting third set
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, action: .select)) {
            $0.cards[6] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .one))
        }

        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, action: .select)) {
            $0.cards[7] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .two))
        }

        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, action: .select)) {
            $0.cards[8] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .three))
        }
        
        await store.receive(.isSet)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, action: .select)) {
            $0.cards[6] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .one))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, action: .select)) {
            $0.cards[7] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .two))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, action: .select)) {
            $0.cards[8] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, action: .discard)) {
            $0.cards[6] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .one))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, action: .discard)) {
            $0.cards[7] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .two))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, action: .discard)) {
            $0.cards[8] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .red, number: .three))
        }
        
        // MARK: -
        // MARK: Selecting fourth set
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, action: .select)) {
            $0.cards[9] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .one))
        }

        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!, action: .select)) {
            $0.cards[10] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .two))
        }

        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!, action: .select)) {
            $0.cards[11] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .three))
        }
        
        await store.receive(.isSet)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, action: .select)) {
            $0.cards[9] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .one))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!, action: .select)) {
            $0.cards[10] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .two))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!, action: .select)) {
            $0.cards[11] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, action: .discard)) {
            $0.cards[9] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .one))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!, action: .discard)) {
            $0.cards[10] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .two))
        }

        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!, action: .discard)) {
            $0.cards[11] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!,
                state: .discarded,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .purple, number: .three))
        }
        
        // MARK: -
        // MARK: Second deal
        await store.send(.deal)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000C")!, action: .deal)) {
            $0.cards[12] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000C")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .green, number: .one))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000D")!, action: .deal)) {
            $0.cards[13] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000D")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .green, number: .two))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-00000000000E")!, action: .deal)) {
            $0.cards[14] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000E")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stripped, color: .green, number: .three))
        }
        
        XCTAssertEqual(store.state.undealt.count, 81 - 12 - 3)
        XCTAssertEqual(store.state.dealt.count, 3)
        XCTAssertEqual(store.state.discarded.isEmpty, false)
        XCTAssertEqual(store.state.selected.count, 0)
    }
    
    func testSelectingSingle() async {
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
        
        XCTAssertEqual(store.state.selected.count, 1)
    }
    
    func testSelectingMatchingSet() async {
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
        
        XCTAssertEqual(store.state.selected.count, 0)
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select))  {
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
        
        await store.receive(.isSet)
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
    }
    
    func testSelectingWrongSet() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck()
        ) {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        store.exhaustivity = .off(showSkippedAssertions: true)
        
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
        
        XCTAssertEqual(store.state.selected.count, 0)
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, action: .select))  {
            $0.cards[1] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
        }
        
        await store.send(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .select)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }
        
        XCTAssertEqual(store.state.selected.count, 3)
        
        await store.receive(.isSet)
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
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, action: .select)) {
            $0.cards[3] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .green, number: .one))
        }
        
        XCTAssertEqual(store.state.selected.count, 0)
    }
    
    func testHint() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck())
        {
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
        
        XCTAssertEqual(store.state.hints(.atLeast(0)).count, 0)
        XCTAssertEqual(store.state.hints(.atLeast(1)).count, 1)
        XCTAssertEqual(store.state.hints(.atLeast(2)).count, 2)
        XCTAssertEqual(store.state.hints(.atLeast(3)).count, 3)
        XCTAssertEqual(store.state.hints(.atLeast(4)).count, 4)
        XCTAssertEqual(store.state.hints(.atLeast(5)).count, 5)
        XCTAssertEqual(store.state.hints(.atLeast(6)).count, 6)
        XCTAssertEqual(store.state.hints(.atLeast(7)).count, 7)
        XCTAssertEqual(store.state.hints(.atLeast(8)).count, 8)
        XCTAssertEqual(store.state.hints(.atLeast(9)).count, 9)
        XCTAssertEqual(store.state.hints(.atLeast(10)).count, 10)
        XCTAssertEqual(store.state.hints(.atLeast(11)).count, 11)
        XCTAssertEqual(store.state.hints(.atLeast(12)).count, 12)
        XCTAssertEqual(store.state.hints(.atLeast(13)).count, 13)
        
        XCTAssertEqual(store.state.hints(.atLeast(14)).count, 13)
        XCTAssertEqual(store.state.hints(.atLeast(15)).count, 13)
        
        XCTAssertEqual(store.state.hints(.all).count, 13)
    }
    
    func testGameControlOffset() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck())
        {
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
        
        await store.send(.deal)
        await store.receive(.geometry(.updateGameControlOffset(CGSize(width: 0, height: 30)))) {
            $0.geometry.gameControlOffset = CGSize(width: 0, height: 30)
        }
        
        await store.receive(.geometry(.updateCardRotationMultiplier(0.9))) {
            $0.geometry.cardRotationMultiplier = 0.9
        }
        
        await store.receive(.geometry(.updateGameControlOffset(.zero))) {
            $0.geometry.gameControlOffset = .zero
        }
        
        await store.receive(.geometry(.updateCardRotationMultiplier(1))) {
            $0.geometry.cardRotationMultiplier = 1
        }
    }
    
    func testGameControlHeight() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck())
        {
            $0.uuid = .incrementing
            $0.continuousClock = ImmediateClock()
        }
        
        await store.send(.geometry(.updateGameControlHeight(300))) {
            $0.geometry.gameControlHeight = 300
        }
    }
    
    func testShowHint() async {
        let store = TestStore(
            initialState: Deck.State(),
            reducer: Deck())
        {
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
        
        await store.send(.showHint)
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .select)) {
            $0.cards[0] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                state: .dealt,
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .one))
        }
    
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
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .two))
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
                isSelected: true,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
        await store.receive(.card(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, action: .select)) {
            $0.cards[2] = Card.State(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                state: .dealt,
                isSelected: false,
                face: .init(symbol: .diamond, shading: .stroked, color: .purple, number: .three))
        }
        
    }
}
