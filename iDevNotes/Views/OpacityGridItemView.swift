//
//  OpacityGridItemView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/2.
//

import SwiftUI

struct OpacityGridItemView: View {
    @State private var showPopover: Bool = false

    let date: Date
    let opacity: Double
    let articles: [Article]

    init(date: Date, opacity: Double, articles: [Article]) {
        self.date = date
        self.opacity = opacity
        self.articles = articles
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(.secondary.opacity(opacity))
            .frame(width: 16, height: 16)
            .popover(
                isPresented: $showPopover,
                attachmentAnchor: .point(.top),
                arrowEdge: .bottom
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)

                    if articles.isEmpty {
                        Text("无文章")
                    } else {
                        ForEach(articles, id: \.id) { article in
                            Text(article.title)
                        }
                    }
                }
                .padding()
                .presentationCompactAdaptation(.popover)
            }
            .onTapGesture {
                showPopover = true
            }
    }
}
