//
//  TabGeneratorViewController.swift
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

import SwiftUI
import Core

@available(iOS 17, *)
class TabGeneratorViewController: UIHostingController<TabGeneratorView> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: TabGeneratorView())
    }

}

@available(iOS 17, *)
struct TabGeneratorView: View {

    @ObservedObject var model = TabGeneratorViewModel()

    var body: some View {

        VStack {

            VStack(alignment: .leading, spacing: 0) {
                TextField("Tab Count", text: $model.tabCount)

                Divider()

                Text("Tab Count")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)

            if model.busy {

                ProgressCircle(progress: model.progress)

                Button {
                    model.cancel()
                } label: {
                    Text("Cancel")
                }

            } else {
                Button {
                    model.start()
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)

                Text(model.error ?? "")
                    .foregroundStyle(.red)
            }

            Spacer()

        }.padding()

    }
}

class TabGeneratorViewModel: ObservableObject {

    @Published var tabCount = "0"

    @Published var target = 0
    @Published var current = 0
    @Published var busy = false
    @Published var error: String?

    var progress: Float {
        Float(current) / Float(target)
    }

    var tabsModel = TabsModel.get()

    func start() {
        guard let target = Int(tabCount) else {
            error = "Invalid target tab count"
            return
        }

        busy = true

        Task { @MainActor in
            self.tabsModel = TabsModel(desktop: false)
            self.target = target
            nextBatch()
        }
    }

    func cancel() {
        busy = true
    }

    @MainActor
    func nextBatch() {
        print(#function, tabsModel?.count ?? -1)
        
        guard busy else { return }

        if current >= target {
            busy = false
            return
        }

        Task {

            for _ in 0 ..< 100 {
                let url = URL(string: "https://example.com/tab\(current)")!
                let title = "Tab \(current)"
                tabsModel?.add(tab: Tab(link: Link(title: title, url: url)))
                current += 1
                if current >= target {
                    break
                }
            }

            tabsModel?.save()
            nextBatch()
        }
    }

}
