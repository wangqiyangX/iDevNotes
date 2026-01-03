//
//  HomeView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2025/12/31.
//

import SwiftData
import SwiftDraw
import SwiftUI

struct HomeView: View {
    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    @Query
    private var articles: [Article]

    // 热力图天数（112天，最后一个代表今天）
    private let heatmapDays = 112

    // 计算每天的文章数目和文章列表
    private var dailyArticleCounts: [Date: (count: Int, articles: [Article])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        var counts: [Date: (count: Int, articles: [Article])] = [:]

        // 从今天往前推112天
        for dayOffset in (0..<heatmapDays).reversed() {
            guard
                let date = calendar.date(
                    byAdding: .day,
                    value: -dayOffset,
                    to: today
                )
            else {
                continue
            }

            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay =
                calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

            let dayArticles = articles.filter { article in
                article.timestamp >= startOfDay && article.timestamp < endOfDay
            }

            counts[startOfDay] = (
                count: dayArticles.count, articles: dayArticles
            )
        }

        return counts
    }

    // 计算透明度等级（4个等级）
    private func opacityForCount(_ count: Int, minCount: Int, maxCount: Int)
        -> Double
    {
        guard maxCount > minCount else {
            return count > 0 ? 1.0 : 0.2
        }

        let range = Double(maxCount - minCount)
        let normalizedCount = Double(count - minCount)

        // 分为4个等级：0-25%, 25-50%, 50-75%, 75-100%
        if count == 0 {
            return 0.2
        } else if normalizedCount <= range * 0.25 {
            return 0.4
        } else if normalizedCount <= range * 0.5 {
            return 0.6
        } else if normalizedCount <= range * 0.75 {
            return 0.8
        } else {
            return 1.0
        }
    }

    var body: some View {
        let counts = dailyArticleCounts
        let minCount = counts.values.map { $0.count }.min() ?? 0
        let maxCount = counts.values.map { $0.count }.max() ?? 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        NavigationStack {
            List {
                SVGView("logo.svg")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity, alignment: .center)
                Section("过去一年共计发布\(articles.count)篇文章") {
                    LazyHGrid(
                        rows: [
                            .init(),
                            .init(),
                            .init(),
                            .init(),
                            .init(),
                            .init(),
                            .init(),
                        ],
                        spacing: 4
                    ) {
                        ForEach((0..<heatmapDays).reversed(), id: \.self) {
                            dayOffset in
                            let date =
                                calendar.date(
                                    byAdding: .day,
                                    value: -dayOffset,
                                    to: today
                                ) ?? today
                            let startOfDay = calendar.startOfDay(for: date)
                            let dayData =
                                counts[startOfDay] ?? (count: 0, articles: [])
                            let count = dayData.count
                            let dayArticles = dayData.articles
                            let opacity = opacityForCount(
                                count,
                                minCount: minCount,
                                maxCount: maxCount
                            )

                            OpacityGridItemView(
                                date: startOfDay,
                                opacity: opacity,
                                articles: dayArticles
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                Section {
                    ForEach(
                        articles
                            .filter({
                                $0.type == .note
                            })
                            .sorted(by: { $0.timestamp > $1.timestamp })
                            .prefix(1),
                        id: \.self
                    ) { article in
                        NavigationLink {
                            ArticleDetails(article)
                        } label: {
                            ListItemView(article)
                        }
                    }
                } header: {
                    Text("最新内容")
                }
            }
            .navigationTitle("序章")
            .navigationSubtitle("通道术、达时务，无事浮躁。")
            .toolbar {
                Picker("外观", selection: $scheme) {
                    ForEach(AppColorScheme.allCases, id: \.self) {
                        scheme in
                        Label(
                            scheme.title,
                            systemImage: scheme.icon
                        )
                    }
                }
                .padding(.trailing, 8)
                .fixedSize()
            }
        }
    }
}

#Preview("RootTabsView") {
    ModelContainerPreview(ModelContainer.sample) {
        RootTabsView()
            .modelContainer(for: Article.self)
    }
}
