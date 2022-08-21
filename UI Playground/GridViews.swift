//
//  GridViews.swift
//  UI Playground
//
//  Created by David Albert on 8/21/22.
//

import SwiftUI

struct GridViews: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    Text("Adaptive")
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                        // `id: \.self` so that we can change the range and have hot-reloading work. It's otherwise unnecessary.
                        ForEach(0..<10, id: \.self) { i in
                            Rectangle()
                                .fill(.blue)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }

                VStack(alignment: .leading) {
                    Text("Flexible")
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 100)),
                        GridItem(.flexible(minimum: 180)),
                    ]) {
                        ForEach(0..<10, id: \.self) { i in
                            Rectangle()
                                .fill(.red)
                                .measured(alignment: .topTrailing)
                                .frame(height: 50)

                        }
                    }
                    .frame(width: 300)
                    .border(.black)
                }

                VStack(alignment: .leading) {
                    Text("Combined")
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 100)),
                        GridItem(.adaptive(minimum: 40)),
                        GridItem(.flexible(minimum: 180)),
                    ]) {
                        ForEach(0..<10, id: \.self) { i in
                            Rectangle()
                                .fill(.green)
                                .measured(alignment: .topTrailing)
                                .frame(height: 50)
                        }
                    }
                    .frame(width: 300)
                    .border(.black)
                }
            }
        }
        .font(.title)
        .padding()
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct GridViews_Previews: PreviewProvider {
    static var previews: some View {
        GridViews()
    }
}
