//
//  SearchView.swift
//  Scryfall
//
//  Created by C250 on 5/16/22.
//

import SwiftUI

struct CardList: View {
    @State var cards: [Card] = []
    let layout = [GridItem(.adaptive(minimum: 200))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(cards, id:\.id) { item in
                    CardPreview(card: item)
                }
            }
        }
    }
}

struct SearchView: View {
    static let limiter = TaskLimiter()
    
    @State var query = ""
    @State var data: [Card] = []
    @State var nextPage: Request<ListResponse>? = nil
    
    let layout = [GridItem(.adaptive(minimum: 200))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(data, id:\.id) { item in
                    CardPreview(card: item)
                }
                if let nextPage = nextPage {
                    ProgressView().onAppear {
                        Task {
                            let page = try await nextPage.perform()
                            self.data += page.data
                            self.nextPage = page.nextPageRequest
                        }
                    }
                }
            }
        }
        .searchable(text: $query)
        .onChange(of: query) { newValue in
            Task {
                await Self.limiter.debounce(for: 0.5, operation: {
                    let results = try await Search(q: newValue).perform()
                    self.data = results.data
                    self.nextPage = results.nextPageRequest
                })
            }
        }
        .navigationTitle("Search")
    }
}
