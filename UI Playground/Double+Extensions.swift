//
//  Double+Extensions.swift
//  UI Playground
//
//  Created by David Albert on 10/9/22.
//

import Foundation

extension Double {
    var isApproximatelyZero: Bool {
        abs(self) < 1e-10
    }
}
