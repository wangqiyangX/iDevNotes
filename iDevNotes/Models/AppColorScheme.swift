//
//  AppColorScheme.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/2.
//

import SwiftUI

enum AppColorScheme: String, CaseIterable {
    case system
    case light
    case dark

    var title: String {
        switch self {
        case .system:
            String(localized: "自动")
        case .light:
            String(localized: "浅色")
        case .dark:
            String(localized: "深色")
        }
    }

    var icon: String {
        switch self {
        case .system:
            "desktopcomputer"
        case .light:
            "sun.max"
        case .dark:
            "moon"
        }
    }
}
