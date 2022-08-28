//
//  CustomKnobSliders.swift
//  UI Playground
//
//  Created by David Albert on 8/27/22.
//

import SwiftUI

struct CustomKnobSlider: View {
    @Binding var value: Double
    @State var dragging: Bool = false
    var knobImage: Image


    var bounds: ClosedRange<Double>
    var onEditingChanged: ((Bool) -> Void)?

    init(value: Binding<Double>, in bounds: ClosedRange<Double>, knobImage: Image) {
        _value = value
        self.bounds = bounds
        self.onEditingChanged = nil
        self.knobImage = knobImage
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

    var barHeight: Double {
        4
    }

    var percent: Double {
        let clamped = value.clamped(to: bounds)

        return (clamped-bounds.lowerBound)/(bounds.upperBound-bounds.lowerBound)
    }

    func knobOffset(for viewWidth: Double) -> Double {
        return percent*viewWidth - viewWidth/2
    }

    func knobDiameter(scale: Double) -> Double {
        10 + 30*scale
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SmoothCapsule()
                    .fill(backgroundColor)
                    .frame(height: barHeight)
                    .overlay {
                        Capsule()
                                .inset(by: -2)
                                .strokeBorder(.black, lineWidth: 2)
                                .shadow(color: shadowColor, radius: 1.0)
                                .padding([.leading, .trailing], -1)
                                .clipShape(SmoothCapsule())
                    }

                SmoothCapsule()
                    .fill(controlAccentColor)
                    .frame(width: percent*proxy.size.width, height: barHeight)
                    .offset(x: percent*proxy.size.width/2 - proxy.size.width/2)

                knobImage
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(dragging ? knobPressedColor : knobColor)
                    .frame(width: knobDiameter(scale: percent))
                    .shadow(radius: 3, y: 0)
                    .shadow(radius: 3, y: 0)
                    .shadow(radius: 3, y: 0)
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
                onEditingChanged?(newDragging)
            }
        }
        .frame(height: knobDiameter(scale: 1.0))
    }
}


struct CustomKnobSliders: View {
    @State var value = 50.0
    @State var imageName: String = "paintbrush.fill"

    var imageNames: [String] = [
        "paintbrush.fill",
        "paintbrush.pointed.fill",
        "pencil",
        "scribble.variable",
    ]

    var body: some View {
        VStack {
            Picker("Knob", selection: $imageName) {
                ForEach(imageNames, id: \.self) { name in
                    Image(systemName: name).tag(name)
                }
            }
            .pickerStyle(.radioGroup)
            .horizontalRadioGroupLayout()

            CustomKnobSlider(value: $value, in: 0...100, knobImage: Image(systemName: imageName))

        }
        .frame(width: 400)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct CustomKnobSliders_Previews: PreviewProvider {
    static var previews: some View {
        CustomKnobSliders()
    }
}
