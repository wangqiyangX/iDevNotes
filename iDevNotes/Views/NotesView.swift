//
//  NotesView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/1.
//

import SwiftData
import SwiftUI

struct NotesView: View {
    @Query
    private var articles: [Article]

    @State private var selectedArticleTag: ArticleTag? = nil
    @State private var selectedArticleSeries: ArticleSeries? = nil

    @Environment(\.modelContext) private var modelContext

    private var filteredNotes: [Article] {
        let temp = articles.filter {
            $0.type == .note
        }
        if let selectedArticleTag {
            return temp.filter {
                $0.tags.contains(selectedArticleTag)
            }
        }
        if let selectedArticleSeries {
            return temp.filter {
                $0.series == selectedArticleSeries
            }
        }
        return temp
    }

    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(filteredNotes) { note in
                        NavigationLink {
                            ArticleDetails(note)
                        } label: {
                            ListItemView(note)
                        }
                    }
                } header: {
                    if let selectedArticleSeries {
                        Text(selectedArticleSeries.displayName)
                    }
                    if let selectedArticleTag {
                        Text(selectedArticleTag.displayName)
                    }
                }
            }
            .navigationTitle("文记")
            .navigationSubtitle("经过整理的长文。")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("系列", selection: $selectedArticleSeries) {
                            Text("全部")
                                .tag(nil as ArticleSeries?)
                            ForEach(ArticleSeries.allCases) { series in
                                Text(series.displayName)
                                    .tag(series as ArticleSeries?)
                            }
                        }
                        .pickerStyle(.menu)

                        Picker("标签", selection: $selectedArticleTag) {
                            Text("全部")
                                .tag(nil as ArticleTag?)
                            ForEach(ArticleTag.allCases) { tag in
                                Text(tag.displayName)
                                    .tag(tag as ArticleTag?)
                            }
                        }
                        .pickerStyle(.menu)
                    } label: {
                        Label("筛选", systemImage: "line.3.horizontal.decrease")
                    }
                }
                ToolbarItem {
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
}

#Preview("NotesView") {
    ModelContainerPreview(ModelContainer.sample) {
        NotesView()
            .modelContainer(for: Article.self)
    }
}

#Preview("RootTabsView") {
    ModelContainerPreview(ModelContainer.sample) {
        RootTabsView()
            .modelContainer(for: Article.self)
    }
}
