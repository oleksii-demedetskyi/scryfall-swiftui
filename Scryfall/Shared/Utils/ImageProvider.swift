//
//  ImageProvider.swift
//  Scryfall
//
//  Created by C250 on 5/15/22.
//

import Foundation

actor ImageProvider {
    let activeOperations: Set<URL> = []
    let completedOperations: [URL: Data] = [:]

    func provideImage(for url: URL) async throws -> Data {
        fatalError()
    }
}

class ImageOperation: ObservableObject {
    let url: URL
    
    init(with url: URL) {
        self.url = url
    }
}
