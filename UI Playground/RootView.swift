//
//  ContentView.swift
//  UI Playground
//
//  Created by David Albert on 8/15/22.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Layout") {
                    Group {
                        NavigationLink("Frames", destination: Frames())
                        NavigationLink("Paths", destination: Paths())
                        NavigationLink("Shapes", destination: Shapes())
                        NavigationLink("Images", destination: Images())
                        NavigationLink("Text", destination: Texts())
                        NavigationLink("Flexible Frames", destination: FlexibleFrames())
                        NavigationLink("Matched Geometry Effect", destination: MatchedGeometry())
                        NavigationLink("Clipping and Masking", destination: ClippingAndMasking())
                        NavigationLink("Stack Views", destination: StackViews())
                        NavigationLink("Alignment", destination: AlignmentGuides())
                    }

                    Group {
                        NavigationLink("Grid Views", destination: GridViews())
                    }
                }

                Section("Experiments") {
                    NavigationLink("Circular Buttons", destination: CircularButtons())
                    NavigationLink("Photo Grid", destination: PhotoGrid())
                    NavigationLink("Tables", destination: Tables())
                    NavigationLink("Button Style", destination: ButtonStyleExperiments())
                }

                Section("Sketches") {
                    Group {
                        NavigationLink("Loading Indicator", destination: LoadingIndicator())
                        NavigationLink("Fabric", destination: FabricEffect())
                        NavigationLink("Clock", destination: Clocks())
                        NavigationLink("Seven Segment Display", destination: SevenSegment())
                        NavigationLink("Card Punchout", destination: CardPunchout())
                        NavigationLink("Cover Flow", destination: CoverFlow())
                        NavigationLink("Pagination", destination: Pagination())
                        NavigationLink("Gravity Slider", destination: GravitySlider())
                        NavigationLink("Bezier Curve Editor", destination: BezierCurveEditor())
                        NavigationLink("Bezier Curve Visualizer", destination: BezierCurveVisualizer())
                    }

                    Group {
                        NavigationLink("Custom Knob Slider", destination: CustomKnobSliders())
                        NavigationLink("Metaballs", destination: Metaballs())
                        NavigationLink("Icon Morph", destination: IconMorph())
                        NavigationLink("Bouncing Ball Physics", destination: BouncingBall())
                    }
                }
            }
            .listStyle(.sidebar)
            .listItemTint(.monochrome)

        }
        .toolbar {
            Text(" ")
        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
