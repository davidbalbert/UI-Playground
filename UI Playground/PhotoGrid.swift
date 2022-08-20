//
//  PhotoGrid.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct TransitionIsActiveKey: EnvironmentKey {
    static var defaultValue = false
}

extension EnvironmentValues {
    var transitionIsActive: Bool {
        get { self[TransitionIsActiveKey.self] }
        set { self[TransitionIsActiveKey.self] = newValue }
    }
}

struct TransitionIsActive: ViewModifier {
    var active: Bool

    func body(content: Content) -> some View {
        content
            .environment(\.transitionIsActive, active)
    }
}

struct TransitionReader<Content: View>: View {
    @ViewBuilder var content: (Bool) -> Content
    @Environment(\.transitionIsActive) var active

    var body: some View {
        content(active)
    }
}

extension AnyTransition {
    static var readable: AnyTransition = .modifier(active: TransitionIsActive(active: true), identity: TransitionIsActive(active: false))
}

struct PhotoGrid: View {
    @State var slowAnimation = false
    @State var selection: Int?

    @Namespace var ns
    @Namespace var dummyNS

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
                                .matchedGeometryEffect(id: i, in: ns)
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                                .contentShape(Rectangle())
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
                VStack {
                    TransitionReader { active in
                        Image("beach_\(s)")
                            .resizable()
                            .mask {
                                Rectangle()
                                    .aspectRatio(1, contentMode: active ? .fit : .fill)
                            }
                            .matchedGeometryEffect(id: s, in: active ? ns : dummyNS, isSource: false)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                selection = nil
                            }
                    }
                }
                .zIndex(2)
                .id(s)
                .transition(.readable)
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
