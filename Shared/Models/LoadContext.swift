//
//  LoadContext.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

enum LoadContext: String, Codable, CaseIterable, Identifiable {
    case firstParty = "first-party"
    case thirdParty = "third-party"
    case sameOrigin = "same-origin"
    case crossOrigin = "cross-origin"
    
    var id: String  {
        self.rawValue
    }

}
