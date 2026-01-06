//
//  InternalData.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/1.
//

import Foundation
import SwiftData
import SwiftUI

extension Article {
    // 内部数据 - 每篇文章作为单独的静态常量
    static let iOSPathsWay = Article(
        title: "简单介绍一下 iOS 学习路线",
        type: .note,
        series: .iOS,
        desc: "本文主要介绍一下我自己学习 iOS 时整理的学习路线及相关资料，希望对你有所帮助。",
        detailsView: Text("")
    )

    static let HowtoPromptUserstoRateYourApp = Article(
        title: "如何提示用户给你的应用评价",
        type: .note,
        series: .iOS,
        tags: [.storeKit],
        desc:
            "通常来说，开发者在发布应用后，应该在应用内增加引导用户到 App Store 进行评价的功能，本文简单介绍两种不同的方法来实现此功能。",
        toc: ["使用 StoreKit", "使用 URL", "参考资料"],
        detailsView: DetailsViewForHowtoPromptUserstoRateYourApp(),
    )

    static let SwiftAPIDesignGuidelines = Article(
        title: "Swift API 设计指南",
        series: .translation,
        tags: [.indie],
        desc:
            "在编写 Swift 代码时，提供清晰一致的开发者体验在很大程度上由 API 中出现的命名与用法决定。这些设计准则解释了如何确保你的代码感觉像是更广阔的 Swift 生态系统的一部分。",
        detailsView: DetailsViewForAPIDesignGuidelines()
    )

    static let firstJotting = Article(
        id: "internal-first-jotting",
        title: "iDevNotes 上架了！",
        type: .jotting,
    )

    // 内部数据列表
    private static var internalArticles: [Article] {
        [
            iOSPathsWay,
            HowtoPromptUserstoRateYourApp,
            firstJotting,
            SwiftAPIDesignGuidelines,
        ]
    }

    /// 导入内部数据，覆盖已存在的内部数据
    /// - Parameter modelContext: SwiftData 模型上下文
    static func importInternalData(modelContext: ModelContext) {
        do {
            // 先删除所有已存在的内部数据
            try modelContext.delete(model: Article.self)

            // 插入所有内部数据（覆盖）
            for article in internalArticles {
                modelContext.insert(article)
            }

            // 保存更改
            try modelContext.save()
        } catch {
            print("导入内部数据失败: \(error.localizedDescription)")
        }
    }

    /// 插入预览数据（用于 Xcode Preview，不检查重复）
    /// - Parameter modelContext: SwiftData 模型上下文
    static func insertSampleData(modelContext: ModelContext) {
        for article in internalArticles {
            modelContext.insert(article)
        }
    }
}
