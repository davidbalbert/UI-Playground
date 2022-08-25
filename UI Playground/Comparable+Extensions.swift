//
//  Comparable+Extensions.swift
//  UI Playground
//
//  Created by David Albert on 8/24/22.
//

import Foundation

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(range.upperBound, max(range.lowerBound, self))
    }
}
