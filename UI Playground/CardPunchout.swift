//
//  CardPunchout.swift
//  UI Playground
//
//  Created by David Albert on 8/24/22.
//

import SwiftUI

struct CardPunchout: View {
    var cornerRadius: CGFloat = 20.0

    @GestureState var dragLocation: CGPoint = .zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.angularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))
                .brightness(0.2)

            GeometryReader { proxy in
                let frame = proxy.frame(in: .local)

                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .inset(by: 2)
                        .fill(.black)

                    HStack {
                        Circle()
                            .fill(Color(hue: 0.58, saturation: 0.45, brightness: 0.3))
                            .frame(width: frame.width/8, height: frame.width/8)

                        VStack(alignment: .leading, spacing: 8) {
                            Capsule()
                                .fill(Color(hue: 0.58, saturation: 0.45, brightness: 0.3))
                                .frame(width: frame.width/3)

                            Capsule()
                                .fill(Color(hue: 0.58, saturation: 0.45, brightness: 0.3))
                                .frame(width: frame.width/5)
                        }
                        .frame(height: frame.width/8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(30)
                }
                .rotation3DEffect(.degrees(-6 * dragLocation.y/frame.midY), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(.degrees(6 * dragLocation.x/frame.midX), axis: (x: 1, y: 1, z: 0))
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .updating($dragLocation) { value, state, transaction in
                            state = CGPoint(
                                x: value.location.x - frame.width/2,
                                y: value.location.y - frame.height/2
                            )

                        }
                )
                .animation(.default.speed(3), value: dragLocation)
            }

        }
        .frame(width: 310, height: 195)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct CardPunchout_Previews: PreviewProvider {
    static var previews: some View {
        CardPunchout()
    }
}
