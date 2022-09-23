//
//  ButtonStyleExperiments.swift
//  UI Playground
//
//  Created by David Albert on 9/23/22.
//

import SwiftUI

struct DebugButtonStyle<Wrapped: PrimitiveButtonStyle>: PrimitiveButtonStyle {
    var wrapped: Wrapped

    func makeBody(configuration: Configuration) -> some View {
        let body = wrapped.makeBody(configuration: configuration)
        dump(body)
        return body
    }
}

struct ButtonStyleExperiments: View {
    var body: some View {
        Button("Hello, World!") {}
            .buttonStyle(DebugButtonStyle(wrapped: .bordered))
            .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct ButtonStyleExperiments_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleExperiments()
    }
}
