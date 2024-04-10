//
//  SubscriptionProPixel.swift
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
import PixelKit

public enum PrivacyProPixel: PixelKitEventV2 {
    case privacyProSubscriptionActive
    case privacyProOfferScreenImpression
    case privacyProPurchaseAttempt
    case privacyProPurchaseFailure
    case privacyProPurchaseFailureStoreError
    case privacyProPurchaseFailureBackendError
    case privacyProPurchaseFailureAccountNotCreated
    case privacyProPurchaseSuccess
    case privacyProRestorePurchaseOfferPageEntry
    case privacyProRestorePurchaseClick
    case privacyProRestorePurchaseEmailStart
    case privacyProRestorePurchaseStoreStart
    case privacyProRestorePurchaseEmailSuccess
    case privacyProRestorePurchaseStoreSuccess
    case privacyProRestorePurchaseStoreFailureNotFound
    case privacyProRestorePurchaseStoreFailureOther
    case privacyProRestoreAfterPurchaseAttempt
    case privacyProSubscriptionActivated
    case privacyProWelcomeAddDevice
    case privacyProSettingsAddDevice
    case privacyProAddDeviceEnterEmail
    case privacyProWelcomeVPN
    case privacyProWelcomePersonalInformationRemoval
    case privacyProWelcomeIdentityRestoration
    case privacyProSubscriptionSettings
    case privacyProVPNSettings
    case privacyProPersonalInformationRemovalSettings
    case privacyProIdentityRestorationSettings
    case privacyProSubscriptionManagementEmail
    case privacyProSubscriptionManagementPlanBilling
    case privacyProSubscriptionManagementRemoval
    case privacyProFeatureEnabled
    case privacyProPromotionDialogShownVPN
    case privacyProVPNAccessRevokedDialogShown
    case privacyProVPNBetaStoppedWhenPrivacyProEnabled
    case privacyProOfferMonthlyPriceClick
    case privacyProOfferYearlyPriceClick
    case privacyProAddEmailSuccess
    case privacyProWelcomeFAQClick

    public var name: String {
        switch self {
        case .privacyProSubscriptionActive: return "m_privacy-pro_app_subscription_active"
        case .privacyProOfferScreenImpression: return "m_privacy-pro_offer_screen_impression"
        case .privacyProPurchaseAttempt: return "m_privacy-pro_terms-conditions_subscribe_click"
        case .privacyProPurchaseFailure: return "m_privacy-pro_app_subscription-purchase_failure_other"
        case .privacyProPurchaseFailureStoreError: return "m_privacy-pro_app_subscription-purchase_failure_store"
        case .privacyProPurchaseFailureAccountNotCreated: return "m_privacy-pro_app_subscription-purchase_failure_backend"
        case .privacyProPurchaseFailureBackendError: return "m_privacy-pro_app_subscription-purchase_failure_account-creation"
        case .privacyProPurchaseSuccess: return "m_privacy-pro_app_subscription-purchase_success"
        case .privacyProRestorePurchaseOfferPageEntry: return "m_privacy-pro_offer_restore-purchase_click"
        case .privacyProRestorePurchaseClick: return "m_privacy-pro_app-settings_restore-purchase_click"
        case .privacyProRestorePurchaseEmailStart: return "m_privacy-pro_activate-subscription_enter-email_click"
        case .privacyProRestorePurchaseStoreStart: return "m_privacy-pro_activate-subscription_restore-purchase_click"
        case .privacyProRestorePurchaseEmailSuccess: return "m_privacy-pro_app_subscription-restore-using-email_success"
        case .privacyProRestorePurchaseStoreSuccess: return "m_privacy-pro_app_subscription-restore-using-store_success"
        case .privacyProRestorePurchaseStoreFailureNotFound: return "m_privacy-pro_app_subscription-restore-using-store_failure_not-found"
        case .privacyProRestorePurchaseStoreFailureOther: return "m_privacy-pro_app_subscription-restore-using-store_failure_other"
        case .privacyProRestoreAfterPurchaseAttempt: return "m_privacy-pro_app_subscription-restore-after-purchase-attempt_success"
        case .privacyProSubscriptionActivated: return "m_privacy-pro_app_subscription_activated_u"
        case .privacyProWelcomeAddDevice: return "m_privacy-pro_welcome_add-device_click_u"
        case .privacyProSettingsAddDevice: return "m_privacy-pro_settings_add-device_click"
        case .privacyProAddDeviceEnterEmail: return "m_privacy-pro_add-device_enter-email_click"
        case .privacyProWelcomeVPN: return "m_privacy-pro_welcome_vpn_click_u"
        case .privacyProWelcomePersonalInformationRemoval: return "m_privacy-pro_welcome_personal-information-removal_click_u"
        case .privacyProWelcomeIdentityRestoration: return "m_privacy-pro_welcome_identity-theft-restoration_click_u"
        case .privacyProSubscriptionSettings: return "m_privacy-pro_settings_screen_impression"
        case .privacyProVPNSettings: return "m_privacy-pro_app-settings_vpn_click"
        case .privacyProPersonalInformationRemovalSettings: return "m_privacy-pro_app-settings_personal-information-removal_click"
        case .privacyProIdentityRestorationSettings: return "m_privacy-pro_app-settings_identity-theft-restoration_click"
        case .privacyProSubscriptionManagementEmail: return "m_privacy-pro_manage-email_edit_click"
        case .privacyProSubscriptionManagementPlanBilling: return "m_privacy-pro_settings_change-plan-or-billing_click"
        case .privacyProSubscriptionManagementRemoval: return "m_privacy-pro_settings_remove-from-device_click"
        case .privacyProFeatureEnabled: return "m_privacy-pro_feature_enabled"
        case .privacyProPromotionDialogShownVPN: return "m_privacy-pro_promotion-dialog_shown_vpn"
        case .privacyProVPNAccessRevokedDialogShown: return "m_privacy-pro_vpn-access-revoked-dialog_shown"
        case .privacyProVPNBetaStoppedWhenPrivacyProEnabled: return "m_privacy-pro_vpn-beta-stopped-when-privacy-pro-enabled"
        case .privacyProOfferMonthlyPriceClick: return "m_privacy-pro_offer_monthly-price_click"
        case .privacyProOfferYearlyPriceClick: return "m_privacy-pro_offer_yearly-price_click"
        case .privacyProAddEmailSuccess: return "m_privacy-pro_app_add-email_success_u"
        case .privacyProWelcomeFAQClick: return "m_privacy-pro_welcome_faq_click_u"
        }
    }

    public var error: (any Error)? {
        return nil
    }

    public var parameters: [String: String]? {
        return nil
    }
}
