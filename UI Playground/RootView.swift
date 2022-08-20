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
                    NavigationLink(destination: Frames()) { Text("Frames") }
                    NavigationLink(destination: Paths()) { Text("Paths") }
                    NavigationLink(destination: Shapes()) { Text("Shapes") }
                    NavigationLink(destination: Images()) { Text("Images") }
                    NavigationLink(destination: Texts()) { Text("Text") }
                    NavigationLink(destination: FlexibleFrames()) { Text("Flexible Frames") }
                    NavigationLink(destination: MatchedGeometry()) { Text("Matched Geometry Effect") }
                }

                Section("Experiments") {
                    NavigationLink(destination: CircularButtons()) { Text("Circular Buttons") }
                    NavigationLink(destination: PhotoGrid()) { Text("Photo Grid") }
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
