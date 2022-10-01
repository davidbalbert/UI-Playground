//
//  CG+Extensions.swift
//  UI Playground
//
//  Created by David Albert on 8/23/22.
//

import Foundation

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
}

extension CGSize {
    static func *(_ a: CGSize, _ b: CGFloat) -> CGSize {
        CGSize(width: a.width * b, height: a.height * b)
    }

    static func /(_ a: CGSize, _ b: CGFloat) -> CGSize {
        CGSize(width: a.width / b, height: a.height / b)
    }
}
