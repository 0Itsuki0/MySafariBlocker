//
//  MultiPicker.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/29.
//

import SwiftUI

struct MultiPicker<
    Option: Hashable & RawRepresentable & CaseIterable & Identifiable
>: View where Option.RawValue == String {
    let title: LocalizedStringKey
    let options: [Option]
    @Binding var selection: Set<Option>

    var body: some View {
        NavigationLink(
            destination: List(options) { option in
                MultipleSelectionRow(
                    title: option.rawValue,
                    isSelected: selection.contains(option)
                ) {
                    if selection.contains(option) {
                        selection.remove(option)
                    } else {
                        selection.insert(option)
                    }
                }
            },
            label: {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(selection.map(\.rawValue).joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        )
    }
}
