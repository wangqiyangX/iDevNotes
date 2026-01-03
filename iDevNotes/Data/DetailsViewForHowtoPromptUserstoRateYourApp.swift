//
//  DetailsViewForHowtoPromptUserstoRateYourApp.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/3.
//

import SwiftUI

struct H2: View {
    var text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .underline()
            .id(text)
    }
}

struct H3: View {
    var text: LocalizedStringKey

    init(_ text: LocalizedStringKey) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .underline()
    }
}

struct DetailsViewForHowtoPromptUserstoRateYourApp: View {
    var body: some View {
        H2("使用 StoreKit")

        Text("第一种，使用 StoreKit 提供的 `requestReview` 方法，该方法会直接在应用中弹出评分对话框。")

        H3("`requestReview` 的使用方法")

        Text("通过 `requestReview` 弹出的对话框如果太频繁，可能会给用户带来困扰，因此开发者应该选择一个合适的频率。")

        Text(
            "官方文档中提供的示例项目使用了的频率为：每个版本提示一次，在用户完成4次指定操作（一般来说可以是 App 的核心功能）后弹出。"
        )

        Text("该项目使用了 `AppStorage` 存储上述判断条件，确保用户删除 App 后会重置统计数据。")

        CodeAndPreviewView(
            """
            @AppStorage("processCompletedCount") var processCompletedCount = 0
            @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = ""

            /// 判断对话框是否显示的逻辑
            if processCompletedCount >= 4, currentAppVersion != lastVersionPromptedForReview {
                // 调用方法弹出对话框
                presentReview()

                // 更新状态值
                lastVersionPromptedForReview = currentAppVersion
            }
            """
        )

        Text(
            "在 SwiftUI 中，可以通过 Enviroment 值获取 StoreKit 提供的 `RequestReviewAction` 类型变量 `requestReview`，简单完成评价对话框的显示。"
        )

        CodeAndPreviewView(
            #"""
            @Environment(\.requestReview) private var requestReview
            """#
        )

        Text("示例项目中对此方法包含在 Task 中执行，同时使用了 sleep 确保该对话框弹出来时不会打断用户，详细如下：")

        CodeAndPreviewView(
            """
            private func presentReview() {
                Task {
                    // 延迟两秒
                    try await Task.sleep(for: .seconds(2))
                    await requestReview()
                }
            }
            """
        )

        H2("使用 URL")

        Text("第二种，使用 `openURL` 直接跳转到 App Store 中，并使用 URL 参数弹出评价输入框。")

        CodeAndPreviewView(
            #"""
            @Environment(\.openURL) private var openURL

            Button("Write a Review", action: requestReviewManually)

            private func requestReviewManually() {
                // 注意此处的 <#Your App Store ID#> 应该替换为你的 App ID。
                let url = "https://apps.apple.com/app/id<#Your App Store ID#>?action=write-review"

                guard let writeReviewURL = URL(string: url) else {
                    fatalError("Expected a valid URL")
                }

                openURL(writeReviewURL)
            }
            """#
        )

        H2("参考资料")

        Text(
            "[StoreKit 文档的 Reviews 部分](https://developer.apple.com/documentation/storekit)"
        )
        Text(
            "[示例项目：Requesting App Store reviews](https://developer.apple.com/documentation/storekit/requesting-app-store-reviews)"
        )
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                DetailsViewForHowtoPromptUserstoRateYourApp()
            }
            .padding()
        }
    }
}
