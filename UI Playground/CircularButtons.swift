//
//  CircularButtons.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize? = nil

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

struct CircularButtonStyle: ButtonStyle {
    @State var textSize: CGSize?
    @Environment(\.circularButtonColor) var color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if let size = textSize {
                let r = max(size.width, size.height)

                Circle()
                    .fill(color)
                    .frame(width: r, height: r)
                    .brightness(configuration.isPressed ? -0.1 : 0)
            }

            configuration.label
                .padding()
                .overlay {
                    GeometryReader { proxy in
                        Color.clear.preference(key: SizeKey.self, value: proxy.size)
                    }
                }
                .onPreferenceChange(SizeKey.self) { size in
                    textSize = size
                }
        }
    }
}

extension ButtonStyle where Self == CircularButtonStyle {
    static var circular: CircularButtonStyle { CircularButtonStyle() }
}

struct CircularButtonColor: EnvironmentKey {
    static var defaultValue: Color { .blue }
}

extension EnvironmentValues {
    var circularButtonColor: Color {
        get { self[CircularButtonColor.self] }
        set { self[CircularButtonColor.self] = newValue }
    }
}

extension View {
    func circularButtonColor(_ color: Color) -> some View {
        environment(\.circularButtonColor, color)
    }
}

struct CircularButtons: View {
    @State var color: Color = .blue

    var body: some View {
        VStack {
            Group {
                Button("A very long title") { print("foo") }
                Button("A\nvery\ntall\ntitle") { print("tall") }
                Button("Short") { print("bar") }
                Button("A") { print("baz") }
            }
            .buttonStyle(.circular)
            .circularButtonColor(color)
            .foregroundColor(.white)

            Picker("Color", selection: $color) {
                Text("Blue").tag(Color.blue)
                Text("Green").tag(Color.green)
            }
            .pickerStyle(.radioGroup)
            .padding()
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct CircularButtons_Previews: PreviewProvider {
    static var previews: some View {
        CircularButtons()
    }
}
