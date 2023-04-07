//
//  Diamond.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI

struct Diamond: Shape {
    private var inset: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let top = CGPoint(x: rect.midX, y: rect.minY + inset)
        let left = CGPoint(x: rect.minX + inset, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY - inset)
        let right = CGPoint(x: rect.maxX - inset, y: rect.midY)
        
        p.move(to: top)
        p.addLine(to: left)
        p.addLine(to: bottom)
        p.addLine(to: right)
        p.addLine(to: top)
        
        p.closeSubpath()
        
        return p
    }
}

extension Diamond: InsettableShape {
    func inset(by amount: CGFloat) -> some InsettableShape {
        var insettable = self
        insettable.inset += amount
        
        return insettable
    }
}
