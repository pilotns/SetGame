//
//  Face.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation

extension Card {
    struct Face: Hashable {
        let symbol: Symbol
        let shading: Shading
        let color: Color
        let number: Number
        
        enum Symbol: CaseIterable {
            case diamond
            case rectangle
            case ellipse
        }
        
        enum Shading: CaseIterable {
            case stroked
            case stripped
            case filled
        }
        
        enum Color: CaseIterable {
            case purple
            case green
            case red
        }
        
        enum Number: Int, CaseIterable {
            case one
            case two
            case three
        }
    }
}

extension Card.Face  {
    static var mock: Self {
        .init(symbol: .diamond,
              shading: .stripped,
              color: .purple,
              number: .three)
    }
    
    static var allFaces: [Self] {
        var result: [Self] = []
        Symbol.allCases.forEach { symbol in
            Shading.allCases.forEach { shading in
                Color.allCases.forEach { color in
                    Number.allCases.forEach { number in
                        result.append(
                            .init(
                                symbol: symbol,
                                shading: shading,
                                color: color,
                                number: number
                            )
                        )
                    }
                }
            }
        }
        
        return result
    }
}
