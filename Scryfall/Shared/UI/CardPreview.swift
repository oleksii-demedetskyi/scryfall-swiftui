//
//  CardPreview.swift
//  Scryfall
//
//  Created by C250 on 5/12/22.
//

import SwiftUI

struct CardPreview: View {
    let card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        AsyncImage(url: card.image) { phase in
            switch phase {
            case .empty:
                Group {
                    Image("Magic_card_back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .blur(radius: 5)
                }
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(let error):
                VStack(spacing: 16) {
                    Image(systemName: "xmark.octagon.fill")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                }
            @unknown default:
                Text("Unknown")
                    .foregroundColor(.gray)
            }
        }
    }
}


