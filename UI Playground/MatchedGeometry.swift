//
//  MatchedGeometry.swift
//  UI Playground
//
//  Created by David Albert on 8/20/22.
//

import SwiftUI

struct MatchedGeometry: View {
    @Namespace var ns

    var body: some View {
        HStack {
            Rectangle()
                .fill(.black)
                .frame(width: 100, height: 100)
                .matchedGeometryEffect(id: "ID", in: ns, isSource: true)

            Circle()
                .fill(.gray)
                .matchedGeometryEffect(id: "ID", in: ns, isSource: false)
                .border(Color.green)
        }
        .frame(width: 300, height: 100)
        .border(Color.black)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct MatchedGeometry_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometry()
    }
}
