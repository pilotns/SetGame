//
//  CardBackView.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI

struct CardBackView: View {
    private let letters = ["S", "E", "T"]
    
    var body: some View {
        GeometryReader { geometry in
            let minSide = geometry.size.width
            ZStack {
                ContainerRelativeShape()
                    .inset(by: 2)
                    .foregroundColor(.purple.opacity(0.2))
                
                VStack(spacing: minSide * 0.1) {
                    ForEach(letters, id: \.self) { character in
                        cube(character, in: geometry.size)
                            .frame(width: minSide * 0.25 * 1.5, height: minSide * 0.25)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
    
    @ViewBuilder
    func cube(_ character: String, in size: CGSize) -> some View {
        let minSide = min(size.width, size.height)
        let offset = minSide * 0.07
        let lineWidth = offset * 0.1
        
        let shape = Rectangle()
        let strockedShape = shape.strokeBorder(lineWidth: lineWidth)
        
        ZStack {
            Group {
                shape.foregroundColor(.white)
                strockedShape
                
                StripedBackground(lines: 20)
                    .clipShape(Rectangle())
            }
            .offset(x: offset, y: offset)
            
            Group {
                shape
            }
            
            Group {
                ZStack {
                    shape.foregroundColor(.white)
                    strockedShape
                    
                    let fontSize = min(size.width, size.height) * 0.25
                    Text(character)
                        .font(.system(size: fontSize, design: .serif))
                        .rotationEffect(.degrees(90))
                }
            }
            .offset(x: -offset, y: -offset)
        }
        .foregroundColor(.purple)
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackView()
    }
}
