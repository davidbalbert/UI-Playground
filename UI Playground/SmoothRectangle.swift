//
//  SmoothRectangle.swift
//  UI Playground
//
//  Created by David Albert on 8/25/22.
//

import SwiftUI

struct SmoothRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.addLines([
                CGPoint(x: rect.minX, y: rect.minY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.maxX, y: rect.minY),
                CGPoint(x: rect.minX, y: rect.minY),
            ])
        }
    }
}
