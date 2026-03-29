//
//  ContentBlockerRuleEditor.swift
//  SafariContentBlocker
//
//  Created by Itsuki on 2026/03/29.
//

import SwiftUI

struct ContentBlockerRuleEditor: View {

    @AppStorage(
        UserDefaultsKey.blockList.key,
        store: UserDefaultsKey.userDefaults
    ) private var savedRulesData: Data = .emptyRuleData

    private var rules: [ContentBlockerRule] {
        .fromData(self.savedRulesData)
    }

    @Binding var selectedBlockerRule: ContentBlockerRule?

    @State private var urlFilter: String = ""
    @State private var caseSensitive: Bool = false
    @State private var selectedResourceTypes: Set<ResourceType> = []
    @State private var selectedLoadTypes: Set<LoadType> = []
    @State private var selectedLoadContexts: Set<LoadContext> = []
    @State private var ifDomain: String = ""
    @State private var unlessDomain: String = ""
    @State private var ifTopURL: String = ""
    @State private var unlessTopURL: String = ""
    @State private var ifFrameURL: String = ""
    @State private var unlessFrameURL: String = ""
    @State private var actionType: ActionType = .block
    @State private var selector: String = ""

    @State private var validationError: String?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Reference") {
                Text(
                    """
                    - [URL Filter Patter](https://developer.apple.com/documentation/safariservices/creating-a-content-blocker#Capture-URLs-by-pattern)
                    - [Trigger fields](https://developer.apple.com/documentation/safariservices/creating-a-content-blocker#Use-trigger-fields-to-define-patterns)
                    - [Action](https://developer.apple.com/documentation/safariservices/creating-a-content-blocker#Select-values-for-the-type-field)
                    """
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Section("Trigger") {
                LabeledContent {
                    TextField("(required)", text: $urlFilter)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("URL Filter")
                }
                .onChange(
                    of: urlFilter,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.urlFilter = urlFilter
                    }
                )

                Toggle("Case Sensitive", isOn: $caseSensitive)

                MultiPicker(
                    title: "Resource Types",
                    options: ResourceType.allCases,
                    selection: $selectedResourceTypes
                )
                .onChange(
                    of: selectedResourceTypes,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.resourceType = Array(
                            selectedResourceTypes
                        )
                    }
                )

                MultiPicker(
                    title: "Load Types",
                    options: LoadType.allCases,
                    selection: $selectedLoadTypes
                )
                .onChange(
                    of: selectedLoadTypes,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.loadType = Array(
                            selectedLoadTypes
                        )
                    }
                )

                MultiPicker(
                    title: "Load Contexts",
                    options: LoadContext.allCases,
                    selection: $selectedLoadContexts
                )
                .onChange(
                    of: selectedLoadContexts,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.loadContext = Array(
                            selectedLoadContexts
                        )
                    }
                )

                LabeledContent {
                    TextField(
                        "If Domain",
                        text: $ifDomain,
                        prompt: Text("Comma separated list")
                    )
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("If Domain")
                }
                .onChange(
                    of: ifDomain,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.ifDomain =
                            .fromCommaSeparatedString(ifDomain)
                    }
                )

                LabeledContent {
                    TextField(
                        "Unless Domain",
                        text: $unlessDomain,
                        prompt: Text("Comma separated list")
                    )
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("Unless Domain")
                }
                .onChange(
                    of: unlessDomain,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.unlessDomain =
                            .fromCommaSeparatedString(unlessDomain)
                    }
                )

                LabeledContent {
                    TextField(
                        "If Top URL",
                        text: $ifTopURL,
                        prompt: Text("Comma separated list")
                    )
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("If Top URL")
                }
                .onChange(
                    of: ifTopURL,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.ifTopURL =
                            .fromCommaSeparatedString(ifTopURL)
                    }
                )

                LabeledContent {
                    TextField(
                        "Unless Top URL",
                        text: $unlessTopURL,
                        prompt: Text("Comma separated list")
                    )
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("Unless Top URL")
                }
                .onChange(
                    of: unlessTopURL,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.unlessTopURL =
                            .fromCommaSeparatedString(unlessTopURL)
                    }
                )

                LabeledContent {
                    TextField(
                        "If Frame URL",
                        text: $ifFrameURL,
                        prompt: Text("Comma separated list")
                    )
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("If Frame URL")
                }
                .onChange(
                    of: ifFrameURL,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.ifFrameURL =
                            .fromCommaSeparatedString(ifFrameURL)
                    }
                )

                LabeledContent {
                    TextField(
                        "Unless Frame URL",
                        text: $unlessFrameURL,
                        prompt: Text("Comma separated list")
                    )
                    .multilineTextAlignment(.trailing)
                } label: {
                    Text("Unless Frame URL")
                }
                .onChange(
                    of: unlessFrameURL,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.trigger.unlessFrameURL =
                            .fromCommaSeparatedString(unlessFrameURL)
                    }
                )

            }

            Section("Action") {
                Picker("Action Type", selection: $actionType) {
                    ForEach(ActionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .onChange(
                    of: actionType,
                    {
                        // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                        self.selectedBlockerRule?.action.type = actionType
                    }
                )

                if actionType == .cssDisplayNone {
                    LabeledContent {
                        TextField(
                            "CSS Selector",
                            text: $selector,
                            prompt: Text("Comma separated list")
                        )
                        .multilineTextAlignment(.trailing)
                    } label: {
                        Text("CSS Selector")
                    }
                    .onChange(
                        of: selector,
                        {
                            // otherwise, the selection will be reset due to the onChange on selectedBlockerRule
                            self.selectedBlockerRule?.action.selector = selector
                        }
                    )

                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Button(
                    action: {
                        if let error = validate() {
                            validationError = error
                            return
                        }
                        // Create rule
                        let trigger = Trigger(
                            urlFilter: urlFilter,
                            urlFilterIsCaseSensitive: caseSensitive,
                            resourceType: selectedResourceTypes.isEmpty
                                ? nil : Array(selectedResourceTypes),
                            loadType: selectedLoadTypes.isEmpty
                                ? nil : Array(selectedLoadTypes),
                            loadContext: selectedLoadContexts.isEmpty
                                ? nil : Array(selectedLoadContexts),
                            ifDomain: ifDomain.isEmpty
                                ? nil : .fromCommaSeparatedString(ifDomain),
                            unlessDomain: unlessDomain.isEmpty
                                ? nil : .fromCommaSeparatedString(unlessDomain),
                            ifTopURL: ifTopURL.isEmpty
                                ? nil : .fromCommaSeparatedString(ifTopURL),
                            unlessTopURL: unlessTopURL.isEmpty
                                ? nil : .fromCommaSeparatedString(unlessTopURL),
                            ifFrameURL: ifFrameURL.isEmpty
                                ? nil : .fromCommaSeparatedString(ifFrameURL),
                            unlessFrameURL: unlessFrameURL.isEmpty
                                ? nil
                                : .fromCommaSeparatedString(unlessFrameURL)
                        )

                        let action = Action(
                            type: actionType,
                            selector: selector.isEmpty ? nil : selector
                        )

                        let rule = ContentBlockerRule(
                            trigger: trigger,
                            action: action
                        )
                        var newRules = rules

                        if let selectedBlockerRule,
                            let firstIndex = newRules.firstIndex(where: {
                                $0.id == selectedBlockerRule.id
                            })
                        {
                            newRules[firstIndex] = rule
                        } else {
                            if self.rules.contains(where: { $0 == rule }) {
                                self.validationError = "Rule already exists"
                                return
                            }
                            newRules.append(rule)
                        }
                        self.savedRulesData =
                            newRules.toData() ?? Data.emptyRuleData

                        self.dismiss()
                    },
                    label: {
                        Text(
                            selectedBlockerRule == nil
                                ? "Add Rule" : "Save Rule"
                        )
                        .padding(.vertical, 4)
                        .fontWeight(.medium)
                    }
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
                .buttonSizing(.flexible)

                if let validationError {
                    Text(validationError)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 12)
                }
            }
            .listRowInsets(.all, 0)
            .listRowBackground(Color.clear)
        }
        .navigationTitle(selectedBlockerRule == nil ? "New Rule" : "Edit Rule")
        .toolbar(content: {
            ToolbarItem(
                placement: .topBarTrailing,
                content: {
                    Button(
                        action: {
                            self.dismiss()
                        },
                        label: {
                            Image(systemName: "xmark")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    )
                    .buttonStyle(.borderedProminent)
                }
            )
        })
        .onChange(
            of: self.selectedBlockerRule,
            initial: true
        ) {
            self.validationError = nil
            if let selectedBlockerRule {
                urlFilter = selectedBlockerRule.trigger.urlFilter
                caseSensitive =
                    selectedBlockerRule.trigger.urlFilterIsCaseSensitive
                    ?? false
                selectedResourceTypes = Set(
                    selectedBlockerRule.trigger.resourceType ?? []
                )
                selectedLoadTypes = Set(
                    selectedBlockerRule.trigger.loadType ?? []
                )
                selectedLoadContexts = Set(
                    selectedBlockerRule.trigger.loadContext ?? []
                )
                ifDomain =
                    selectedBlockerRule.trigger.ifDomain?
                    .commaSeparatedString ?? ""
                unlessDomain =
                    selectedBlockerRule.trigger.unlessDomain?
                    .commaSeparatedString ?? ""
                ifTopURL =
                    selectedBlockerRule.trigger.ifTopURL?
                    .commaSeparatedString ?? ""
                unlessTopURL =
                    selectedBlockerRule.trigger.unlessTopURL?
                    .commaSeparatedString ?? ""
                ifFrameURL =
                    selectedBlockerRule.trigger.ifFrameURL?
                    .commaSeparatedString ?? ""
                unlessFrameURL =
                    selectedBlockerRule.trigger.unlessFrameURL?
                    .commaSeparatedString ?? ""
                actionType = selectedBlockerRule.action.type
                selector = selectedBlockerRule.action.selector ?? ""
            } else {
                urlFilter = ""
                caseSensitive = false
                selectedResourceTypes = []
                selectedLoadTypes = []
                selectedLoadContexts = []
                ifDomain = ""
                unlessDomain = ""
                ifTopURL = ""
                unlessTopURL = ""
                ifFrameURL = ""
                unlessFrameURL = ""
                actionType = .block
                selector = ""
            }
        }

    }

    //    Validation enforced:
    //    url-filter is required (must have a value)
    //    if-domain and unless-domain must not both be present at the same time (exclusive)
    //    Same exclusivity for top and frame URL fields (Apple rules follow similar logic structures)
    //    Selector is required only when action type needs it (css-display-none)
    func validate() -> String? {
        // url-filter is mandatory
        guard !urlFilter.isEmpty else {
            return "URL Filter must not be empty."
        }
        // Domains exclusivity
        if !ifDomain.isEmpty && !unlessDomain.isEmpty {
            return "Cannot specify both If Domain and Unless Domain."
        }
        // Top URL exclusivity
        if !ifTopURL.isEmpty && !unlessTopURL.isEmpty {
            return "Cannot specify both If Top URL and Unless Top URL."
        }
        // Frame URL exclusivity
        if !ifFrameURL.isEmpty && !unlessFrameURL.isEmpty {
            return "Cannot specify both If Frame URL and Unless Frame URL."
        }
        // Selector required for css-display-none
        if actionType == .cssDisplayNone && selector.isEmpty {
            return "Selector must be provided for css-display-none action."
        }
        return nil
    }
}

extension Array where Element == String {
    static func fromCommaSeparatedString(_ string: String) -> [String] {
        string.split(separator: ",").map({
            String($0).trimmingCharacters(in: .whitespacesAndNewlines)
        }).filter({ !$0.isEmpty })
    }

    var commaSeparatedString: String {
        self.joined(separator: ", ")
    }
}
