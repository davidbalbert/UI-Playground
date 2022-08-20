//
//  Images.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct Images: View {
    var body: some View {
        let image = Image(systemName: "ellipsis")
        HStack {
            image
                .frame(width: 100, height: 100)
                .border(.red)

            image
                .resizable()
                .frame(width: 100, height: 100)
                .border(.red)

            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .border(.red)

        }.eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Images_Previews: PreviewProvider {
    static var previews: some View {
        Images()
    }
}
