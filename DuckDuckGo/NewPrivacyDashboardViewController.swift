//
//  NewPrivacyDashboardViewController.swift
//  DuckDuckGo
//
//  Copyright © 2022 DuckDuckGo. All rights reserved.
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
import PrivacyDashboard
import Combine
import WebKit
import UIKit

class NewPrivacyDashboardViewController: UIViewController {

    var webView: WKWebView!
    
    private let privacyDashboardLogic: PrivacyDashboardLogic
    private var isLoaded: Bool = false


    public init(privacyInfo: PrivacyInfo?, themeName: String?) {
        self.privacyDashboardLogic = PrivacyDashboardLogic(privacyInfo: privacyInfo,
                                                           themeName: themeName)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

//        applyTheme(ThemeManager.shared.currentTheme)
//        extendedLayoutIncludesOpaqueBars = true
//        isModalInPresentation = true
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupWebView()
        setupPrivacyDashboardLogicHandlers()
        privacyDashboardLogic.setup(for: webView)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        privacyDashboardLogic.cleanUpCancellables()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()

        let webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.allowsBackForwardNavigationGestures = true

        view.addSubview(webView)
        self.webView = webView
    }
    
    private func setupPrivacyDashboardLogicHandlers() {
        privacyDashboardLogic.onProtectionSwitchChange = privacyDashboardProtectionSwitchChangeHandler
        privacyDashboardLogic.onCloseTapped = privacyDashboardCloseTappedHandler
    }
}

private extension NewPrivacyDashboardViewController {
    
    func privacyDashboardProtectionSwitchChangeHandler(enabled: Bool) {
        print("switch: \(enabled)")
    }
    
    func privacyDashboardCloseTappedHandler() {
        print("close")
    }
}