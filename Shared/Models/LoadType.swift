//
//  LoadType.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

enum LoadType: String, Codable, CaseIterable, Identifiable {
    case firstParty = "first-party"
    case thirdParty = "third-party"
    
    var id: String  {
        self.rawValue
    }
}
