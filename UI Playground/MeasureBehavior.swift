//
//  LayoutPlayground.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct MeasureBehavior<Content: View>: View {
    @State var width: CGFloat = 100
    @State var height: CGFloat = 100

    var content: Content

    init(content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .border(.gray)
                .frame(width: width, height: height)
                .border(.black)
                .padding(.top, 40)

            Spacer()

            Form {
                Slider(value: $width, in: 0...500) {
                    Text("Width")
                }

                Slider(value: $height, in: 0...200) {
                    Text("Height")
                }
            }
            .padding()
            .frame(maxWidth: 400)
            .padding(.bottom, 40)
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct MeasureBehavior_Previews: PreviewProvider {
    static var previews: some View {
        MeasureBehavior {
            Text("hello")
        }
    }
}
