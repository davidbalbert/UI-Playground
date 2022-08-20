//
//  LayoutPlayground.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct Frames: View {
    var body: some View {
        MeasureBehavior {
            Text("Hello, world!")
        }
        .navigationTitle("Frames")
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct LayoutPlayground_Previews: PreviewProvider {
    static var previews: some View {
        Frames()
    }
}
