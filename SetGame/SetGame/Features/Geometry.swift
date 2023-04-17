//
//  Geometry.swift
//  SetGame
//
//  Created by pilotns on 11.04.2023.
//

import Foundation
import ComposableArchitecture

struct Geometry: Reducer {
    @Dependency(\.continuousClock) private var clock
    
    // MARK: -
    // MARK: State
    struct State: Equatable {
        var gameControlHeight: CGFloat = Constants.GameControl.height
        var gameControlOffset: CGSize = Constants.GameControl.offset
        var cardRotationMultiplier: CGFloat = Constants.GameControl.rotationMultiplier
        
        func calculateHeight(for translationAmount: CGFloat) -> CGFloat {
            let newHeight: CGFloat
            let currentHeight = gameControlHeight
            
            if currentHeight - translationAmount < Constants.GameControl.height {
                newHeight = currentHeight - translationAmount * 0.2
            } else {
                newHeight = currentHeight - translationAmount
            }
            
            return newHeight
        }
    }
    
    // MARK: -
    // MARK: Action
    enum Action: Equatable {
        case shake
        case resetGameControlHeight
        case beganDragGesture(translationAmount: CGFloat)
        case endDragGesture
        case updateGameControlHeight(CGFloat)
        case updateGameControlOffset(CGSize)
        case updateCardRotationMultiplier(CGFloat)
    }
    
    // MARK: -
    // MARK: Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .shake:
                return .run { send in
                    let size = CGSize(width: 0, height: 30)
                    await send(.updateGameControlOffset(size),
                        animation: .easeInOut(duration: 0.1))
                    
                    await send(.updateCardRotationMultiplier(0.9),
                        animation: .easeInOut(duration: 0.2))
                    
                    try await clock.sleep(for: .milliseconds(0.1))
                    await send(.updateGameControlOffset(.zero),
                        animation: .easeInOut(duration: 0.1))
                    
                    await send(.updateCardRotationMultiplier(Constants.GameControl.rotationMultiplier),
                        animation: .easeInOut(duration: 0.2).delay(0.1))
                }
            case .resetGameControlHeight:
                return .run { send in
                    await send(.updateCardRotationMultiplier(0.9))
                    await send(.updateGameControlHeight(Constants.GameControl.height))
                    await send(.updateCardRotationMultiplier(Constants.GameControl.rotationMultiplier),
                               animation: .easeIn(duration: 0.1))
                }
                
            case let .beganDragGesture(translationAmount: amount):
                let newHeight = state.calculateHeight(for: amount)
                return .send(.updateGameControlHeight(newHeight))
                
            case .endDragGesture:
                return state.gameControlHeight < Constants.GameControl.height
                ? .send(.resetGameControlHeight)
                : .none
                
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
