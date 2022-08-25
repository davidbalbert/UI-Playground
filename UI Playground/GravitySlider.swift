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

    init(value: Binding<Double>, in bounds: ClosedRange<Double>) {
        _value = value
        self.bounds = bounds
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
        }
        .frame(height: knobDiameter)

    }
}

struct GravitySlider: View {
    @State var value: Double = 50

    var body: some View {
        VStack {
            Slider(value: $value, in: 0...100)
            TiltableSlider(value: $value, in: 0...100)
        }
        .frame(width: 300)
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
