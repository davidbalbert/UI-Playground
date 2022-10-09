//
//  CollisionNormal.swift
//  UI Playground
//
//  Created by David Albert on 10/9/22.
//

import CoreGraphics

protocol Collidable {
    var vertices: [CGVector] { get }
}

struct CollisionNormal {
    var v: CGVector
    var magnitude: Double
}

func collisionNormal(_ a: Collidable, _ b: Collidable) -> CollisionNormal {
    let n1 = collisionNormal(from: a, to: b)
    let n2 = collisionNormal(from: b, to: a)

    if n1.magnitude < n2.magnitude {
        return n1
    } else {
        return n2
    }
}

func collisionNormal(from a: Collidable, to b: Collidable) -> CollisionNormal {
    var separation: Double = -.infinity
    var v: CGVector = .zero

    let vertices = a.vertices

    for (i, va) in vertices.enumerated() {
        let vNext = vertices[(i+1) % vertices.count]
        let edge = va - vNext
        let normal = edge.rotated(by: .degrees(90)).normalized

        var minSep: Double = .infinity
        for vb in b.vertices {
            minSep = min(minSep, (vb-va).dotProduct(normal))
        }

        // TODO: Why are we getting the max of all these?
        if (minSep > separation) {
            v = normal
            separation = minSep
        }
    }

    return CollisionNormal(v: v, magnitude: separation)
}
