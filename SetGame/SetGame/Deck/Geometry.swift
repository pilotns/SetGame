//
//  Geometry.swift
//  SetGame
//
//  Created by pilotns on 11.04.2023.
//

import Foundation
import ComposableArchitecture

struct Geometry: Reducer {
    struct State: Equatable {
        var gameControlHeight: CGFloat = Constants.GameControl.height
        var gameControlOffset: CGSize = Constants.GameControl.offset
        var cardRotationMultiplier: CGFloat = Constants.GameControl.rotationMultiplier
    }
    
    enum Action: Equatable {
        case resetGameControlHeight
        case updateGameControlHeight(CGFloat)
        case updateGameControlOffset(CGSize)
        case updateCardRotationMultiplier(CGFloat)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .resetGameControlHeight:
                return .run { send in
                    await send(.updateCardRotationMultiplier(0.9))
                    await send(.updateGameControlHeight(Constants.GameControl.height))
                    await send(.updateCardRotationMultiplier(Constants.GameControl.rotationMultiplier), animation: .easeInOut(duration: 0.2))
                }
                
            case let .updateGameControlHeight(height):
                state.gameControlHeight = height
                
                return .none
            case let .updateGameControlOffset(size):
                state.gameControlOffset = size
                
                return .none
                
            case let .updateCardRotationMultiplier(multiplier):
                state.cardRotationMultiplier = multiplier
                
                return .none
            }
        }
    }
}
