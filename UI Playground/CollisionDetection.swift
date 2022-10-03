//
//  CollisionDetection.swift
//  UI Playground
//
//  Created by David Albert on 10/1/22.
//

import SwiftUI

struct RotatedRect: Identifiable {
    var id = UUID()

    var center: CGPoint
    var size: CGSize
    var angle: Angle

    var width: Double {
        size.width
    }

    var height: Double {
        size.height
    }

    var verticies: [CGVector] {
        let c = CGVector(center)

        return [
            CGVector(dx: center.x-width/2, dy: center.y-height/2).rotated(by: angle, around: c),
            CGVector(dx: center.x+width/2, dy: center.y-height/2).rotated(by: angle, around: c),
            CGVector(dx: center.x+width/2, dy: center.y+height/2).rotated(by: angle, around: c),
            CGVector(dx: center.x-width/2, dy: center.y+height/2).rotated(by: angle, around: c)
        ]
    }

    var axes: [CGVector] {
        let x = CGVector(dx: 1, dy: 0)
        let y = CGVector(dx: 0, dy: 1)

        return [x.rotated(by: angle), y.rotated(by: angle)]
    }

    func intersects(_ rect2: RotatedRect) -> Bool {
        return IntersectionDetector(r1: self, r2: rect2).intersects()
    }
}

struct IntersectionDetector {
    var r1: RotatedRect
    var r2: RotatedRect

    func intersects() -> Bool{
        let axes = r1.axes + r2.axes

        for axis in axes {
            let p1 = project(r1, onto: axis)
            let p2 = project(r2, onto: axis)

            if !p1.overlaps(p2) {
                return false
            }
        }

        return true
    }

    func project(_ rect: RotatedRect, onto axis: CGVector) -> ClosedRange<Double> {
        var lowerBound: Double = .infinity
        var upperBound: Double = -.infinity

        for v in rect.verticies {
            let projection = v.dotProduct(axis)
            lowerBound = min(projection, lowerBound)
            upperBound = max(projection, upperBound)
        }

        return lowerBound...upperBound
    }
}

struct RotatedRectView: View {
    @Binding var rect: RotatedRect
    var colliding: Bool

    var body: some View {
        SmoothRectangle()
            .fill(colliding ? .red : .white)
            .frame(width: rect.width, height: rect.height)
            .rotationEffect(rect.angle)
            .position(rect.center)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                    .onChanged { value in
                        rect.center = value.location
                    }
            )
    }
}

struct CollisionDetection: View {
    @State var rects: [RotatedRect] = []

    func isColliding(_ rect: RotatedRect) -> Bool {
        rects.contains { $0.id != rect.id && rect.intersects($0) }
    }

    var body: some View {
        ZStack {
            ForEach($rects) { $rect in
                RotatedRectView(rect: $rect, colliding: isColliding(rect))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(name: "canvas")
        .background(.black)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    let size = CGSize(width: .random(in: 50...80), height: .random(in: 50...80))
                    let angle = Angle.degrees(.random(in: 0..<360))

                    let rect = RotatedRect(center: value.location, size: size, angle: angle)

                    rects.append(rect)
                }
        )
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct CollisionDetection_Previews: PreviewProvider {
    static var previews: some View {
        CollisionDetection()
    }
}
