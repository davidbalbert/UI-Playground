//
//  ContentView.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Layout") {
                    NavigationLink(destination: Frames()) { Text("Frames") }
                    NavigationLink(destination: Paths()) { Text("Paths") }
                    NavigationLink(destination: Shapes()) { Text("Shapes") }
                    NavigationLink(destination: Images()) { Text("Images") }
                }

                Section("Experiments") {
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
        ContentView()
    }
}
