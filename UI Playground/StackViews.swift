//
//  StackViews.swift
//  UI Playground
//
//  Created by David Albert on 8/21/22.
//

import SwiftUI

struct StackViews: View {
    @State var url: URL?

    var body: some View {
        VStack {
            MeasureBehavior(initialWidth: 300) {
                HStack {
                    Text("Hello, World")

                    Rectangle()
                        .fill(.red)
                        .frame(minWidth: 200)
                }
                .measured()
            }

            Spacer()

            HStack {
                if let url = url {
                    HStack(spacing: 0) {
                        Group {
                            Text(url.deletingLastPathComponent().path + "/")
                                .truncationMode(.middle)
                            Text(url.lastPathComponent)
                                .layoutPriority(1)
                        }
                        .lineLimit(1)


                        Button {
                            self.url = nil
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(Color(.tertiaryLabelColor))
                        .padding(.leading, 3)
                    }
                }

                Spacer()

                Button("Select file…") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    if panel.runModal() == .OK {
                        url = panel.url
                    }
                }

            }
            .frame(width: 370)

            Spacer()

            HStack(spacing: 0) {
                Rectangle()
                    .fill(.red)
                    .frame(minWidth: 50)
                    .measured()

                Rectangle()
                    .fill(.blue)
                    .frame(maxWidth: 100)
                    .layoutPriority(1)
                    .measured()
            }
            .frame(width: 75, height: 50)
            .border(.black)
        }
        .padding(40)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct StackViews_Previews: PreviewProvider {
    static var previews: some View {
        StackViews()
    }
}
