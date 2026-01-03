//
//  SearchView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2025/12/31.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @Query
    private var articles: [Article]

    @State private var searchText = ""
    @State private var searchArticleType: ArticleType = .note

    @Environment(\.isSearching) private var isSearching

    private var filteredArticles: [Article] {
        if !searchText.isEmpty {
            return articles.filter {
                $0.title.localizedStandardContains(searchText)
                    || $0.desc?.localizedStandardContains(searchText) ?? false
            }.filter {
                $0.type == searchArticleType
            }
        }
        return []
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredArticles) { article in
                    NavigationLink {
                        ArticleDetails(article)
                    } label: {
                        ListItemView(article)
                    }
                }
            }
            .navigationTitle("搜索")
            .searchable(text: $searchText)
            .searchScopes($searchArticleType) {
                ForEach(ArticleType.allCases) { type in
                    Text(type.displayName)
                        .tag(type)
                }
            }
            .overlay {
                if !searchText.isEmpty && filteredArticles.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "无最近搜索",
                        systemImage:
                            "clock.arrow.trianglehead.counterclockwise.rotate.90",
                        description: Text("在你搜索文记、随笔等内容时会添加最近的搜索。")
                    )
                }
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SearchView()
            .modelContainer(for: Article.self)
    }
}
