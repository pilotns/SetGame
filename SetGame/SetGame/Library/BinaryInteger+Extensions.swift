//
//  BinaryInteger+Extensions.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation

public extension BinaryInteger {
    var isOdd: Bool {
        return !isMultiple(of: 2)
    }
}
