//
//  Optional+Extensions.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import Foundation

public extension Optional {
    func apply<Result>(_ transform: ((Wrapped) -> Result)?) -> Result? {
        self.flatMap { value in
            transform.map { $0(value) }
        }
    }
    
    func apply<Value, Result>(_ value: Value?) -> Result?
        where Wrapped == (Value) -> Result
    {
        value.apply(self)
    }
    
    func flatten<Result>() -> Result? where Wrapped == Result? {
        self?.flatMap { $0 }
    }
    
    func `do`(_ action: (Wrapped) -> Void) {
        self.map(action)
    }
}
