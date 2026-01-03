//
//  AboutView.swift
//  iDevNotes
//
//  Created by wangqiyang on 2026/1/1.
//

import SwiftDraw
import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let url: URL
}

extension Project {
    static let allProjects: [Project] = [
        Project(
            icon: "swift",
            name: "MockKit",
            url: URL(string: "https://swift.org")!
        ),
        Project(
            icon: "swift",
            name: "OnyxLib",
            url: URL(string: "https://swift.org")!
        ),
        Project(
            icon: "swift",
            name: "LineZen",
            url: URL(string: "https://swift.org")!
        ),
        Project(
            icon: "swift",
            name: "SwiftWuwa",
            url: URL(string: "https://swift.org")!
        ),
        Project(
            icon: "swift",
            name: "StarOracle",
            url: URL(string: "https://swift.org")!
        ),
    ]
}

struct AboutView: View {
    @AppStorage("colorScheme") private var scheme: AppColorScheme = .dark

    @Environment(\.colorScheme) private var currentScheme: ColorScheme
    @Environment(\.openURL) private var openURL

    @ViewBuilder
    func projectItem(project: Project) -> some View {
        VStack(spacing: 8) {
            Image(systemName: project.icon)
                .font(.system(size: 44))
            Text(project.name)
                .font(.caption)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding()
        .glassEffect(
            .regular.interactive(),
            in: .rect(cornerRadius: 20)
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section("自述") {
                    Text(
                        "我是一个独立开发者，目前专注于 iOS 端开发，已经上架了几款独立开发的工具，欢迎大家使用"
                    )
                    Text(
                        "本软件作为个人博客，包含了一些技术分享，也有一些小插曲，希望能激发你的兴趣，也希望能让你有所收获"
                    )
                }
                Section("项目") {
                    LazyVGrid(
                        columns: [.init(), .init(), .init()],
                        spacing: 8
                    ) {
                        ForEach(Project.allProjects) {
                            projectItem(project: $0)
                        }
                    }
                }
                Section {
                    Text("联系开发者")
                    Text("分享 iDevNotes")
                    NavigationLink {
                        List {
                            
                        }
                        .navigationTitle("修改日志")
                    } label: {
                        Text("修改日志")
                    }
                    NavigationLink {
                        List {
                            Section("内容免责") {
                                Text("本软件内容仅代表作者个人观点，不构成任何形式的建议或指导。")
                                Text("本软件不对内容的准确性、完整性、时效性承担责任。")
                                Text("用户因使用本软件内容而产生的任何后果，需自行承担责任。")
                            }
                            Section("技术免责") {
                                Text(
                                    "本软件基于 SwiftUI 和 SwiftData 构建构建，本软件尽力保证稳定，但不保证始终可用。"
                                )
                                Text("因不可抗力因素导致的服务中断，本站不承担责任。")
                                Text("第三方服务的故障或政策变更可能影响本站功能。")
                            }
                            Section("链接免责") {
                                Text("本站可能包含指向第三方网站的链接，本站不对这些网站的内容或隐私政策负责。")
                                Text("用户点击外部链接的行为及其后果由用户自行承担。")
                            }
                        }
                        .navigationTitle("免责声明")
                    } label: {
                        Text("免责声明")
                    }
                    NavigationLink {
                        List {

                        }
                        .navigationTitle("致谢")
                    } label: {
                        Text("致谢")
                    }
                } header: {
                    Text("其他")
                } footer: {
                    VStack(alignment: .leading) {
                        Text("版权所有 2026 启阳")
                        HStack(alignment: .center) {
                            Text("署名—非商业性使用—禁止演绎 4.0 协议国际版")
                        }
                    }
                }
            }
            .navigationTitle("絮述")
            .navigationSubtitle("个人信息。")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        openURL(
                            URL(
                                string:
                                    "https://github.com/wangqiyangx/iDevNotes"
                            )!
                        )
                    } label: {
                        if currentScheme == .dark {
                            SVGView("github-dark.svg")
                                .resizable()
                                .scaledToFit()
                        } else {
                            SVGView("github.svg")
                                .resizable()
                                .scaledToFit()
                        }
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

#Preview {
    AboutView()
}
