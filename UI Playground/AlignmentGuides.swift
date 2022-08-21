//
//  AlignmentGuides.swift
//  UI Playground
//
//  Created by David Albert on 8/21/22.
//

import SwiftUI

enum OneThirdID: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.height / 3
    }
}

enum TwoThirdsID: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.height * (2/3)
    }
}

extension VerticalAlignment {
    static let oneThird: VerticalAlignment = VerticalAlignment(OneThirdID.self)
    static let twoThirds: VerticalAlignment = VerticalAlignment(TwoThirdsID.self)
}

struct TextWithCustomBadge: View {
    var text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
            Text("Custom")
                .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                .font(.footnote)
                .foregroundColor(.white)
                .background {
                    Capsule()
                        .fill(.blue)
                }
        }
    }
}

enum VerticalAlignmentName: String {
    case top
    case oneThird
    case center
    case twoThirds
    case bottom

    var alignment: VerticalAlignment {
        switch self {
        case .top:       return .top
        case .oneThird:  return .oneThird
        case .center:    return .center
        case .twoThirds: return .twoThirds
        case .bottom:    return .bottom
        }
    }
}

struct AlignmentGuides: View {
    @State var alignmentName: VerticalAlignmentName = .center

    var body: some View {
        HStack(spacing: 20) {
            Picker("Alignment", selection: $alignmentName) {
                Text("Top").tag(VerticalAlignmentName.top)
                TextWithCustomBadge("One third").tag(VerticalAlignmentName.oneThird)
                Text("Center").tag(VerticalAlignmentName.center)
                TextWithCustomBadge("Two thirds").tag(VerticalAlignmentName.twoThirds)
                Text("Bottom").tag(VerticalAlignmentName.bottom)
            }
            .pickerStyle(.radioGroup)

            VStack {
                HStack(alignment: alignmentName.alignment) {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 75, height: 75)

                    Rectangle()
                        .fill(.green)
                        .frame(width: 40, height: 40)

                    Rectangle()
                        .fill(.red)
                        .frame(width: 55, height: 55)
                        .alignmentGuide(.top) { dim in
                            dim[.top] - 3
                        }
                        .alignmentGuide(.bottom) { dim in
                            dim[.bottom] + 3
                        }
                }
                .border(.black)

                Text("The red square is evil and won't touch the top or bottom.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 185, alignment: .leading) // Hack to keep the text narrower than the VStack above. Is there a better way to do this that doesn't rely on GeometryReader and State?
            }

        }
        .animation(.default.speed(2), value: alignmentName)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct AlignmentGuides_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentGuides()
    }
}
