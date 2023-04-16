//
//  SettingsTests.swift
//  SetGameTests
//
//  Created by pilotns on 16.04.2023.
//

import XCTest
import ComposableArchitecture
@testable import SetGame

@MainActor
final class SettingsTests: XCTestCase {
    func testHintToggle() async {
        let store = TestStore(
            initialState: Settings.State(),
            reducer: Settings()
        )
        
        await store.send(.showHintToggle) {
            $0.isShowHint = false
        }
        
        await store.send(.showHintToggle) {
            $0.isShowHint = true
        }
    }
}
