//
//  CG+Extensions.swift
//  UI Playground
//
//  Created by David Albert on 8/23/22.
//

import Foundation

func abs(_ size: CGSize) -> CGSize {
    CGSize(width: abs(size.width), height: abs(size.height))
}

extension CGPoint {
    static func *(_ a: CGFloat, _ b: CGPoint) -> CGPoint {
        CGPoint(x: a*b.x, y: a*b.y)
    }

    static func /(_ a: CGPoint, _ b: CGFloat) -> CGPoint {
        CGPoint(x: a.x/b, y: a.y/b)
    }

    static func +(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        CGPoint(x: a.x+b.x, y: a.y+b.y)
    }

    static func -(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        CGPoint(x: a.x-b.x, y: a.y-b.y)
    }

    var rounded: CGPoint {
        CGPoint(x: x.rounded(), y: y.rounded())
    }
}

extension CGSize {
    static func *(_ a: CGSize, _ b: CGFloat) -> CGSize {
        CGSize(width: a.width * b, height: a.height * b)
    }

    static func /(_ a: CGSize, _ b: CGFloat) -> CGSize {
        CGSize(width: a.width / b, height: a.height / b)
    }
}

extension CGVector {
    static func +(_ a: CGVector, _ b: CGVector) -> CGVector {
        CGVector(dx: a.dx+b.dx, dy: a.dy+b.dy)
    }

    static func -(_ a: CGVector, _ b: CGVector) -> CGVector {
        CGVector(dx: a.dx-b.dx, dy: a.dy-b.dy)
    }

    static func /(_ a: CGVector, _ b: Double) -> CGVector {
        CGVector(dx: a.dx/b, dy: a.dy/b)
    }

    init(_ point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    var magnitude: Double {
        sqrt(pow(dx, 2) + pow(dy, 2))
    }

    var normalized: CGVector {
        self/magnitude
    }

    func dotProduct(_ other: CGVector) -> Double {
        dx*other.dx + dy*other.dy
    }
}

extension CGAffineTransform {
    func transform(_ point: CGPoint) -> CGPoint {
        CGPoint(x: a*point.x + c*point.y + tx, y: b*point.x + d*point.y + ty)
    }

    func transform(_ size: CGSize) -> CGSize {
        CGSize(width: a*size.width + c*size.height, height: b*size.width + d*size.height)
    }
}
