//
//  CollisionDetection.swift
//  UI Playground
//
//  Created by David Albert on 10/1/22.
//

import SwiftUI

struct RotatedRect: Identifiable, Collidable {
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

    var vertices: [CGVector] {
        let c = CGVector(center)

        return [
            CGVector(dx: center.x-width/2, dy: center.y-height/2).rotated(by: angle, around: c),
            CGVector(dx: center.x+width/2, dy: center.y-height/2).rotated(by: angle, around: c),
            CGVector(dx: center.x+width/2, dy: center.y+height/2).rotated(by: angle, around: c),
            CGVector(dx: center.x-width/2, dy: center.y+height/2).rotated(by: angle, around: c)
        ]
    }

    func intersects(_ rect2: RotatedRect) -> Bool {
        collisionNormal(from: self, to: rect2).magnitude <= 0 && collisionNormal(from: rect2, to: self).magnitude <= 0
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
