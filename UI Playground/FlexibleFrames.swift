//
//  FlexibleFrames.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct FlexibleFrames: View {
    @State var shouldMeasure = false

    var body: some View {
        VStack {
            VStack(spacing: 50) {
                VStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .measured(shouldMeasure)
                        .fixedSize()
                    Text(".fixedSize()")
                        .font(.monospaced(.body)())
                }


                VStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .measured(shouldMeasure)
                        .frame(idealWidth: 50, idealHeight: 50)
                        .fixedSize()
                    Text(".frame(idealWidth: 50, idealHeight: 50)\n.fixedSize()")
                        .font(.monospaced(.body)())
                }

                VStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .measured(shouldMeasure)
                        .frame(minWidth: 10, maxWidth: 100, minHeight: 10, maxHeight: 100)
                    Text(".frame(minWidth: 10, maxWidth: 100, minHeight: 10, maxHeight: 100)")
                        .font(.monospaced(.body)())

                }
            }
            .padding()

            Spacer()

            Toggle("Measure", isOn: $shouldMeasure)
                .padding()
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct FlexibleFrames_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleFrames()
    }
}
