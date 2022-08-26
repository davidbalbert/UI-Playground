//
//  GravitySlider.swift
//  UI Playground
//
//  Created by David Albert on 8/25/22.
//

import SwiftUI

// Slider seems to have trouble with orientations other than exactly vertical or exactly horizontal
struct TiltableSlider: View {
    @Binding var value: Double
    @State var dragging: Bool = false

    var bounds: ClosedRange<Double>
    var onEditingChanged: (Bool) -> Void

    init(value: Binding<Double>, in bounds: ClosedRange<Double>, onEditingChanged: @escaping (Bool) -> Void) {
        _value = value
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
    }

    var backgroundColor: Color {
        let nsColor = #colorLiteral(red: 0.88449651, green: 0.8944464326, blue: 0.9200631976, alpha: 1)
        return Color(nsColor)
    }

    var shadowColor: Color {
        Color(red: 0.81, green: 0.81, blue: 0.81, opacity: 1.0)
    }

    var controlAccentColor: Color {
        Color(NSColor.controlAccentColor)
    }

    var knobColor: Color {
        .white
    }

    var knobPressedColor: Color {
        Color(white: 0.95)
    }

    var knobDiameter: Double {
        20
    }

    var barHeight: Double {
        4
    }

    var percent: Double {
        let clamped = value.clamped(to: bounds)

        return (clamped-bounds.lowerBound)/(bounds.upperBound-bounds.lowerBound)
    }

    func knobOffset(for viewWidth: Double) -> Double {
        let trackWidth = viewWidth-knobDiameter

        return percent*trackWidth - trackWidth/2
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Capsule()
                    .fill(backgroundColor)
                    .frame(height: barHeight)
                    .overlay {
                            Capsule()
                                .inset(by: -1)
                                .stroke(.black, lineWidth: 2)
                                .shadow(color: shadowColor, radius: 0.65)
                                .padding([.leading, .trailing], -1)
                                .clipShape(Capsule())
                    }

                Capsule()
                    .fill(controlAccentColor)
                    .frame(width: percent*proxy.size.width, height: barHeight)
                    .offset(x: percent*proxy.size.width/2 - proxy.size.width/2)

                Circle()
                    .fill(dragging ? knobPressedColor : knobColor)
                    .frame(width: knobDiameter)
                    .shadow(radius: 0.5, y: 0)
                    .background {
                        Circle()
                            .inset(by: 1)
                            .shadow(radius: 0.75, y: 1.75)
                    }
                    .offset(x: knobOffset(for: proxy.size.width))
            }
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let percent = (value.location.x / proxy.size.width).clamped(to: 0...1.0)
                        self.value = percent*(bounds.upperBound-bounds.lowerBound) + bounds.lowerBound
                        dragging = true
                    }
                    .onEnded { value in
                        dragging = false
                    }
            )
            .onChange(of: dragging) { newDragging in
                onEditingChanged(newDragging)
            }
        }
        .frame(height: knobDiameter)

    }
}

struct GravitySlider: View {
    @State var value: Double = 50
    @State var angle: Angle = .zero
    @State var angleBeforeDrag: Angle? = nil
    @State var dragging: Bool = false
    @State var velocity: Double = 0
    @State var lastTick: Date?

    var bounds: ClosedRange<Double> = 0...100

    var sliderWidth: Double {
        400
    }

    func radians(_ point: CGPoint) -> Double {
        atan2(point.y, point.x)
    }

    var animationPaused: Bool {
        if dragging || angle.degrees == 0 || angle.degrees == 180 {
            return true
        } else if (0...180).contains(angle.degrees) {
            return value == bounds.upperBound && abs(velocity) < 0.03
        } else {
            return value == bounds.lowerBound && abs(velocity) < 0.03
        }
    }

    func update(_ dt: TimeInterval) {
        let g = 9.81 // m/2^2
        let acceleration = g*sin(angle.radians)
        velocity += acceleration*dt

        let oldPosition = 1.5 * (value - bounds.lowerBound)/(bounds.upperBound - bounds.lowerBound)
        let newPosition = oldPosition + velocity*dt
        value = ((newPosition/1.5 * (bounds.upperBound - bounds.lowerBound)) + bounds.lowerBound).clamped(to: bounds)

        if value == bounds.upperBound && velocity > 0 {
            velocity = -0.15 * velocity
        } else if value == bounds.lowerBound && velocity < 0 {
            velocity = -0.15 * velocity
        }
    }

    var body: some View {
        TimelineView(.animation(paused: animationPaused)) { context in
            VStack {
                GeometryReader { proxy in
                    TiltableSlider(value: $value, in: bounds) { editing in
                        dragging = editing

                        if !editing {
                            velocity = 0
                        }
                    }
                    .frame(width: sliderWidth)
                    .rotationEffect(angle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let frame = proxy.frame(in: .local)
                                let center = CGPoint(x: frame.midX, y: frame.midY)

                                angleBeforeDrag = angleBeforeDrag ?? angle

                                let startRadians = angleBeforeDrag!.radians
                                let offsetRadians = radians(value.location - center) - radians(value.startLocation - center)

                                let tau = 2.0 * .pi
                                let radians = (tau + startRadians + offsetRadians).truncatingRemainder(dividingBy: tau)

                                angle = .radians(radians)
                            }
                            .onEnded { value in
                                angleBeforeDrag = nil
                            }
                    )
                }
                .onChange(of: animationPaused) { newAnimatingPaused in
                    if newAnimatingPaused {
                        lastTick = nil
                    }
                }
                .onChange(of: context.date as Date) { newDate in
                    guard let lastTick = lastTick else {
                        lastTick = newDate
                        return
                    }

                    let dt = newDate.timeIntervalSince(lastTick)
                    update(dt)
                    self.lastTick = newDate
                }


                Button("Reset") {
                    angle = .degrees(0)
                    value = 50
                    velocity = 0
                }
                .padding()
            }
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct GravitySlider_Previews: PreviewProvider {
    static var previews: some View {
        GravitySlider()
    }
}
