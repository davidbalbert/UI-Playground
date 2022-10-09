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

func collide(_ a: Collidable, _ b: Collidable) -> (CGVector, Double) {
    let (n1, sep1) = collide(a: a, withB: b)
    let (n2, sep2) = collide(a: b, withB: a)

    if sep1 < sep2 {
        return (n1, sep1)
    } else {
        return (n2, sep2)
    }
}

func collide(a: Collidable, withB b: Collidable) -> (CGVector, Double) {
    var separation: Double = -.infinity
    var collisionNormal: CGVector = .zero

    let vertices = b.vertices

    for (i, vb) in vertices.enumerated() {
        let vNext = vertices[(i+1) % vertices.count]
        let edge = vb - vNext
        let normal = edge.rotated(by: .degrees(90)).normalized

        var minSep: Double = .infinity
        for va in a.vertices {
            minSep = min(minSep, (va-vb).dotProduct(normal))
        }

        if (minSep > separation) {
            collisionNormal = normal
            separation = minSep
        }
    }

    return (collisionNormal, separation)
}
