//
//  ClippingAndMasking.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct ClippingAndMasking: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.red)
                .rotationEffect(.degrees(45))
                .frame(width: 100, height: 100)
                .clipped()

            Text("STOP")
                .font(.system(size: 35, weight: .bold, design: .default))
                .foregroundColor(.white)
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct ClippingAndMasking_Previews: PreviewProvider {
    static var previews: some View {
        ClippingAndMasking()
    }
}
