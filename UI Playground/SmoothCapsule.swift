//
//  SmoothCapsule.swift
//  UI Playground
//
//  Created by David Albert on 8/25/22.
//

import SwiftUI

struct SmoothCapsule: InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let hasVerticalCaps = insetRect.width < insetRect.height

        if hasVerticalCaps {
            let r = insetRect.width/2
            let baseRect = insetRect.insetBy(dx: 0, dy: r)

            return Path { p in
                p.move(to: CGPoint(x: baseRect.minX, y: baseRect.minY))
                p.addArc(center: CGPoint(x: baseRect.midX, y: baseRect.minY), radius: r, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
                p.addLine(to: CGPoint(x: baseRect.maxX, y: baseRect.maxY))
                p.addArc(center: CGPoint(x: baseRect.midX, y: baseRect.maxY), radius: r, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                p.addLine(to: CGPoint(x: baseRect.minX, y: baseRect.minY))
            }
        } else {
            let r = insetRect.height/2
            let baseRect = insetRect.insetBy(dx: r, dy: 0)

            return Path { p in
                p.move(to: CGPoint(x: baseRect.minX, y: baseRect.minY))
                p.addLine(to: CGPoint(x: baseRect.maxX, y: baseRect.minY))
                p.addArc(center: CGPoint(x: baseRect.maxX, y: baseRect.midY), radius: r, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
                p.addLine(to: CGPoint(x: baseRect.minX, y: baseRect.maxY))
                p.addArc(center: CGPoint(x: baseRect.minX, y: baseRect.midY), radius: r, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
            }
        }
    }

    func inset(by amount: CGFloat) -> SmoothCapsule {
        var capsule = self
        capsule.insetAmount += amount
        return capsule
    }
}
