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

//    var rotation: Angle
//    var angularVelocity: Double

    var size: CGSize

    var frame: CGRect {
        CGRect(origin: CGPoint(x: position.x - size.width/2, y: position.y - size.height/2), size: size)
    }

    var boundingBox: CGRect {
        frame
    }
}

fileprivate class World: ObservableObject {
    var bodies: [PhysicsBody] = []

    private var lastTime: Date = .distantPast
    private var managedTransform: CGAffineTransform = .identity

    var transform: CGAffineTransform {
        didSet {
            if oldValue != transform {
                updateManagedTransform()
            }
        }
    }

    // A point in a unit coordinate space with the origin in the lower left
    var origin: CGPoint {
        didSet {
            if oldValue != origin {
                updateManagedTransform()
            }
        }
    }

    // Size of the viewport in points
    var size: CGSize = .zero {
        didSet {
            if oldValue != size {
                updateManagedTransform()
            }
        }
    }

    // Points per meter
    var scale: Double = 200 {
        didSet {
            if oldValue != scale {
                updateManagedTransform()
            }
        }
    }

    // The origin, still in unit coordinate space, transformed by the user's transform
    // TODO: is there a way to make this clearer?
    // TODO: at this point, this could be merged back into updateManagedTransform
    private var transformedOrigin: CGPoint {
        let offset = CGPoint(x: -0.5, y: -0.5)
        let transformedOffset = CGAffineTransform(scaleX: -1, y: -1).concatenating(transform).transform(offset)
        let originTransform = CGAffineTransform(translationX: offset.x, y: offset.y).concatenating(transform).translatedBy(x: transformedOffset.x, y: transformedOffset.y)

        return originTransform.transform(origin)
    }

    // Bounds of the viewport in meters -- won't be valid if the user's transform is not aligned with the X or Y axes
    var bounds: CGRect {
        let inverseTransform = managedTransform.inverted()

        let sizeInMeters = inverseTransform.transform(size)

        let originInPoints = CGPoint(x: origin.x*size.width, y: origin.y*size.height)
        let originInMeters = inverseTransform.transform(originInPoints)

        return CGRect(origin: originInMeters, size: sizeInMeters)
    }

    init(origin: CGPoint = CGPoint(x: 0.5, y: 0.5), transform: CGAffineTransform = .identity) {
        self.origin = origin
        self.transform = transform

        updateManagedTransform()
    }

    private func updateManagedTransform() {
        let t = transformedOrigin
        let projectedSize = CGSize(width: t.x * size.width, height: t.y * size.height)

        managedTransform = transform.concatenating(CGAffineTransform(translationX: projectedSize.width, y: projectedSize.height).scaledBy(x: scale, y: scale))
    }

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

        // TODO: Make this work. It currently doesn't.
//        let b = bounds
//        bodies.removeAll { !$0.boundingBox.intersects(b) }
//        print(bodies.count)
    }

    func convertToWorld(_ p: CGPoint) -> CGPoint {
//        print(transform, managedTransform)
        return managedTransform.inverted().transform(p)
    }

    func convertToView(_ p: CGPoint) -> CGPoint {
        managedTransform.transform(p)
    }

    func convertToWorld(_ size: CGSize) -> CGSize {
        abs(managedTransform.inverted().transform(size))
    }

    func convertToView(_ size: CGSize) -> CGSize {
        abs(managedTransform.transform(size))
    }
}

extension World {
    @ViewBuilder func view(body: PhysicsBody) -> some View {
        let position = convertToView(body.position)

        // The problem: In a flipped coordinate space, size.height is ending up negative. What's the right way to transform a size by an affine transform? Absolute value? I think?
        let size = convertToView(body.size)

        Color.white
            .position(position)
            .frame(width: size.width, height: size.height)
    }
}

struct PhysicsSimulation: View {
    @StateObject fileprivate var world = World(origin: CGPoint(x: 0.5, y: 0.0), transform: CGAffineTransform(scaleX: 1, y: -1))

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
