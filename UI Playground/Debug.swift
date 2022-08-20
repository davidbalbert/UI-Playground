//
//  Debug.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

extension View {
    func debug() -> some View {
        print(self)
        return self
    }

    @ViewBuilder
    func measured(_ shouldMeasure: Bool = true) -> some View {
        if shouldMeasure {
            overlay(GeometryReader { proxy in
                Text("\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
                    .foregroundColor(.white)
                    .background(.black)
                    .font(.footnote)
                    .fixedSize()
            })
        } else {
            self
        }
    }
}
