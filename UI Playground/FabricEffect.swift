//
//  FabricEffect.swift
//  UI Playground
//
//  Created by David Albert on 8/22/22.
//

import SwiftUI

struct TrackingArea: NSViewRepresentable {
    var action: (CGPoint) -> Void

    class View: NSView {
        var action: (CGPoint) -> Void

        // The origin of a SwiftUI view is always in the upper left corner
        override var isFlipped: Bool {
            true
        }

        init(action: @escaping (CGPoint) -> Void) {
            self.action = action
            super.init(frame: .zero)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func mouseMoved(with event: NSEvent) {
            action(convert(event.locationInWindow, from: nil))
        }
    }

    func makeNSView(context: Context) -> View {
        let view = View(action: action)

        let trackingArea = NSTrackingArea(rect: .zero, options: [.mouseMoved, .inVisibleRect, .activeInKeyWindow], owner: view, userInfo: nil)
        view.addTrackingArea(trackingArea)

        return view
    }

    func updateNSView(_ nsView: View, context: Context) {
        nsView.action = action
    }
}

extension View {
    func onMouseMove(perform action: @escaping (CGPoint) -> Void) -> some View {
        background {
            TrackingArea(action: action)
        }
    }
}

struct FrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct Cell: View {
    var mouseLocation: CGPoint?
    var coordinateSpace: CoordinateSpace

    @State var frame: CGRect = .zero

    var distance: CGFloat? {
        guard let mouseLocation = mouseLocation else {
            return nil
        }

        let dx = frame.midX - mouseLocation.x
        let dy = frame.midY - mouseLocation.y

        return sqrt(pow(dx, 2) + pow(dy, 2))
    }

    var scaleFactor: CGFloat {
        guard let distance = distance else {
            return 1.0
        }

        return min(distance/150 + 0.2, 1.0)
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(.blue)
            .aspectRatio(1, contentMode: .fit)
            .scaleEffect(scaleFactor)
            .animation(.easeInOut, value: scaleFactor)
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: FrameKey.self, value: proxy.frame(in: coordinateSpace))
                }
            }
            .onPreferenceChange(FrameKey.self) { frame in
                self.frame = frame
            }
    }
}

struct FabricEffect: View {
    @State var mouseLocation: CGPoint?

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 12, maximum: 12), spacing: 2)], spacing: 2) {
                ForEach(0..<231, id: \.self) { idx in
                    Cell(mouseLocation: mouseLocation, coordinateSpace: .named("grid"))
                }
            }
        }
        .coordinateSpace(name: "grid")
        .onHover { hovering in
            if !hovering {
                mouseLocation = nil
            }
        }
        .onMouseMove { location in
            mouseLocation = location
        }
        .frame(width: 300)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct FabricEffect_Previews: PreviewProvider {
    static var previews: some View {
        FabricEffect()
    }
}
