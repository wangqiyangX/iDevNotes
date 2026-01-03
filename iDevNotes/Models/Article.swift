//
//  Article.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/1.
//

import Foundation
import SwiftData
import SwiftUI

enum ArticleSeries: Int, Codable, CaseIterable, Identifiable {
    case iOS
    case translation

    var displayName: String {
        switch self {
        case .iOS:
            "iOS"
        case .translation:
            "翻译"
        }
    }

    var id: Self { self }
}

enum ArticleTag: Int, Codable, CaseIterable, Identifiable {
    case text
    case storeKit
    case life
    case read
    case work
    case indie

    var displayName: String {
        switch self {
        case .text:
            "Text"
        case .storeKit:
            "StoreKit"
        case .life:
            "生活"
        case .read:
            "阅读"
        case .work:
            "工作"
        case .indie:
            "独立开发"
        }
    }

    var id: Self { self }
}

enum ArticleType: Int, Codable, CaseIterable, Identifiable {
    case note
    case jotting

    var displayName: String {
        switch self {
        case .note:
            String(localized: "文记")
        case .jotting:
            String(localized: "随笔")
        }
    }

    var id: Self { self }
}

@Model
class Article {
    var id: String
    var title: String
    var timestamp: Date
    var type: ArticleType
    var series: ArticleSeries?
    var tags: [ArticleTag]
    var desc: String?
    // Marks content as sensitive
    var sensitive: Bool
    // Whether to show table of contents
    var toc: [String]
    // Top priority for sorting (higher is more important)
    var top: Int
    // Draft status (excludes from public listing)
    var draft: Bool

    @Transient
    var detailsView: any View = EmptyView()

    init(
        id: String = UUID().uuidString,
        title: String,
        timestamp: Date = .now,
        type: ArticleType = .note,
        series: ArticleSeries? = nil,
        tags: [ArticleTag] = [],
        desc: String? = nil,
        sensitive: Bool = false,
        toc: [String] = [],
        top: Int = 0,
        draft: Bool = false,
        detailsView: any View = EmptyView()
    ) {
        self.id = id
        self.title = title
        self.timestamp = timestamp
        self.type = type
        self.series = series
        self.tags = tags
        self.desc = desc
        self.sensitive = sensitive
        self.toc = toc
        self.top = top
        self.draft = draft
        self.detailsView = detailsView
    }
}
