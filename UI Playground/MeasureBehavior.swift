//
//  LayoutPlayground.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct MeasureBehavior<Content: View>: View {
    @State var width: CGFloat
    @State var height: CGFloat

    var content: Content

    init(initialWidth: CGFloat? = nil, initialHeight: CGFloat? = nil, content: () -> Content) {
        self.content = content()

        _width = State(initialValue: initialWidth ?? 100)
        _height = State(initialValue: initialHeight ?? 100)
    }

    var body: some View {
        VStack {
            VStack {
                content
                    .border(.gray)
                    .frame(width: width, height: height)
                    .border(.black)

                Spacer()
            }
            .frame(height: 210)

            Form {
                HStack {
                    Slider(value: $width, in: 0...500) {
                        Text("Width")
                    }

                    Text("\(Int(width)) pt")
                        .frame(width: 42, alignment: .trailing)
                }

                HStack {
                    Slider(value: $height, in: 0...200) {
                        Text("Height")
                    }
                    Text("\(Int(height)) pt")
                        .frame(width: 42, alignment: .trailing)

                }
            }
            .padding()
            .frame(maxWidth: 400)
            .monospacedDigit()
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct MeasureBehavior_Previews: PreviewProvider {
    static var previews: some View {
        MeasureBehavior {
            Text("hello")
        }
    }
}
