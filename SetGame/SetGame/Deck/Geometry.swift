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
    
    enum Action: Equatable {
        case resetGameControlHeight
        case beganDragGesture(translationAmount: CGFloat)
        case endDragGesture
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
