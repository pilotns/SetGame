//
//  CardView.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI

import SwiftUI
import ComposableArchitecture

struct CardView: View {
    let store: StoreOf<Card>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { card in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 5)
                let strokedShape = shape.strokeBorder(lineWidth: card.isSelected ? 1 : 0.5)

                if card.isSelected {
                    shape.shadow(radius: 1)
                }

                shape
                strokedShape
                    .foregroundColor(card.isSelected ? .orange : .gray.opacity(0.6))

                CardAppearance(card: card.state)
                    .containerShape(shape)
            }
            .foregroundColor(.white)
            .aspectRatio(2/3, contentMode: .fit)
            .scaleEffect(card.isSelected ? 1.1 : 1, anchor: .top)
            .rotation3DEffect(card.isSelected ? .degrees(-5) : .degrees(0), axis: (x: 1, y: 0.5, z: 0))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            store: Store(
                initialState: Card.State(state: .dealt, face: .mock),
                reducer: Card()
            )
        )
    }
}

fileprivate extension Card.State {
    var rotationAnchor: UnitPoint {
        switch state {
        case .dealt: return .zero
        case .undealt: return .bottomLeading
        case .discarded: return .bottomTrailing
        }
    }
}
