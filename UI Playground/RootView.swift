//
//  ContentView.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Layout") {
                    NavigationLink("Frames", destination: Frames())
                    NavigationLink("Paths", destination: Paths())
                    NavigationLink("Shapes", destination: Shapes())
                    NavigationLink("Images", destination: Images())
                    NavigationLink("Text", destination: Texts())
                    NavigationLink("Flexible Frames", destination: FlexibleFrames())
                    NavigationLink("Matched Geometry Effect", destination: MatchedGeometry())
                    NavigationLink("Clipping and Masking", destination: ClippingAndMasking())
                }

                Section("Experiments") {
                    NavigationLink("Circular Buttons", destination: CircularButtons())
                    NavigationLink("Photo Grid", destination: PhotoGrid())
                }
            }
            .listStyle(.sidebar)
            .listItemTint(.monochrome)

        }
        .toolbar {
            Text(" ")
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
