//
//  PhotoGrid.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct PhotoGrid: View {
    @State var slowAnimation = false
    @State var selection: Int?

    var animation: Animation {
        if slowAnimation {
            return .default.speed(0.25)
        } else {
            return .default
        }
    }

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)], spacing: 3) {
                        ForEach(1..<11) { i in
                            Image("beach_\(i)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                                .onTapGesture {
                                    selection = i
                                }
                        }
                    }
                }

                Toggle("Slow Animations", isOn: $slowAnimation)
                    .padding()
            }
            .padding(3)
            .opacity(selection == nil ? 1 : 0)

            if let s = selection {
                Image("beach_\(s)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        selection = nil
                    }
            }
        }
        .background(.white)
        .animation(animation, value: selection)
        .navigationTitle("Photo Grid")
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct PhotoGrid_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGrid()
    }
}
