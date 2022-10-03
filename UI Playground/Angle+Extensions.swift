//
//  Angle+Extensions.swift
//  UI Playground
//
//  Created by David Albert on 10/1/22.
//

import SwiftUI

func sin(_ angle: Angle) -> Double {
    sin(angle.radians)
}

func cos(_ angle: Angle) -> Double {
    cos(angle.radians)
}

func tan(_ angle: Angle) -> Double {
    tan(angle.radians)
}

extension CGVector {
    var angle: Angle {
        .radians(atan2(dy, dx))
    }

    // Counter-clockwise
    func rotated(by angle: Angle, around origin: CGVector = .zero) -> CGVector {
        let tr = self - origin

        let x = tr.dx*cos(angle) - tr.dy*sin(angle)
        let y = tr.dx*sin(angle) + tr.dy*cos(angle)

        return origin + CGVector(dx: x, dy: y)
    }
}
