//
//  ContentBlocker.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

extension CodingUserInfoKey {
    static let includeID = CodingUserInfoKey(rawValue: "includeID")
}

struct ContentBlockerRule: Codable, Equatable, Hashable {
    // id for allowing user to edit rule
    var id: UUID = UUID()
    var trigger: Trigger
    var action: Action

    init(trigger: Trigger, action: Action) {
        self.trigger = trigger
        self.action = action
    }

    enum CodingKeys: String, CodingKey {
        case id
        case trigger
        case action
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let includeIDKey = CodingUserInfoKey.includeID,
            encoder.userInfo[includeIDKey] as? Bool == true
        {
            try container.encode(id, forKey: .id)
        }
        try container.encode(trigger, forKey: .trigger)
        try container.encode(action, forKey: .action)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        trigger = try container.decode(Trigger.self, forKey: .trigger)
        action = try container.decode(Action.self, forKey: .action)
    }

    var json: String {
        let encoder = JSONEncoder()
        if let includeIDKey = CodingUserInfoKey.includeID {
            encoder.userInfo[includeIDKey] = false
        }
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(self) else {
            return "{}"
        }
        return String(data: data, encoding: .utf8) ?? "{}"
    }

    static func == (lhs: ContentBlockerRule, rhs: ContentBlockerRule) -> Bool {
        lhs.trigger.json == rhs.trigger.json
            && lhs.action.json == rhs.action.json
    }

    static var emptyRule: ContentBlockerRule {
        .init(
            trigger: .init(urlFilter: ".*", ifDomain: ["domain.com"]),
            action: .init(type: .ignorePreviousRules)
        )
    }
}

extension Data {
    static var emptyRuleData: Data {
        [ContentBlockerRule.emptyRule].toData(includeID: false)
            ?? Data(
                "[{\"trigger\": {\"url-filter\": \".*\",\"if-domain\": [\"domain.com\"]},\"action\":{\"type\": \"ignore-previous-rules\"}}]"
                    .utf8
            )
    }
}

extension Array where Element == ContentBlockerRule {

    static func fromData(_ data: Data) -> [ContentBlockerRule] {
        guard !data.isEmpty else {
            return []
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([ContentBlockerRule].self, from: data)
        } catch {
            print("Failed to decode ContentBlockerRule array: \(error)")
            return []
        }
    }

    func toData(includeID: Bool = true) -> Data? {
        if self.isEmpty {
            return nil
        }
        let encoder = JSONEncoder()
        if let includeIDKey = CodingUserInfoKey.includeID {
            encoder.userInfo[includeIDKey] = includeID
        }
        do {
            return try encoder.encode(self)
        } catch {
            print("Failed to encode ContentBlockerRule array: \(error)")
            return nil
        }
    }
}
