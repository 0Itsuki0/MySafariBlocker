//
//  MultipleSelectionRow.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/29.
//

import SwiftUI

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
