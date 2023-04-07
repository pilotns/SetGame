//
//  CardAppearance.swift
//  SetGame
//
//  Created by pilotns on 07.04.2023.
//

import SwiftUI

struct CardAppearance: View {
    let card: Card.State
    
    var body: some View {
        Group {
            if card.state == .undealt {
                CardBackView()
            } else {
                CardFaceView(face: card.face)
            }
        }
    }
}

struct CardAppearance_Previews: PreviewProvider {
    static var previews: some View {
        CardAppearance(card: .init(face: .mock))
    }
}
