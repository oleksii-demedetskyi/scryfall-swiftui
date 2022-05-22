//
//  ContentView.swift
//  Shared
//
//  Created by C250 on 5/12/22.
//

import SwiftUI

let example = "https://c1.scryfall.com/file/scryfall-cards/normal/front/6/d/6da045f8-6278-4c84-9d39-025adf0789c1.jpg?1562404626"

enum Screen {
    case search
    case select
    case empty
}

struct DeckModel: Identifiable {
    let id = UUID()
    var name = "New deck"
}

struct DeckList: View {
    @State var decks: [DeckModel] = []
    //@Binding var selection: AnyHashable
    
    
    var body: some View {
        Label("Add deck", systemImage: "plus").onTapGesture {
            decks.append(DeckModel())
        }
        
        ForEach(decks) { deck in
            //NavigationLink(tag: deck.id, selection: $selection, destination: CardList()) {
                Label(deck.name, systemImage: "menucard")
            //}
            
        }
    }
}


struct Sidebar: View {
    @State var section: Screen? = .search
    var body: some View {
        List(selection: $section) {
            NavigationLink(tag: Screen.search, selection: $section, destination: SearchView.init) {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationLink(tag: Screen.select, selection: $section, destination: SelectorView.init) {
                Label("Select", systemImage: "equal.circle")
            }
            
            Section("My Decks") {
                DeckList()
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Scryfall")
    }
}

struct ContentView: View {
    #if os(iOS)
    var iosBody: some View {
        NavigationView {
            SearchView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    #elseif os(macOS)
    var macBody: some View {
        NavigationView {
            Sidebar()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: { // 1
                    Image(systemName: "sidebar.leading")
                })
            }
        }
        .frame(width: 800, height: 800, alignment: .center)
    }
    #endif
    
    var body: some View {
#if os(iOS)
        iosBody
#elseif os(macOS)
        macBody
#endif
    }
    
    private func toggleSidebar() { // 2
#if os(iOS)
#else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
