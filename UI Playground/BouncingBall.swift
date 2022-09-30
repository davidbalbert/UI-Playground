//
//  BouncingBall.swift
//  UI Playground
//
//  Created by David Albert on 9/29/22.
//

import SwiftUI

struct Ball {
    var center: CGPoint = .zero
    var isDragged = false

    var r: Double {
        25
    }

    var size: CGSize {
        CGSize(width: 2*r, height: 2*r)
    }

    var frame: CGRect {
        CGRect(origin: CGPoint(x: center.x-r, y: center.y-r), size: size)
    }

    var metersPerPoint: Double {
        // A basketball has a diameter of 0.24 m
        0.24 / (2*r)
    }

    var position: CGPoint {
        get {
            CGPoint(x: center.x * metersPerPoint, y: center.y * metersPerPoint)
        }
        set {
            center = CGPoint(x: newValue.x / metersPerPoint, y: newValue.y / metersPerPoint)
        }
    }

    var velocity: CGVector = .zero

    mutating func drag(to point: CGPoint) {
        center = point
        velocity = .zero
        isDragged = true
    }

    mutating func endDrag(to point: CGPoint) {
        center = point
        velocity = .zero
        isDragged = false
    }
}


class World: ObservableObject {
    @Published var size: CGSize?
    @Published var ball: Ball = Ball()

    func update(_ dt: TimeInterval) {
        guard let size, size != .zero else { return }
        guard !ball.isDragged else { return }

        if ball.frame.maxY >= size.height {
            ball.velocity.dy *= -1 * 0.8
        }

        let g = 9.8 // m/s^2; down is positive in SwiftUI

        ball.velocity.dy += g*dt

        ball.position.x += ball.velocity.dx * dt
        ball.position.y += ball.velocity.dy * dt

        ball.center.x = ball.center.x.clamped(to: ball.r...size.width-ball.r)
        ball.center.y = ball.center.y.clamped(to: ball.r...size.height-ball.r)
    }
}

struct BallView: View {
    @Binding var ball: Ball

    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named("canvas"))
            .onChanged { value in
                ball.drag(to: value.location)
            }
            .onEnded { value in
                ball.endDrag(to: value.location)
            }
    }

    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: ball.size.width, height: ball.size.height)
            .position(ball.center)
            .gesture(dragGesture)
    }
}

struct BouncingBall: View {
    @StateObject var world = World()

    var body: some View {
        TimelineView(.animation) { context in
            let t = context.date.timeIntervalSinceReferenceDate

            BallView(ball: $world.ball)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .coordinateSpace(name: "canvas")
                .onSizeChange { size in
                    guard let size else { return }

                    if world.size == nil {
                        world.ball.center = CGPoint(x: size.width/2, y: size.height/2)
                    }

                    world.size = size
                }
                .onChange(of: t as TimeInterval) { [t] newT in
                    world.update(newT - t)
                }
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct BouncingBall_Previews: PreviewProvider {
    static var previews: some View {
        BouncingBall()
    }
}