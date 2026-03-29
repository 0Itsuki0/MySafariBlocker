//
//  ActionType.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

enum ActionType: String, Codable, CaseIterable, Identifiable {
    case block
    case blockCookies = "block-cookies"
    case cssDisplayNone = "css-display-none"
    case ignorePreviousRules = "ignore-previous-rules"
    case makeHTTPS = "make-https"
    
    var id: String  {
        self.rawValue
    }
}
