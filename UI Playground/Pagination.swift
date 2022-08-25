//
//  Pagination.swift
//  UI Playground
//
//  Created by David Albert on 8/25/22.
//

import SwiftUI

struct Page: Identifiable {
    var id = UUID()
    var color: Color

    init(_ color: Color) {
        self.color = color
    }
}

struct Pagination: View {
    var pages: [Page] = [
        Page(.red),
        Page(.orange),
        Page(.yellow),
        Page(.green),
        Page(.blue),
        Page(.indigo),
        Page(.purple),
    ]

    var cardWidth: Double {
        225
    }

    var cardSpacing: Double {
        20
    }

    var overdraw: Double {
        2 * (cardSpacing + cardWidth*0.35)
    }

    @State var selection: Int = 0

    var offset: Double {
        let cardSpace = cardWidth + cardSpacing
        let width = cardSpace * Double(pages.count) - cardSpacing

        return -Double(selection)*cardSpace + width/2 - cardWidth/2 //- overdraw/2 - cardSpacing
    }


    var body: some View {
        VStack {
            HStack(spacing: cardSpacing) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { (idx, page) in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(page.color)
                        .aspectRatio(1/1.618, contentMode: .fit)
                        .frame(width: cardWidth)
                        .onTapGesture {
                            selection = idx
                        }
                }
            }
            .offset(x: offset)
            .frame(width: cardWidth + overdraw)
            .clipped()
            .contentShape(Rectangle())
            .overlay {
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .clear, location: 0.2),
                        .init(color: .clear, location: 0.8),
                        .init(color: .black, location: 1.0),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .allowsHitTesting(false)
            }


            HStack(spacing: 0) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { (idx, page) in
                    Circle()
                        .fill(.white)
                        .opacity(idx == selection ? 1.0 : 0.2)
                        .frame(width: 5, height: 5)
                        .frame(width: 13, height: 13)
                        .contentShape(Rectangle())
                        .frame(width: 13, height: 5)
                        .onTapGesture {
                            selection = idx
                        }
                }
            }
            .padding(EdgeInsets(top: 7, leading: 3, bottom: 7, trailing: 3))
            .background {
                Capsule()
                    .fill(.white)
                    .opacity(0.2)
            }
            .padding()
        }
        .animation(.default.speed(1.5), value: selection)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Pagination_Previews: PreviewProvider {
    static var previews: some View {
        Pagination()
    }
}
