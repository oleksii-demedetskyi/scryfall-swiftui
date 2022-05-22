//
//  SelectorView.swift
//  Scryfall
//
//  Created by C250 on 5/16/22.
//

import SwiftUI

struct SelectorView: View {
    static let limiter = TaskLimiter()
    
    @State var number: String = ""
    @State var set: String = ""
    @State var lang: String = ""
    @State var finish: String = ""
    @State var card: Card? = Card()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Card number", text: $number)
                TextField("Set", text: $set)
                TextField("Locale", text: $lang)
                
            }
            if let card = card {
                HStack {
                    CardPreview(card: card)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Finishes:")
                            ForEach(card.finishes, id: \.self) { kind in
                                Text(kind)
                                    .background(finish == kind ? Color.yellow.opacity(0.5) : Color.gray)
                                    .onTapGesture {
                                        finish = kind
                                    }
                            }
                        }
                        HStack {
                            Text("Prices:")
                            
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
            }
            Spacer()
        }
        .onChange(of: number) { _ in findCard() }
        .onChange(of: set) { _ in findCard() }
        .onChange(of: lang) { _ in findCard() }
        .navigationTitle("Select a card")
    }
    
    func findCard() {
        guard !number.isEmpty, !set.isEmpty else { return }
        let lang = lang.isEmpty ? "EN" : lang
        Task {
            await Self.limiter.debounce(for:0.2) {
                let card = try await CardRequest(lang: lang, number: number, set: set).perform()
                self.card = card
                if let card = card, card.finishes.isEmpty == false {
                    if !card.finishes.contains(finish) {
                        finish = card.finishes[0]
                    }
                }
            }
        }
        
    }
}

struct Previews_SelectorView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorView()
    }
}
