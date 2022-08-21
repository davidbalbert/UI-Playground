//
//  Measured.swift
//  UI Playground
//
//  Created by David Albert on 8/21/22.
//

import SwiftUI

struct Measured: ViewModifier {
    var shouldMeasure: Bool
    var alignment: Alignment
    @State var hovering: Bool = false

    @ViewBuilder
    func body(content: Content) -> some View {
        if shouldMeasure {
            content
            .overlay {
                GeometryReader { proxy in
                    Text("\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
                        .foregroundColor(.white)
                        .background(.black)
                        .font(.footnote)
                        .fixedSize()
                        .opacity(hovering ? 0.4 : 1.0)
                        .onHover { action in
                            hovering = action
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                }
            }
        } else {
            content
        }
    }
}

extension View {
    func measured(_ shouldMeasure: Bool = true, alignment: Alignment = .topLeading) -> some View {
        modifier(Measured(shouldMeasure: shouldMeasure, alignment: alignment))
    }
}
