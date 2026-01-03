/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
An extension that creates a sample model container to use when previewing
 views in Xcode.
*/

import SwiftData

extension ModelContainer {
    @MainActor
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([Article.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
        
        // 在主线程上同步插入预览数据
        let context = container.mainContext
        Article.insertSampleData(modelContext: context)
        
        return container
    }
}
