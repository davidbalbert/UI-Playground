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

    // Verticies, clockwise with v0 == origin

    var v0: CGPoint {
        rotate(point: CGPoint(x: center.x-width/2, y: center.y-height/2))
    }

    var v1: CGPoint {
        rotate(point: CGPoint(x: center.x+width/2, y: center.y-height/2))
    }

    var v2: CGPoint {
        rotate(point: CGPoint(x: center.x+width/2, y: center.y+height/2))
    }

    var v3: CGPoint {
        rotate(point: CGPoint(x: center.x-width/2, y: center.y+height/2))
    }

    func intersects(_ rect2: RotatedRect) -> Bool {
        let (v0, v1, v2, v3) = (v0, v1, v2, v3)

        let vertices = [v0, v1, v2, v3]
        let endpoints = [
            CGVector(v1-v0),
            CGVector(v2-v1),
            CGVector(v3-v2),
            CGVector(v0-v3)
        ]

        print(vertices, endpoints)

        return false
    }

    private func rotate(point p: CGPoint) -> CGPoint {
        let c = center

        let v = CGVector(dx: p.x-c.x, dy: p.y-c.y)
        let distance = v.magnitude
        let startAngle = v.angle

        let x = c.x + distance*cos(startAngle + angle)
        let y = c.y + distance*sin(startAngle + angle)

        return CGPoint(x: x, y: y)
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
