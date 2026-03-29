//
//  Action.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

struct Action: Codable, Hashable {
    var type: ActionType
    var selector: String?
    
    var data: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(self)
    }

    var json: String {
        guard let data else {
            return "(not specified)"
        }
        return String(data: data, encoding: .utf8)?.trimmingCharacters(
            in: .whitespacesAndNewlines.union(.init(["{", "}"]))
        ) ?? "(not specified)"
    }
}
