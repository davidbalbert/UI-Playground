//
//  ContentView.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct ContentView: View {
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif

    var body: some View {
        Text("Hello, world!")
            .padding()
            .eraseToAnyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
