//
//  RMFEditorViewController.swift
//  DuckDuckGo
//
//  Copyright © 2024 DuckDuckGo. All rights reserved.
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

import Foundation
import SwiftUI
import RemoteMessaging
import Core

@available(iOS 17, *)
class RMFEditorViewController: UIHostingController<RMFEditorView> {

    let model = RMFEditorViewModel()

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RMFEditorView(model: model))
    }

}

class RMFEditorViewModel: ObservableObject {

    @Published var version = "0"
    @Published var messages = [RMFMessageEditorViewModel]()
    @Published var includedRules = [String]()
    @Published var excludedRules = [String]()

    func reset() {
    }

    func addMessage() {
        messages.append(RMFMessageEditorViewModel())
    }

    func refresh(_ model: RMFMessageEditorViewModel) {
        if let index = messages.firstIndex(of: model) {
            messages[index] = model
        }
    }

    private func persist() {

//        let messageModel = RemoteMessageModel(id: "test",
//                                              content: messageViewModel.modelType,
//                                              matchingRules: [],
//                                              exclusionRules: [])
//
//        if let data = try? JSONEncoder().encode(messageModel),
//           let message = String(bytes: data, encoding: .utf8) {
//            self.json = message
//            print("message", message)
//        }

    }

}

@available(iOS 17, *)
struct RMFEditorView: View {

    @ObservedObject var model: RMFEditorViewModel

    var body: some View {
        NavigationStack {
            List {

                Section("Version") {
                    TextField("Version", text: $model.version)
                }

                Section {
                    ForEach(model.messages) { messageModel in
                        NavigationLink(value: messageModel) {
                            HStack {
                                Image(messageModel.placeholder.remote.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75)

                                VStack(alignment: .leading) {

                                    Text(messageModel.titleText)
                                        .font(.headline)

                                    Text(messageModel.descriptionText)
                                        .font(.subheadline)

                                    Text("Included Rules:")
                                        .font(.caption)
                                        .bold() +
                                    Text("None")
                                        .font(.caption)

                                    Text("Included Rules:")
                                        .font(.caption)
                                        .bold() +
                                    Text("None")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Messages")
                        Spacer()
                        Button {
                            print("add message")
                            model.addMessage()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }

                Section("Included Rules") {
                    ForEach(model.includedRules, id: \.self) { rule in
                        Text(rule)
                    }
                }

                Section("Excluded Rules") {
                    ForEach(model.excludedRules, id: \.self) { rule in
                        Text(rule)
                    }
                }
            }
            .navigationDestination(for: RMFMessageEditorViewModel.self, destination: { model in
                RMFMessageEditorView(model: model)
                    .onDisappear {
                        print("*** disappear")
                        self.model.refresh(model)
                    }
            })
        }
        .navigationTitle("RMF Editor")
        .toolbar {
            ToolbarItem {
                Button {
                    model.reset()
                } label: {
                    Text("Reset")
                }
            }

            ToolbarItem {
                Button {
                    print("share")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

}

class RMFMessageEditorViewModel: ObservableObject, Identifiable, Hashable, Equatable {

    static func == (lhs: RMFMessageEditorViewModel, rhs: RMFMessageEditorViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id = UUID()

    @UserDefaultsWrapper(key: .debugRMFEditorJSON, defaultValue: nil)
    var json: String?

    enum ModelType: CaseIterable, Identifiable {
        var id: Self { self }

        case small
        case medium
        case bigSingleAction
        case bigTwoAction
        case promoSingleAction

    }

    enum Placeholder: CaseIterable, Identifiable {
        var id: Self { self }

        case announce
        case ddgAnnounce
        case criticalUpdate
        case appUpdate
        case macComputer
        case newForMacAndWindows
        case vpnAnnounce

        var remote: RemotePlaceholder {
            switch self {
            case .announce:
                return .announce
            case .ddgAnnounce:
                return .ddgAnnounce
            case .criticalUpdate:
                return .criticalUpdate
            case .appUpdate:
                return .appUpdate
            case .macComputer:
                return .macComputer
            case .newForMacAndWindows:
                return .newForMacAndWindows
            case .vpnAnnounce:
                return .vpnAnnounce
            }
        }

    }

    @Published var messageViewModel: HomeMessageViewModel
    @Published var modelType: ModelType = .small {
        didSet {
            updateMessage()
        }
    }
    @Published var placeholder: Placeholder = .announce {
        didSet {
            updateMessage()
        }
    }
    @Published var titleText = "title" {
        didSet {
            updateMessage()
        }
    }
    @Published var descriptionText = "description" {
        didSet {
            updateMessage()
        }
    }
    @Published var primaryText = "Primary" {
        didSet {
            updateMessage()
        }
    }
    @Published var secondaryText = "Secondary" {
        didSet {
            updateMessage()
        }
    }
    @Published var actionText = "Action" {
        didSet {
            updateMessage()
        }
    }

    init() {
        messageViewModel = Self.initialMessageViewModel()

//        if let data = json?.data(using: .utf8),
//           let model = try? JSONDecoder().decode(RemoteMessageModel.self, from: data),
//           let content = model.content {
//            messageViewModel = HomeMessageViewModel(messageId: "test",
//                                                    modelType: content,
//                                                    onDidClose: { _ in },
//                                                    onDidAppear: {})
//        }

    }

    static func initialMessageViewModel() -> HomeMessageViewModel {
        let modelType: RemoteMessageModelType = .small(titleText: "Title", descriptionText: "Description")
        return HomeMessageViewModel(messageId: "test",
                                    modelType: modelType,
                                    onDidClose: { _ in },
                                    onDidAppear: { })
    }

    func updateMessage() {
        messageViewModel = HomeMessageViewModel(messageId: "test",
                                                modelType: createRemoteMessageContent(),
                                                onDidClose: { _ in },
                                                onDidAppear: { })
    }

    private func createRemoteMessageContent() -> RemoteMessageModelType {
        switch modelType {
        case .small:
            return .small(titleText: titleText, descriptionText: descriptionText)
        case .medium:
            return .medium(titleText: titleText, descriptionText: descriptionText, placeholder: placeholder.remote)
        case .bigSingleAction:
            return .bigSingleAction(titleText: titleText,
                                    descriptionText: descriptionText,
                                    placeholder: placeholder.remote,
                                    primaryActionText: primaryText,
                                    primaryAction: .url(value: "test"))
        case .bigTwoAction:
            return .bigTwoAction(titleText: titleText,
                                 descriptionText: descriptionText,
                                 placeholder: placeholder.remote,
                                 primaryActionText: primaryText,
                                 primaryAction: .url(value: "test"),
                                 secondaryActionText: secondaryText,
                                 secondaryAction: .url(value: "test"))
        case .promoSingleAction:
            return .promoSingleAction(titleText: titleText,
                                      descriptionText: descriptionText,
                                      placeholder: placeholder.remote,
                                      actionText: actionText,
                                      action: .url(value: "test"))
        }
    }

}

@available(iOS 16, *)
struct RMFMessageEditorView: View {

    @ObservedObject var model: RMFMessageEditorViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HomeMessageView(viewModel: model.messageViewModel)
                        .padding()

                    Divider()

                    VStack {
                        HStack {
                            Text("Model Type").font(.caption)
                            Picker("Type", selection: $model.modelType) {

                                Text("Small").tag(RMFMessageEditorViewModel.ModelType.small)
                                Text("Medium").tag(RMFMessageEditorViewModel.ModelType.medium)
                                Text("Big Single Action").tag(RMFMessageEditorViewModel.ModelType.bigSingleAction)
                                Text("Big Two Action").tag(RMFMessageEditorViewModel.ModelType.bigTwoAction)
                                Text("Promo Single Action").tag(RMFMessageEditorViewModel.ModelType.promoSingleAction)

                            }
                        }

                        switch model.messageViewModel.modelType {
                        case .small:
                            EditableTextField("Title", text: $model.titleText)
                            EditableTextField("Description", text: $model.descriptionText)

                        case .medium:
                            EditableTextField("Title", text: $model.titleText)
                            EditableTextField("Description", text: $model.descriptionText)
                            PlacholderPicker(placeholder: $model.placeholder)

                        case .bigSingleAction:
                            EditableTextField("Title", text: $model.titleText)
                            EditableTextField("Description", text: $model.descriptionText)
                            PlacholderPicker(placeholder: $model.placeholder)

                            EditableTextField("Primary", text: $model.primaryText)

                            // TODO action picker

                        case .bigTwoAction:
                            EditableTextField("Title", text: $model.titleText)
                            EditableTextField("Description", text: $model.descriptionText)
                            PlacholderPicker(placeholder: $model.placeholder)

                            EditableTextField("Primary", text: $model.primaryText)
                            EditableTextField("Secondary", text: $model.secondaryText)

                            // TODO action pickers

                        case .promoSingleAction:
                            EditableTextField("Title", text: $model.titleText)
                            EditableTextField("Description", text: $model.descriptionText)
                            PlacholderPicker(placeholder: $model.placeholder)

                            EditableTextField("Action", text: $model.actionText)
                            // TODO action pickers
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .scrollContentBackground(.hidden)
        }.background(Color(designSystemColor: .background))
    }

}

struct EditableTextField: View {

    var label: String
    var text: Binding<String>

    init(_ label: String, text: Binding<String>) {
        self.label = label
        self.text = text
    }

    var body: some View {
        HStack {
            Text(label).bold()
            VStack(spacing: 2) {
                TextField("", text: text)
                    .font(.caption)
                Divider()
            }
        }
    }

}

struct PlacholderPicker: View {

    @Binding var placeholder: RMFMessageEditorViewModel.Placeholder

    var body: some View {
        Picker("Placeholder", selection: $placeholder) {
            ForEach(RMFMessageEditorViewModel.Placeholder.allCases) {
                Text("\($0)").tag($0)
            }
        }
    }

}
