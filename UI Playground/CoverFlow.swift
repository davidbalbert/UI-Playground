//
//  CoverFlow.swift
//  UI Playground
//
//  Created by David Albert on 8/24/22.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CoverFlow: View {
    var colors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .indigo,
        .purple,
    ]

    var padding: CGFloat = 428

    @State var scrollOffset: CGFloat = 0

    var body: some View {
        GeometryReader { scrollProxy in
            let scrollFrame = scrollProxy.frame(in: .named("scrollView"))

            ScrollView(.horizontal) {
                ZStack {
                    GeometryReader { insideProxy in
                        let insideFrame = insideProxy.frame(in: .named("scrollView"))

                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: -insideFrame.minX)
                    }
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        scrollOffset = offset
                    }

                    HStack {
                        ForEach(0..<200, id: \.self) { idx in
                            let cardOffset = Int(scrollOffset/28)

                            GeometryReader { cardProxy in
                                let frame = cardProxy.frame(in: .named("scrollView"))
                                let factor = 16*(frame.midX - scrollFrame.midX)/scrollFrame.width
                                let clampedFactor: CGFloat = factor.clamped(to: -1.0...1.0)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(colors[idx % colors.count])
                                    .rotation3DEffect(.degrees(-45 * clampedFactor), axis: (x: 0, y: 1, z: 0))
                                    .offset(x: clampedFactor * 150)
                                    .frame(width: 100, height: 100)
                            }
                            .zIndex(Double(cardOffset >= idx ? idx-cardOffset : cardOffset-idx))
                            .frame(width: 20, height: 100)
                        }
                    }
                    .padding([.leading, .trailing], padding)
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .coordinateSpace(name: "scrollView")
        .background(.black)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct CoverFlow_Previews: PreviewProvider {
    static var previews: some View {
        CoverFlow()
    }
}
