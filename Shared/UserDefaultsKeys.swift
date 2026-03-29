//
//  UserDefaultsKeys.swift
//  SafariExtensionDemo
//
//  Created by Itsuki on 2026/03/27.
//

import Foundation

let group = "group.itsuki.safari.extension"

enum UserDefaultsKey: String, CaseIterable {
    case blockList

    static let userDefaults = UserDefaults(suiteName: group) ?? .standard

    var key: String {
        return self.rawValue
    }

    func setValue(value: Any?) {
        Self.userDefaults.setValue(value, forKey: self.key)
    }

    func getValue() -> Any? {
        return Self.userDefaults.object(forKey: self.key)
    }
}
