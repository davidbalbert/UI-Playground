//
//  Texts.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct Texts: View {
    var body: some View {
        Text("Hello,\nto the world!")
            .minimumScaleFactor(0.5)
            .lineLimit(3)
            .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Texts_Previews: PreviewProvider {
    static var previews: some View {
        Texts()
    }
}
