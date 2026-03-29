//
//  Trigger.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

struct Trigger: Codable, Hashable {
    var urlFilter: String
    var urlFilterIsCaseSensitive: Bool?
    var resourceType: [ResourceType]?
    var loadType: [LoadType]?
    var loadContext: [LoadContext]?
    var ifDomain: [String]?
    var unlessDomain: [String]?
    var ifTopURL: [String]?
    var unlessTopURL: [String]?
    var ifFrameURL: [String]?
    var unlessFrameURL: [String]?

    enum CodingKeys: String, CodingKey {
        case urlFilter = "url-filter"
        case urlFilterIsCaseSensitive = "url-filter-is-case-sensitive"
        case resourceType = "resource-type"
        case loadType = "load-type"
        case loadContext = "load-context"
        case ifDomain = "if-domain"
        case unlessDomain = "unless-domain"
        case ifTopURL = "if-top-url"
        case unlessTopURL = "unless-top-url"
        case ifFrameURL = "if-frame-url"
        case unlessFrameURL = "unless-frame-url"
    }

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
