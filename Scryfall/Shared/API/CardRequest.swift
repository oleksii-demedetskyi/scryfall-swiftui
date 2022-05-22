//
//  CardRequest.swift
//  Scryfall
//
//  Created by C250 on 5/17/22.
//

import Foundation

struct CardRequest {
    let lang: String
    let number: String
    let set: String
    
    func perform() async throws -> Card? {
        let request = Request<Card>(path: "/cards/\(set.lowercased())/\(number.lowercased())/\(lang.lowercased())")
        do {
            let response = try await request.perform()
            return response
        } catch {
            print(error)
            return nil
        }
    }
}
