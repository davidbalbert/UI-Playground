//
//  Collide.swift
//  UI Playground
//
//  Created by David Albert on 10/9/22.
//

import CoreGraphics

protocol Collidable {
    var vertices: [CGVector] { get }
}

// Normal vector always points away from B and towards A
func collide(_ a: Collidable, _ b: Collidable) -> (CGVector, CGVector, Double) {
    let (v1, n1, sep1) = collide(a: a, withB: b)
    let (v2, n2, sep2) = collide(a: b, withB: a)

    if sep1 >= sep2 {
        return (v1, n1, sep1)
    } else {
        return (v2, -n2, sep2)
    }
}

// Collide using the vertices of a and the edges of B. The normal
// always points out from B.
func collide(a: Collidable, withB b: Collidable) -> (CGVector, CGVector, Double) {
    var separation: Double = -.infinity
    var collisionNormal: CGVector = .zero
    var collisionVertex: CGVector = .zero

    let vertices = b.vertices

    for (i, vb) in vertices.enumerated() {
        let vNext = vertices[(i+1) % vertices.count]
        let edge = vb - vNext
        let normal = edge.rotated(by: .degrees(90)).normalized

        var minSep: Double = .infinity
        var minVertex: CGVector = .zero
        for va in a.vertices {
            let sep = (va-vb).dotProduct(normal)

            if sep < minSep {
                minSep = sep
                minVertex = va
            }
        }

        if (minSep > separation) {
            collisionNormal = normal
            separation = minSep
            collisionVertex = minVertex
        }
    }

    return (collisionVertex, collisionNormal, separation)
}
