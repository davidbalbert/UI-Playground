//
//  OnSizeChange.swift
//  UI Playground
//
//  Created by David Albert on 9/29/22.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize? = nil

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

extension View {
    func onSizeChange(perform: @escaping (CGSize?) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: proxy.size)
            }
        }
        .onPreferenceChange(SizeKey.self, perform: perform)
    }
}
