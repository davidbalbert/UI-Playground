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
}
