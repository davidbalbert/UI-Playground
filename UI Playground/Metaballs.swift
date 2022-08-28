//
//  Metaballs.swift
//  UI Playground
//
//  Created by David Albert on 8/27/22.
//

import SwiftUI

struct Metaballs: View {
    @State var radius: Double = 50
    @State var distance: Double = 100
    @State var shouldThreshold: Bool = true
    @State var threshold: Double = 0.5
    @State var blurRadius: Double = 20

    var diameter: Double {
        2*radius
    }

    func frame(in size: CGSize) -> CGRect {
        let frameSize = CGSize(width: distance+2*radius, height: diameter)
        let frameOrigin = CGPoint(x: size.width/2 - frameSize.width/2, y: size.height/2 - frameSize.height/2)

        return CGRect(origin: frameOrigin, size: frameSize)
    }

    var body: some View {
        VStack {
            Canvas { ctx, size in
                let frame = frame(in: size)

                if shouldThreshold {
                    ctx.addFilter(.alphaThreshold(min: threshold))
                }
                ctx.addFilter(.blur(radius: blurRadius))

                ctx.drawLayer { ctx in
                    let r1 = CGRect(origin: frame.origin, size: CGSize(width: diameter, height: diameter))
                    let r2 = CGRect(origin: CGPoint(x: frame.maxX - diameter, y: frame.minY), size: CGSize(width: diameter, height: diameter))


                    ctx.fill(Circle().path(in: r1), with: .color(.black))
                    ctx.fill(Circle().path(in: r2), with: .color(.black))
                }
            }
            .border(.red)

            Form {
                Slider(value: $radius, in: 0...100) {
                    Text("Radius")
                }

                Slider(value: $distance, in: 0...500) {
                    Text("Distance")
                }

                Slider(value: $blurRadius, in: 0...100) {
                    Text("Blur Radius")
                }

                Toggle("Should Threshold", isOn: $shouldThreshold)

                Slider(value: $threshold, in: 0...0.9999999) {
                    Text("Threshold")
                }
                .disabled(!shouldThreshold)
            }
            .frame(width: 300)
            .padding()
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Metaballs_Previews: PreviewProvider {
    static var previews: some View {
        Metaballs()
    }
}
