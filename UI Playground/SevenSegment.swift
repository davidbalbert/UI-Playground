//
//  SevenSegment.swift
//  UI Playground
//
//  Created by David Albert on 8/23/22.
//

import SwiftUI

struct HorizontalSegment: Shape {
    var unitPoints: [CGPoint] {
        [
            CGPoint(x: 5.0/36, y: 0),
            CGPoint(x: 31.0/36, y: 0),
            CGPoint(x: 36.0/36, y: 5.0/36),
            CGPoint(x: 31.0/36, y: 10.0/36),
            CGPoint(x: 5.0/36, y: 10.0/36),
            CGPoint(x: 0, y: 5.0/36),
        ]
    }

    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = 10.0/36 * width

        let origin = CGPoint(x: 0, y: (rect.height-height) / 2)

        return Path { p in
            p.addLines(unitPoints.map { origin + width*$0 })
        }
    }
}

struct VerticalSegment: Shape {
    var unitPoints: [CGPoint] {
        [
            CGPoint(x: 0, y: 5.0/33),
            CGPoint(x: 5.0/33, y: 0),
            CGPoint(x: 10.0/33, y: 5.0/33),
            CGPoint(x: 10.0/33, y: 28.0/33),
            CGPoint(x: 5.0/33, y: 33.0/33),
            CGPoint(x: 0, y: 33.0/33),
        ]
    }

    func path(in rect: CGRect) -> Path {
        let height = rect.height
        let width = 10.0/33 * height

        let origin = CGPoint(x: (rect.width-width) / 2, y: 0)

        return Path { p in
            p.addLines(unitPoints.map { origin + height*$0 })
        }
    }
}

struct Digit: View {
    var color: Color

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = 48.0/80 * height

            ZStack {
                VStack {
                    HorizontalSegment()
                        .frame(width: width)

                }
            }
            .frame(width: width)
            // hack to make sure the GeometryReader lays us out in the center.
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .eraseToAnyView()
    }

//    #if DEBUG
//    @ObservedObject var iO = injectionObserver
//    #endif
}

struct SevenSegment: View {
    var body: some View {
        HStack {
            Digit(color: .red)
        }
        .eraseToAnyView()
    }

//    #if DEBUG
//    @ObservedObject var iO = injectionObserver
//    #endif
}

struct SevenSegment_Previews: PreviewProvider {
    static var previews: some View {
        SevenSegment()
    }
}
