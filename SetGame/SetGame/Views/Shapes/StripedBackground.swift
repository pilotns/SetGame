//
//  StripedBackground.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI

struct StripedBackground: View {
    let lines: Int
    
    var body: some View {
        Canvas { context, size in
            let step = size.width / CGFloat(lines)
            var currentPoint: CGPoint = .zero
            let rect = CGRect(origin: .zero, size: size)

            let minY = rect.minY
            let maxY = rect.maxY
            
            var p = Path()
            
            repeat {
                currentPoint = CGPoint(x: currentPoint.x + step, y: minY)
                p.move(to: currentPoint)
                p.addLine(to: CGPoint(x: currentPoint.x, y: maxY))
            } while currentPoint.x < size.width
            
            p.closeSubpath()
            
            context.stroke(p, with: .foreground)
        }
    }
}

struct StripedBackground_Previews: PreviewProvider {
    static var previews: some View {
        StripedBackground(lines: 20)
    }
}
