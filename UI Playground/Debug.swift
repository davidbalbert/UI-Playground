//
//  Debug.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

extension View {
    func debug() -> some View {
        dump(self)
        return self
    }
}
