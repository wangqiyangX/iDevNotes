//
//  JottingsView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/1.
//

import SwiftData
import SwiftUI

struct JottingsView: View {
    @Query
    private var articles: [Article]

    @State private var selectedArticleTag: ArticleTag? = nil
    @Environment(\.modelContext) private var modelContext
    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    var filteredJottings: [Article] {
        let temp = articles.filter {
            $0.type == .jotting
        }
        if let selectedArticleTag {
            return temp.filter {
                $0.tags.contains(selectedArticleTag)
            }
        }
        return temp
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(filteredJottings) { jotting in
                        NavigationLink {
                            ArticleDetails(jotting)
                        } label: {
                            ListItemView(jotting)
                        }
                    }
                } header: {
                    if let selectedArticleTag {
                        Text(selectedArticleTag.displayName)
                    }
                }
            }
            .navigationTitle("随笔")
            .navigationSubtitle("随兴而写的小记")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Menu {
                        Picker("标签", selection: $selectedArticleTag) {
                            Text("全部")
                                .tag(nil as ArticleTag?)
                            ForEach(ArticleTag.allCases) { tag in
                                Text(tag.displayName)
                                    .tag(tag as ArticleTag?)
                            }
                        }
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
                    #if os(iOS)
                        .padding(.trailing, 8)
                        .fixedSize()
                    #endif
                }
            }
            #if os(macOS)
                .formStyle(.grouped)
            #endif
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        JottingsView()
    }
}
