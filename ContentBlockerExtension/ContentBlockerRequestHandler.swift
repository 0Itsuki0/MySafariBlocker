//
//  ContentBlockerRequestHandler.swift
//  ContentBlockerExtension
//
//  Created by Itsuki on 2026/03/28.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let dataWithId = UserDefaultsKey.blockList.getValue() as? Data ?? .emptyRuleData
        let blockerList = Array.fromData(dataWithId)
        let data = blockerList.toData(includeID: false) ?? .emptyRuleData

        let attachment = NSItemProvider(
            item: data as NSSecureCoding,
            typeIdentifier: UTType.json.identifier
        )
        let item = NSExtensionItem()
        item.attachments = [attachment]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }

}
