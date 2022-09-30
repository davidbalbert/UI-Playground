//
//  BouncingBall.swift
//  UI Playground
//
//  Created by David Albert on 9/29/22.
//

import SwiftUI

class Ball: ObservableObject {
    @Published var center: CGPoint = .zero

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

    func update(_ dt: TimeInterval) {
        if dragged {
            dragged = false
            return
        }

        let g = 9.8 // m/s^2; down is positive in SwiftUI

        velocity.dy += g*dt
        position.y += velocity.dy * dt
    }

    var dragged = false

    func drag(to point: CGPoint) {
        center = point
        velocity = .zero
        dragged = true
    }
}

struct BouncingBall: View {
    @State var canvasSize: CGSize?

    @StateObject var ball = Ball()

    @State var dragging = false

    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named("canvas"))
            .onChanged { value in
                dragging = true
                ball.drag(to: value.location)
            }
            .onEnded { value in
                dragging = false
                ball.drag(to: value.location)
            }
    }

    var isAnimating: Bool {
        guard let canvasSize else { return false }

        return !dragging && ball.frame.maxY <= canvasSize.height
    }

    var body: some View {
        TimelineView(.animation(paused: !isAnimating)) { context in
            let t = context.date.timeIntervalSinceReferenceDate

            Circle()
                .fill(.white)
                .frame(width: ball.size.width, height: ball.size.height)
                .position(ball.center)
                .gesture(dragGesture)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .coordinateSpace(name: "canvas")
                .onSizeChange { size in
                    guard let size else { return }

                    if canvasSize == nil {
                        ball.center = CGPoint(x: size.width/2, y: size.height/2)
                    }

                    canvasSize = size
                }
                .onChange(of: t as TimeInterval) { [t] newT in
                    ball.update(newT - t)
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
