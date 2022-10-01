//
//  MassDamperSpring.swift
//  UI Playground
//
//  Created by David Albert on 9/30/22.
//

import SwiftUI

struct PhysicsBody: Identifiable {
    var id = UUID()

    var position: CGPoint
    var velocity: CGVector
    var size: CGSize

    var frame: CGRect {
        CGRect(origin: CGPoint(x: position.x - size.width/2, y: position.y - size.height/2), size: size)
    }
}

fileprivate class World: ObservableObject {
    var bodies: [PhysicsBody] = []
    var lastTime: Date = .distantPast
    var size: CGSize = .zero

    func add(_ body: PhysicsBody) {
        bodies.append(body)
    }

    func update(time: Date, size: CGSize) {
        let dt = min(lastTime.distance(to: time), 1.0/60.0)
        lastTime = time
        self.size = size

        let g = -9.81 // m/s^2

        for i in bodies.indices {
            bodies[i].velocity.dy += g*dt

            bodies[i].position.x += bodies[i].velocity.dx*dt
            bodies[i].position.y += bodies[i].velocity.dy*dt
        }

        bodies.removeAll { $0.frame.maxY < 0 }
    }

    var pointsPerMeter: Double {
        200
    }

    func convertToWorld(_ p: CGPoint) -> CGPoint {
        CGPoint(x: (p.x - size.width/2) / pointsPerMeter, y: -(p.y - size.height)/pointsPerMeter)
    }

    func convertToView(_ p: CGPoint) -> CGPoint {
        CGPoint(x: p.x*pointsPerMeter + size.width/2, y: -p.y*pointsPerMeter + size.height)
    }

    func convertToWorld(_ size: CGSize) -> CGSize {
        size / pointsPerMeter
    }

    func convertToView(_ size: CGSize) -> CGSize {
        size * pointsPerMeter
    }
}

extension World {
    @ViewBuilder func view(body: PhysicsBody) -> some View {
        let position = convertToView(body.position)
        let size = convertToView(body.size)

        Color.white
            .position(position)
            .frame(width: size.width, height: size.height)
    }
}

struct PhysicsSimulation: View {
    @StateObject fileprivate var world = World()

    var body: some View {
        TimelineView(.animation) { context in
            GeometryReader { proxy in
                let _ = world.update(time: context.date, size: proxy.size)

                ForEach(world.bodies) { body in
                    world.view(body: body)
                }
            }
        }
        .background(.black)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    world.add(PhysicsBody(position: world.convertToWorld(value.location), velocity: .zero, size: CGSize(width: 0.2, height: 0.2)))
                }
        )
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct MassDamperSpring_Previews: PreviewProvider {
    static var previews: some View {
        PhysicsSimulation()
    }
}
