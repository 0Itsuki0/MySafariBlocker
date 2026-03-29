//
//  ResourceType.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/28.
//

import Foundation

enum ResourceType: String, Codable, CaseIterable, Identifiable {
    case document
    case image
    case styleSheet = "style-sheet"
    case script
    case font
    case raw
    case svgDocument = "svg-document"
    case media
    case popup
    
    var id: String  {
        self.rawValue
    }
}
