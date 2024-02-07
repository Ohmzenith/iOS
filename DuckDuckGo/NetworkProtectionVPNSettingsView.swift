//
//  NetworkProtectionVPNSettingsView.swift
//  DuckDuckGo
//
//  Copyright © 2023 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if NETWORK_PROTECTION

import SwiftUI
import DesignResourcesKit
import Network

@available(iOS 15, *)
struct NetworkProtectionVPNSettingsView: View {
    @StateObject var viewModel = NetworkProtectionVPNSettingsViewModel()
    @State var customDNS: String = ""
    @FocusState private var isCustomDNSFocused: Bool

    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: NetworkProtectionVPNLocationView()) {
                        HStack(spacing: 16) {
                            switch viewModel.preferredLocation.icon {
                            case .defaultIcon:
                                Image("Location-Solid-24")
                            case .emoji(let string):
                                Text(string)
                            }
                            VStack(alignment: .leading) {
                                Text(UserText.netPVPNLocationTitle)
                                    .daxBodyRegular()
                                    .foregroundColor(.init(designSystemColor: .textPrimary))
                                Text(viewModel.preferredLocation.title)
                                    .daxFootnoteRegular()
                                    .foregroundColor(.init(designSystemColor: .textSecondary))
                            }
                        }
                    }
                }
                .listRowBackground(Color(designSystemColor: .surface))
                toggleSection(
                    text: UserText.netPExcludeLocalNetworksSettingTitle,
                    footerText: UserText.netPExcludeLocalNetworksSettingFooter
                ) {
                    Toggle("", isOn: $viewModel.excludeLocalNetworks)
                        .onTapGesture {
                            viewModel.toggleExcludeLocalNetworks()
                        }
                }
                Section {
                    editableCell("Custom DNS",
                                 subtitle: $customDNS,
                                 placeholderText: "leave empty for default",
                                 autoCapitalizationType: .none,
                                 disableAutoCorrection: true,
                                 keyboardType: .numbersAndPunctuation)
                        .focused($isCustomDNSFocused)
                    if !customDNS.isEmpty, viewModel.customDNS != customDNS {
                        Button("Use as DNS Server") {
                            isCustomDNSFocused = false
                            viewModel.updateCustomDNS(customDNS)
                            DispatchQueue.main.async {
                                ActionMessageView.present(message: "Custom DNS server set to \(viewModel.customDNS)",
                                                          presentationLocation: .withoutBottomBar)
                            }
                        }
                    } else if !viewModel.customDNS.isEmpty {
                        Button("Reset to Default") {
                            customDNS = ""
                            viewModel.resetCustomDNS()
                            DispatchQueue.main.async {
                                ActionMessageView.present(message: "DNS reset to default",
                                                          presentationLocation: .withoutBottomBar)
                            }
                        }
                    }
                }
                Section {
                    HStack(spacing: 16) {
                        Image("Info-Solid-24")
                            .foregroundColor(.init(designSystemColor: .icons).opacity(0.3))
                        Text(UserText.netPSecureDNSSettingFooter)
                            .daxFootnoteRegular()
                            .foregroundColor(.init(designSystemColor: .textSecondary))
                    }
                }
                .listRowBackground(Color(designSystemColor: .surface))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                customDNS = viewModel.customDNS
            }
        }
        .applyInsetGroupedListStyle()
        .navigationTitle(UserText.netPVPNSettingsTitle)
    }

    @ViewBuilder
    func toggleSection(text: String, footerText: String, @ViewBuilder toggle: () -> some View) -> some View {
        Section {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(text)
                        .daxBodyRegular()
                        .foregroundColor(.init(designSystemColor: .textPrimary))
                        .layoutPriority(1)
                }

                toggle()
                    .toggleStyle(SwitchToggleStyle(tint: .init(designSystemColor: .accent)))
            }
        } footer: {
            Text(footerText)
                .foregroundColor(.init(designSystemColor: .textSecondary))
                .accentColor(Color(designSystemColor: .accent))
                .daxFootnoteRegular()
                .padding(.top, 6)
        }
        .listRowBackground(Color(designSystemColor: .surface))
    }

    private func editableCell(_ title: String,
                              subtitle: Binding<String>,
                              placeholderText: String,
                              secure: Bool = false,
                              autoCapitalizationType: UITextAutocapitalizationType = .none,
                              disableAutoCorrection: Bool = true,
                              keyboardType: UIKeyboardType = .default) -> some View {

        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .label4Style()

            HStack {
                ClearTextField(placeholderText: placeholderText,
                               text: subtitle,
                               autoCapitalizationType: autoCapitalizationType,
                               disableAutoCorrection: disableAutoCorrection,
                               keyboardType: keyboardType)
            }
        }
        .frame(minHeight: 60)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    private func validDNSEntered() -> Bool {
        !customDNS.isEmpty && customDNS.contains(".") && IPv4Address(customDNS) != nil
    }
}

#endif
