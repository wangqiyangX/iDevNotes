//
//  CodeAndPreviewView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/3.
//

import SwiftCodeView
import SwiftUI
import UniformTypeIdentifiers

struct CodeAndPreviewView<Content: View>: View {
    let codeString: String
    let fileName: String?
    let content: Content?

    // 带预览内容的初始化器
    init(
        _ codeString: String,
        fileName: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.codeString = codeString
        self.fileName = fileName
        self.content = content()
    }

    // 不带预览内容的初始化器
    init(
        _ codeString: String,
        fileName: String? = nil
    ) where Content == EmptyView {
        self.codeString = codeString
        self.fileName = fileName
        self.content = nil
    }

    private enum ContentType: CaseIterable, Identifiable {
        case code
        case preview

        var id: Self { self }

        var displayName: String {
            switch self {
            case .code:
                "代码"
            case .preview:
                "预览"
            }
        }
    }

    @State private var selectedType: ContentType = .code

    var body: some View {
        VStack(alignment: .leading) {
            if let fileName {
                HStack(alignment: .center) {
                    Label {
                        Text(fileName)
                            .font(.caption)
                    } icon: {
                        Image(systemName: "swift")
                            .foregroundStyle(.orange)
                    }
                    Spacer()
                }
            }
            Picker("", selection: $selectedType) {
                ForEach(ContentType.allCases) { type in
                    Text(type.displayName)
                        .selectionDisabled(type == .preview && content == nil)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)

            Group {
                switch selectedType {
                case .code:
                    ScrollView(.horizontal) {
                        LazyHStack {
                            SwiftCodeView(codeString)
                                .padding()
                        }
                    }
                    .scrollIndicators(.hidden)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            #if os(iOS)
                                UIPasteboard.general
                                    .setValue(
                                        codeString,
                                        forPasteboardType: UTType
                                            .plainText.identifier
                                    )
                            #endif
                        } label: {
                            Image(systemName: "document.on.document")
                        }
                        .buttonStyle(.glass)
                        .font(.caption)
                        .padding()
                    }
                case .preview:
                    if let content {
                        VStack {
                            content
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .glassEffect(.regular, in: .rect(cornerRadius: 20))
                    }
                }
            }
        }
        .padding()
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview("CodeAndPreviewViewWithPreview") {
    CodeAndPreviewView(
        """
        struct ExampleView: View {
            var body: some View {
                Text("Hello, World!")
            }
        }
        """,
        fileName: "Example.swift"
    ) {
        Text("Hello, World!")
    }
}

#Preview("CodeAndPreviewView") {
    CodeAndPreviewView(
        """
        let greeting = "Hello, World!"
        print(greeting)
        """,
        fileName: "CodeOnly.swift"
    )
}
