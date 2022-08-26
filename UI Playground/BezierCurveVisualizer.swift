//
//  BezierCurveVisualizer.swift
//  UI Playground
//
//  Created by David Albert on 8/26/22.
//

import SwiftUI

struct Line: Shape {
    var start, end: CGPoint

    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get {
            AnimatablePair(start.animatableData, end.animatableData)
        }
        set {
            (start.animatableData, end.animatableData ) = (newValue.first, newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}

struct PointView: View, Animatable {
    var point: CGPoint
    var radius: Double

    var body: some View {
        Circle()
            .fill(.black)
            .frame(width: 2*radius, height: 2*radius)
            .position(x: point.x, y: point.y)
    }

    var animatableData: CGPoint.AnimatableData {
        get {
            point.animatableData
        }
        set {
            point.animatableData = newValue
        }
    }
}

struct PointOnPath: View, Animatable {
    var start: CGPoint
    var path: Path
    var radius: Double
    var progress: Double // [0.0, 1.0]

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Circle()
            .fill(.black)
            .frame(width: 2*radius, height: 2*radius)
            .position(path.trimmedPath(from: 0, to: progress).currentPoint ?? start)
    }
}

struct LineBetweenPaths: View, Animatable {
    var path1: Path
    var path2: Path
    var initialStart: CGPoint
    var initialEnd: CGPoint
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        ZStack {
            Line(
                start: path1.trimmedPath(from: 0, to: progress).currentPoint ?? initialStart,
                end: path2.trimmedPath(from: 0, to: progress).currentPoint ?? initialEnd
            )
            .stroke(Color(NSColor.lightGray), lineWidth: 2)
        }
    }
}

struct AnimatedPath: Shape {
    var path: Path
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        path.trimmedPath(from: 0, to: progress)
    }
}

struct BezierCurveVisualizer: View {
    var curve: BezierCurve = BezierCurve(
        p1: CGPoint(x: 225, y: 175),
        p2: CGPoint(x: 675, y: 525),
        cp1: CGPoint(x: 675, y: 175),
        cp2: CGPoint(x: 225, y: 525)
    )

    @State var stopped = true
    @State var step = 0

    func quadraticBezier(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> Path {
        Path { p in
            p.move(to: p1)
            p.addQuadCurve(to: p3, control: p2)
        }
    }

    var firstQuad: Path {
        quadraticBezier(curve.p1, curve.cp1, curve.cp2)
    }

    var secondQuad: Path {
        quadraticBezier(curve.cp1, curve.cp2, curve.p2)
    }

    var quadColor: Color {
        Color(NSColor.blue.highlight(withLevel: 0.5)!)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Group {
                    Line(
                        start: stopped ? curve.p1 : curve.cp1,
                        end: stopped ? curve.cp1 : curve.cp2
                    )
                    .stroke(Color(NSColor.lightGray), lineWidth: 2)

                    Line(
                        start: stopped ? curve.cp1 : curve.cp2,
                        end: stopped ? curve.cp2 : curve.p2
                    )
                    .stroke(Color(NSColor.lightGray), lineWidth: 2)
                }
                .opacity(step >= 2 ? 1 : 0)

                Group {
                    firstQuad
                        .stroke(quadColor, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))

                    secondQuad
                        .stroke(quadColor, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                }
                .opacity(step >= 4 ? 1 : 0)

                Group {
                    AnimatedPath(path: curve.path, progress: stopped ? 0 : 1)
                        .stroke(.blue, lineWidth: 4)
                }
                .opacity(step >= 7 ? 1 : 0)

                Group {
                    Path { p in
                        p.addLines([curve.p1, curve.cp1, curve.cp2, curve.p2])
                    }
                    .stroke(Color(NSColor.lightGray), lineWidth: 2)

                    PointView(point: curve.p1, radius: 4)
                    PointView(point: curve.cp1, radius: 4)
                    PointView(point: curve.cp2, radius: 4)
                    PointView(point: curve.p2, radius: 4)
                }
                .opacity(step >= 0 ? 1 : 0)

                Group {
                    PointView(point: stopped ? curve.p1 : curve.cp1, radius: 3)
                    PointView(point: stopped ? curve.cp1 : curve.cp2, radius: 3)
                    PointView(point: stopped ? curve.cp2 : curve.p2, radius: 3)
                }
                .opacity(step >= 1 ? 1 : 0)


                Group {
                    PointOnPath(
                        start: (curve.p1 - curve.cp1)/2,
                        path: firstQuad,
                        radius: 3,
                        progress: stopped ? 0 : 1
                    )

                    PointOnPath(
                        start: (curve.cp1 - curve.cp2)/2,
                        path: secondQuad,
                        radius: 3,
                        progress: stopped ? 0 : 1
                    )
                }
                .opacity(step >= 3 ? 1 : 0)

                Group {
                    LineBetweenPaths(
                        path1: firstQuad,
                        path2: secondQuad,
                        initialStart: (curve.p1 - curve.cp1)/2,
                        initialEnd: (curve.cp1 - curve.cp2)/2,
                        progress: stopped ? 0 : 1
                    )
                }
                .opacity(step >= 5 ? 1 : 0)

                Group {
                    PointOnPath(
                        start: curve.p1,
                        path: curve.path,
                        radius: 3,
                        progress: stopped ? 0 : 1
                    )
                }
                .opacity(step >= 6 ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)

            HStack {
                Spacer()

                Button("Previous") {
                    step -= 1
                }
                .disabled(step <= 0)

                Button("Next") {
                    step += 1
                }
                .disabled(step >= 7)
            }
            .padding()
        }
        .animation(.default.speed(0.1).repeatForever(), value: stopped)
        .onAppear {
            stopped = false
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct BezierCurveVisualizer_Previews: PreviewProvider {
    static var previews: some View {
        BezierCurveVisualizer()
    }
}
