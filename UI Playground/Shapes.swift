//
//  Shapes.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.addLines([
                CGPoint(x: rect.midX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: rect.minY),
            ])
        }
    }
}

struct Shapes: View {
    @State var rotation: CGFloat = 45

    @State var offsetWidth: CGFloat = 20
    @State var offsetHeight: CGFloat = 20

    var body: some View {
        VStack {
            Triangle()
                .padding(30)

            Rectangle()
                .rotation(Angle(degrees: rotation))
                .fill(.red)
                .border(.blue)
                .frame(width: 100, height: 100)
                .padding(30)

            Form {
                Slider(value: $rotation, in: 0...360) {
                    Text("Rotation")
                }
            }
            .frame(width: 400)

            Rectangle()
                .offset(x: offsetWidth, y: offsetHeight)
                .fill(.green)
                .border(.blue)
                .frame(width: 100, height: 100)
                .padding(30)

            Form {
                Slider(value: $offsetWidth, in: 0...100) {
                    Text("Offset width")
                }

                Slider(value: $offsetHeight, in: 0...100) {
                    Text("Offset height")
                }
            }
            .frame(width: 400)
        }
        .navigationTitle("Shapes")
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        Shapes()
    }
}
