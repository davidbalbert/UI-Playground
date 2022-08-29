//
//  IconMorph.swift
//  UI Playground
//
//  Created by David Albert on 8/27/22.
//

import SwiftUI

struct MorphingImage: View {
    var systemName: String
    var duration: TimeInterval = 1

    @State var previousSystemName: String?
    @State var startedAt: Date?

    func progress(at date: Date) -> Double {
        guard let startedAt = startedAt else {
            return 1.0
        }

        return min(1.0, date.timeIntervalSince(startedAt) / duration)
    }

    func blur(progress: Double) -> Double {
        precondition((0...1).contains(progress))

        if progress < 0.25 {
            let duration = 0.25*duration

            return 5 * progress/duration
        } else if progress < 0.5625 {
            return 5
        } else {
            let duration = 0.25*duration
            let progress = progress - 0.5625
            let percent = min(1, progress/duration)

            return 5 * (1-percent)
        }
    }

    func alphaOld(progress: Double) -> Double {
        precondition((0...1).contains(progress))

        if progress < 0.1875 {
            return 1.0
        } else {
            let duration = 0.5*duration
            let progress = progress - 0.1875
            let percent = min(1, progress/duration)

            print(1 - percent)

            return 1 - percent
        }
    }

    func alphaNew(progress: Double) -> Double {
        precondition((0...1).contains(progress))

        if progress < 0.1875 {
            return 0
        } else {
            let duration = 0.5*duration
            let progress = progress - 0.1875
            let percent = min(1, progress/duration)

            return percent
        }
    }

    var body: some View {
        TimelineView(.animation(paused: startedAt == nil)) { context in
            let progress = progress(at: context.date)

            Canvas { ctx, size in
                ctx.addFilter(.alphaThreshold(min: 0.5))

                ctx.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: blur(progress: progress)))

                    if let oldImage = ctx.resolveSymbol(id: 0) {
                        ctx.opacity = alphaOld(progress: progress)
                        ctx.drawLayer { ctx in
                            ctx.draw(oldImage, at: CGPoint(x: size.width/2, y: size.height/2))
                        }
                    }

                    let newImage = ctx.resolveSymbol(id: 1)!
                    ctx.opacity = alphaNew(progress: progress)
                    ctx.drawLayer { ctx in
                        ctx.draw(newImage, at: CGPoint(x: size.width/2, y: size.height/2))
                    }
                }
            } symbols: {
                if let previousSystemName = previousSystemName {
                    Image(systemName: previousSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(0)
                }

                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .tag(1)
            }
            .onChange(of: context.date as Date) { date in
                if date.timeIntervalSince(startedAt ?? Date.distantPast) > duration {
                    previousSystemName = nil
                    startedAt = nil
                }
            }
        }
        .onChange(of: systemName) { [systemName] newSystemName in
            previousSystemName = systemName
            startedAt = .now
        }
        .eraseToAnyView()
    }
}

struct IconMorph: View {
    var imageNames: [String] = [
        "circle.fill",
        "heart.fill",
        "star.fill",
        "bell.fill",
        "bookmark.fill",
        "tag.fill",
        "bolt.fill",

        "play.fill",
        "pause.fill",
        "squareshape.fill",
        "key.fill",
        "hexagon.fill",
        "gearshape.fill",
        "car.fill",
    ]

    @State var imageName = "circle.fill"

    var body: some View {
        VStack(spacing: 60) {
            MorphingImage(systemName: imageName)
                .frame(width: 100, height: 100)

            HStack {
                ForEach(imageNames, id: \.self) { name in
                    Button {
                        imageName = name
                    } label: {
                        Image(systemName: name)
                    }
                }
            }
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct IconMorph_Previews: PreviewProvider {
    static var previews: some View {
        IconMorph()
    }
}
