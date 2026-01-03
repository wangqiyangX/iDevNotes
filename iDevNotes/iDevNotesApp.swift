//
//  iDevNotesApp.swift
//  iDevNotes
//
//  Created by wangqiyang on 12/16/25.
//

import SwiftData
import SwiftUI

@main
struct iDevNotesApp: App {
    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Article.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            // 导入内部数据（确保不重复）
            let context = container.mainContext
            Article.importInternalData(modelContext: context)

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootTabsView()
                .preferredColorScheme(
                    scheme == .system
                        ? nil : scheme == .dark ? .dark : .light
                )
                .modelContainer(sharedModelContainer)
        }
    }
}
