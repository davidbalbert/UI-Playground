//
//  BezierCurve.swift
//  UI Playground
//
//  Created by David Albert on 8/26/22.
//

import SwiftUI

struct BezierCurve: Identifiable {
    var id = UUID()
    var p1: CGPoint
    var p2: CGPoint
    var cp1: CGPoint
    var cp2: CGPoint

    var path: Path {
        Path { p in
            p.move(to: p1)
            p.addCurve(to: p2, control1: cp1, control2: cp2)
        }
    }
}
