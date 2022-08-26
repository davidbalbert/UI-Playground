//
//  BezierCurves.swift
//  UI Playground
//
//  Created by David Albert on 8/26/22.
//

import SwiftUI

struct PointEditor: View {
    @Binding var point: CGPoint

    var body: some View {
        Circle()
            .fill(.white)
            .overlay {
                Circle()
                    .strokeBorder(.black, lineWidth: 1)
            }
            .frame(width: 7, height: 7)
            .position(x: point.x, y: point.y)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                    .onChanged { value in
                        point = value.location
                    }
            )
    }
}

struct CurveView: View {
    @Binding var curve: BezierCurve

    var body: some View {
        ZStack {
            Path { p in
                p.move(to: curve.p1)
                p.addCurve(to: curve.p2, control1: curve.cp1, control2: curve.cp2)
            }
            .strokedPath(StrokeStyle(lineWidth: 2))

            Path { p in
                p.move(to: curve.p1)
                p.addLine(to: curve.cp1)
            }
            .strokedPath(StrokeStyle(lineWidth: 1))
            .fill(.blue)

            Path { p in
                p.move(to: curve.p2)
                p.addLine(to: curve.cp2)
            }
            .strokedPath(StrokeStyle(lineWidth: 1))
            .fill(.blue)

            PointEditor(point: $curve.p1)
            PointEditor(point: $curve.p2)

            PointEditor(point: $curve.cp1)
            PointEditor(point: $curve.cp2)
        }
    }
}

struct BezierCurveEditor: View {
    @State var curve: BezierCurve = BezierCurve(
        p1: CGPoint(x: 225, y: 175),
        p2: CGPoint(x: 675, y: 525),
        cp1: CGPoint(x: 675, y: 175),
        cp2: CGPoint(x: 225, y: 525)
    )

    var body: some View {
        ZStack {
            CurveView(curve: $curve)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .coordinateSpace(name: "canvas")
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct BezierCurves_Previews: PreviewProvider {
    static var previews: some View {
        BezierCurveEditor()
    }
}
