//
//  Search.swift
//  Scryfall (iOS)
//
//  Created by C250 on 5/14/22.
//

import Foundation

let baseURL = URL(string: "https://api.scryfall.com/")!

struct Card: Decodable {
    let id: String
    let finishes: [String]
    let prices: [String: String?]
    
    var image: URL {
        var components = URLComponents()
        components.path = "/cards/\(id)"
        components.queryItems = [
            URLQueryItem(name: "format", value: "image"),
            URLQueryItem(name: "version", value: "border_crop"),
        ]
        
        return components.url(relativeTo: baseURL)!
    }
    
    func price(finish: String) -> String {
        return "0"
    }
}

extension Card {
    init() {
        id = "a0e47d11-cb21-402b-a39e-588a94cc57b4"
        finishes = ["nonfoil", "foil"]
        prices = [
            "usd":"0.09",
            "usd_foil":"0.09"
        ]
    }
}

struct Warning: Decodable {
    
}

struct ListResponse: Decodable {
    let data: [Card]
    let hasMore: Bool
    let nextPage: URL?
    let totalCards: Int
    let warnings: [Warning]?
    
    var nextPageRequest: Request<ListResponse>? {
        nextPage.map(Request.init(url:))
    }
}

struct Request<R: Decodable> {
    let session = URLSession.shared
    let url: URL
    let body: Data? = nil
    
    init(path: String, query: [URLQueryItem] = []) {
        var components = URLComponents()
        components.path = path
        components.queryItems = query
        
        self.url = components.url(relativeTo: baseURL)!
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func perform() async throws -> R {
        print("[HTTP] - \(url.absoluteString)")
        
        do {
            let (data, _) = try await session.data(from: url)
                                            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(R.self, from: data)
            
            return result
        } catch {
            print(error)
            throw error
        }
    }
}

struct Search {
    let q: String
    var includeMultilingual: Bool = false
    
    func perform() async throws -> ListResponse {
        let request = Request<ListResponse>(path: "/cards/search", query: [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "include_multilingual", value: includeMultilingual ? "true" : "false"),
            URLQueryItem(name: "order", value: "set"),
            URLQueryItem(name: "unique", value: "prints"),
        ])
        
        do {
            let result = try await request.perform()
            
            return result
        }
        catch {
            if includeMultilingual == false {
                var retry = self
                retry.includeMultilingual = true
                
                return try await retry.perform()
            } else {
                throw error
            }
        }
    }
}
