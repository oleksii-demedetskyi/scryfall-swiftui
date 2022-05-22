//
//  TaskLimiter.swift
//  Scryfall (iOS)
//
//  Created by C250 on 5/14/22.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

actor TaskLimiter {
    private var activeOperation: Task<Void, Never>?
    
    func debounce(for timeInterval: TimeInterval, operation: @escaping () async throws -> Void) {
        activeOperation?.cancel()
        activeOperation = Task {
            do {
                try await Task.sleep(seconds: timeInterval)
                try await operation()
            } catch {
                return
            }
        }
    }
}
