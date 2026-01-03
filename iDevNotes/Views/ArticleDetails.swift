//
//  ArticleDetails.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/1.
//

import SwiftData
import SwiftUI

struct ArticleDetails: View {
    let article: Article

    init(_ article: Article) {
        self.article = article
    }

    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)

                    HStack {
                        Label(
                            article.timestamp.formatted(),
                            systemImage: "calendar"
                        )

                        if let series = article.series {
                            Divider()
                            Label(
                                series.displayName,
                                systemImage: "square.stack.3d.up"
                            )
                        }

                        if !article.tags.isEmpty {
                            Divider()

                            HStack {
                                ForEach(article.tags) { tag in
                                    Label(
                                        tag.displayName,
                                        systemImage: "number"
                                    )
                                }
                            }
                        }
                    }
                    .foregroundStyle(.secondary)
                    .font(.caption)

                    if let desc = article.desc {
                        Text(desc)
                    }

                    Divider()

                    AnyView(article.detailsView)

                }
                .padding(.horizontal)
            }
            .toolbarVisibility(.hidden, for: .tabBar)
            .toolbar {
                Menu {
                    ForEach(article.toc, id: \.self) { item in
                        Button {
                            withAnimation(.easeOut) {
                                proxy.scrollTo(item)
                            }
                        } label: {
                            Text(item)
                        }
                    }
                } label: {
                    Label("目录", systemImage: "list.bullet.rectangle")
                }
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

#Preview("NoteDetails") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ArticleDetails(Article.如何提示用户给你的应用评价)
        }
    }
}
