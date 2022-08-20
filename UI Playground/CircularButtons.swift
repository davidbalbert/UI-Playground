//
//  CircularButtons.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct CircularButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Circle()
                    .foregroundColor(.blue)
            }
    }
}

struct CircularButtons: View {
    var body: some View {
        VStack {
            Button("A very long title") { print("foo") }
            Button("Short") { print("bar") }
            Button("A") { print("baz") }
        }
        .buttonStyle(CircularButtonStyle())
//        .debug()
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct CircularButtons_Previews: PreviewProvider {
    static var previews: some View {
        CircularButtons()
    }
}
