//
//  CardFaceView.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI

struct CardFaceView: View {
    let face: Card.Face
    
    var body: some View {
        face.appearance
            .padding()
    }
}

struct CardFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CardFaceView(face: .mock)
    }
}

fileprivate extension Card.Face {
    @ViewBuilder
    var appearance: some View {
        switch self.symbol {
        case .diamond:
            applyStyle(to: Diamond())
                
        case .rectangle:
            applyStyle(to: Rectangle())
            
        case .ellipse:
            applyStyle(to: Ellipse())
        }
    }
    
    private func applyStyle<S: InsettableShape>(to shape: S) -> some View {
        shape.style(
            shading: self.shading,
            color: self.color,
            number: self.number
        )
        .drawingGroup()
    }
}

fileprivate extension Shape where Self: InsettableShape, Self: Shape {
    @ViewBuilder
    func style(
        shading: Card.Face.Shading,
        color: Card.Face.Color,
        number: Card.Face.Number) -> some View
    {
        VStack {
            ForEach(0...number.rawValue, id: \.self) { _ in
                let shape = self.strokeBorder(lineWidth: 1.5)
                Group {
                    switch shading {
                    case .filled:
                        self
                    case .stroked:
                        shape
                    case .stripped:
                        StripedBackground(lines: 12)
                            .clipShape(self)
                            .overlay(shape)
                    }
                }
                .aspectRatio(2, contentMode: .fit)
            }
        }
        .foregroundColor(self.color(for: color))
    }
    
    private func color(for faceColor: Card.Face.Color) -> Color {
        let foregroundColor: Color
        switch faceColor {
        case .purple:
            foregroundColor = .purple
        case .green:
            foregroundColor = .green
        case .red:
            foregroundColor = .red
        }
        
        return foregroundColor
    }
}
