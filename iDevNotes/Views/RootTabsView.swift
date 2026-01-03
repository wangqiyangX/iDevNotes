//
//  RootTabsView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2025/12/31.
//

import SwiftData
import SwiftUI

struct RootTabsView: View {
    @State private var searchText: String = ""
    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    var body: some View {
        TabView {
            Tab("序章", systemImage: "finder") {
                HomeView()
            }
            Tab("文记", systemImage: "list.bullet") {
                NotesView()
            }
            Tab("随笔", systemImage: "pencil.line") {
                JottingsView()
            }
            Tab("絮述", systemImage: "at") {
                AboutView()
            }
            Tab("搜索", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        RootTabsView()
            .modelContainer(for: Article.self)
    }
}
