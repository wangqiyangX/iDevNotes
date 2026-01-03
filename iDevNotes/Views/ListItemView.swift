//
//  ListItemView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/2.
//

import SwiftData
import SwiftUI

struct ListItemView: View {
    let title: String
    let timestamp: Date
    let description: String?

    init(_ article: Article) {
        self.title = article.title
        self.timestamp = article.timestamp
        self.description = article.desc
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(timestamp.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            if let description {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ListItemView(Article.firstJotting)
}
