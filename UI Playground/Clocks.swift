//
//  Clock.swift
//  UI Playground
//
//  Created by David Albert on 8/23/22.
//

import SwiftUI

struct Hand {
    var size: CGSize
    var anchor: CGFloat // [0.0, 1.0], 0.5 is the center.

    init(width: CGFloat, height: CGFloat, anchor: CGFloat) {
        size = CGSize(width: width, height: height)
        self.anchor = anchor
    }

    var offset: CGFloat {
        size.height * (anchor - 0.5)
    }
}

struct Tick: Identifiable {
    var clockDiameter: Double
    var minute: Int

    var id: Int {
        minute
    }

    var isMajor: Bool {
        minute % 5 == 0
    }

    var size: CGSize {
        if isMajor {
            return CGSize(width: clockDiameter * 0.04, height: clockDiameter * 0.11)
        } else {
            return CGSize(width: clockDiameter * 0.01, height: clockDiameter * 0.03)
        }
    }

    var angle: Angle {
        .degrees(Double(minute)*6)
    }

    var offset: CGFloat {
        -(clockDiameter/2 - size.height/2) + clockDiameter * 0.015
    }
}

struct ClockMetrics {
    var diameter: Double

    init(size: CGSize) {
        diameter = min(size.width, size.height)
    }

    var hourHand: Hand {
        Hand(width: diameter * 0.05, height: diameter * 0.4, anchor: 0.3)
    }

    var minuteHand: Hand {
        Hand(width: diameter * 0.04, height: diameter * 0.55, anchor: 0.22)
    }

    var secondHand: Hand {
        Hand(width: diameter * 0.012, height: diameter * 0.45, anchor: 0.3)
    }

    var secondHandCircleSize: CGSize {
        CGSize(width: diameter * 0.085, height: diameter * 0.085)
    }

    var redMidDotSize: CGSize {
        CGSize(width: diameter * 0.03, height: diameter * 0.03)
    }

    var whiteMidDotSize: CGSize {
        CGSize(width: diameter * 0.005, height: diameter * 0.005)
    }

    var ticks: [Tick] {
        (0..<60).map { minute in
            Tick(clockDiameter: diameter, minute: minute)
        }
    }
}

func hmm() {
    let midnight = Calendar.current.startOfDay(for: .now)
    print(Date.now.timeIntervalSince(midnight))
}

fileprivate extension View {
    func frame(_ size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
}

struct Clock: View {
    var midnight = Calendar.current.startOfDay(for: .now)

    func radius(for size: CGSize) -> Double {
        return min(size.width, size.height)
    }

    func hourHandRotation(_ date: Date) -> Angle {
        return .degrees(360 * round(date.timeIntervalSince(midnight))/(60*60*12))
    }

    func minuteHandRotation(_ date: Date) -> Angle {
        return .degrees(360 * round(date.timeIntervalSince(midnight))/(60*60))
    }

    func secondHandRotation(_ date: Date) -> Angle {
        return .degrees(360 * round(date.timeIntervalSince(midnight))/60)
    }

    var body: some View {
        GeometryReader { proxy in
            let metrics = ClockMetrics(size: proxy.size)

            TimelineView(.periodic(from: .now, by: 1)) { context in
                Circle()
                    .fill(.white)
                    .overlay {
                        ForEach(metrics.ticks) { tick in
                            SmoothRectangle()
                                .fill(.black)
                                .frame(tick.size)
                                .offset(y: tick.offset)
                                .rotationEffect(tick.angle)
                        }

                        SmoothRectangle()
                            .fill(.black)
                            .frame(metrics.hourHand.size)
                            .offset(y: metrics.hourHand.offset)
                            .rotationEffect(hourHandRotation(context.date))

                        SmoothRectangle()
                            .fill(.black)
                            .frame(metrics.minuteHand.size)
                            .offset(y: metrics.minuteHand.offset)
                            .rotationEffect(minuteHandRotation(context.date))

                        ZStack {
                            SmoothRectangle()
                                .fill(.red)
                                .frame(metrics.secondHand.size)

                            Circle()
                                .fill(.red)
                                .frame(metrics.secondHandCircleSize)
                                .offset(y: -metrics.secondHand.size.height/2)
                        }
                        .offset(y: metrics.secondHand.offset)
                        .rotationEffect(secondHandRotation(context.date))

                        Circle()
                            .fill(.red)
                            .frame(metrics.redMidDotSize)

                        Circle()
                            .fill(.white)
                            .frame(metrics.whiteMidDotSize)
                    }
                    .animation(.spring(response: 0.1, dampingFraction: 0.35), value: context.date.timeIntervalSince(midnight) as TimeInterval)

            }
        }
        .padding()
        .eraseToAnyView()
    }
}

struct Clocks: View {
    var body: some View {
        Clock()
            .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct Clock_Previews: PreviewProvider {
    static var previews: some View {
        Clocks()
    }
}
