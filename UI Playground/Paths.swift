//
//  Paths.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct Paths: View {
    var body: some View {
        Path { p in
            p.addLines([
                CGPoint(x: 50, y: 0),
                CGPoint(x: 100, y: 75),
                CGPoint(x: 0, y: 75),
                CGPoint(x: 50, y: 0),
            ])
        }
        .navigationTitle("Paths")
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Paths_Previews: PreviewProvider {
    static var previews: some View {
        Paths()
    }
}
