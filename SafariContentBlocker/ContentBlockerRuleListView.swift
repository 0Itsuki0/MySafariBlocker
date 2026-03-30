//
//  ContentBlockerRuleListView.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/29.
//

import SwiftUI
import SafariServices

struct ContentBlockerRuleListView: View {
    @AppStorage(
        UserDefaultsKey.blockList.key,
        store: UserDefaultsKey.userDefaults
    ) var savedRulesData: Data = .emptyRuleData

    private var rules: [ContentBlockerRule] {
        .fromData(self.savedRulesData).filter({$0 != .emptyRule})
    }

    @State private var showingEditor = false
    @State private var selectedBlockerRule: ContentBlockerRule? = nil

    var body: some View {
        List {
            ForEach(Array(rules.enumerated()), id: \.offset) { _, rule in
                Button(action: {
                    self.selectedBlockerRule = rule
                    self.showingEditor = true
                }, label: {
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text("Trigger")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                            Text(rule.trigger.json)
                                .multilineTextAlignment(.leading)
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            Text("-----")
                                .foregroundStyle(.gray)

                            Text("Action")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                            Text(rule.action.json)
                                .multilineTextAlignment(.leading)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button(
                            action: {
                                UIPasteboard.general.string = rule.json
                            },
                            label: {
                                Image(systemName: "document.on.document")
                            }
                        )
                        .buttonStyle(.borderless)
                    }
                })
            }
            .onDelete { indexSet in
                var newRules = rules
                newRules.remove(atOffsets: indexSet)
                self.savedRulesData = newRules.toData() ?? Data()
            }
        }
        .overlay(content: {
            if self.rules.isEmpty {
                ContentUnavailableView(
                    "No Rules Added",
                    systemImage: "hand.raised.fill"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.2))
            }
        })
        .contentMargins(.top, 16)
        .navigationTitle("Content Blocker Rules")
        .navigationSubtitle("Create your own from scratch!")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingEditor = true
                } label: {
                    Image(systemName: "plus")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: self.$showingEditor, onDismiss: {
            self.selectedBlockerRule = nil
        }, content: {
            NavigationStack {
                ContentBlockerRuleEditor(selectedBlockerRule: self.$selectedBlockerRule)
            }
        })
        .onChange(
            of: self.rules,
            { old, new in
                guard Set(old) != Set(new) else {
                    return
                }
                
                let extensionBundleId =
                    "itsuki.enjoy.SafariContentBlocker.ContentBlockerExtension"
                Task {
                    do {
                        try await SFContentBlockerManager.reloadContentBlocker(
                            withIdentifier: extensionBundleId
                        )
                    } catch (let error) {
                        print(error)
                    }
                }
            }
        )
    }
}
