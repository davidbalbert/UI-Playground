//
//  MassDamperSpring.swift
//  UI Playground
//
//  Created by David Albert on 9/30/22.
//

import SwiftUI

struct PhysicsBody: Identifiable {
    var id = UUID()

    var fixed: Bool = false

    var mass: Double // kg

    var position: CGVector
    var velocity: CGVector

    var rotation: Angle
    var angularVelocity: Double

    var size: CGSize

    var frame: CGRect {
        CGRect(origin: CGPoint(x: position.dx - size.width/2, y: position.dy - size.height/2), size: size)
    }

    var vertices: [CGVector] {
        let p = position

        return [
            CGVector(dx: p.dx-size.width/2, dy: p.dy-size.height/2).rotated(by: rotation, around: p),
            CGVector(dx: p.dx+size.width/2, dy: p.dy-size.height/2).rotated(by: rotation, around: p),
            CGVector(dx: p.dx+size.width/2, dy: p.dy+size.height/2).rotated(by: rotation, around: p),
            CGVector(dx: p.dx-size.width/2, dy: p.dy+size.height/2).rotated(by: rotation, around: p)
        ]
    }

    var boundingBox: CGRect {
        let vs = vertices

        let xs = vs.map(\.dx)
        let ys = vs.map(\.dy)

        let minX = xs.min()!
        let maxX = xs.max()!
        let minY = ys.min()!
        let maxY = ys.max()!

        let origin = CGPoint(x: minX, y: minY)
        let size = CGSize(width: maxX - minX, height: maxY - minY)

        return CGRect(origin: origin, size: size)
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
        let sizeInMeters = convertToWorld(size)
        let originInMeters = CGPoint(x: 0 - origin.x*sizeInMeters.width, y: 0 - origin.y*sizeInMeters.height)

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
        self.size = size

        let g = CGVector(dx: 0, dy: -9.81) // m/2^2


        while lastTime < time {
            let oldBodies = bodies

            for i in bodies.indices {
                if bodies[i].fixed {
                    continue
                }

                let force = bodies[i].mass * g
                let torque: Double = 0

                let a = force/bodies[i].mass

                bodies[i].velocity += a*dt
                bodies[i].position += bodies[i].velocity*dt

                let alpha = torque/bodies[i].mass
                bodies[i].angularVelocity += alpha*dt
                bodies[i].rotation += .radians(bodies[i].angularVelocity*dt)
            }


            //        var forces: [CGVector] = []
            //        var torques: [CGVector] = []

//            for i in bodies.indices {
//                if bodies[i].fixed {
//                    forces.append(.zero)
//                    torques.append(.zero)
//                } else {
//                    forces.append(CGVector(dx: 0, dy: bodies[i].mass*g))
//                    torques.append(.zero)
//                }
//            }

            lastTime = time
        }

        let b = bounds
        bodies.removeAll { !$0.boundingBox.intersects(b) }

    }

    func convertToWorld(_ p: CGPoint) -> CGVector {
        CGVector(managedTransform.inverted().transform(p))
    }

    func convertToView(_ v: CGVector) -> CGPoint {
        CGPoint(managedTransform.transform(v))
    }

    // abs in these is kind of a hack, but it does seem that the correct behavior
    // for applying a flipped transform to a size is negating the appropriate size
    // component, and it's also non-sensical to have negative sizes.
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
        let size = convertToView(body.size)

        Rectangle()
            .fill(body.fixed ? .red : .white)
            .frame(width: size.width, height: size.height)
            .rotationEffect(body.rotation)
            .position(position)
    }
}

struct PhysicsSimulation: View {
    @StateObject fileprivate var world = World(origin: CGPoint(x: 0.5, y: 0.0), transform: CGAffineTransform(scaleX: 1, y: -1))

    var gesture: some Gesture {
        let dragWithOption = DragGesture(minimumDistance: 0)
            .modifiers(.option)
            .onEnded { value in
                world.add(PhysicsBody(fixed: true, mass: .infinity, position: world.convertToWorld(value.location), velocity: .zero, rotation: .zero, angularVelocity: 0, size: CGSize(width: 0.2, height: 0.2)))
            }

        let drag = DragGesture(minimumDistance: 0)
            .onEnded { value in
                world.add(PhysicsBody(mass: 5, position: world.convertToWorld(value.location), velocity: .zero, rotation: .zero, angularVelocity: 1, size: CGSize(width: 0.2, height: 0.2)))
            }

        return dragWithOption.exclusively(before: drag)
    }

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
        .gesture(gesture)
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
