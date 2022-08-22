//
//  LoadingIndicator.swift
//  UI Playground
//
//  Created by David Albert on 8/22/22.
//

import SwiftUI


struct StoppedProgressView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.style = .spinning

        return progressIndicator
    }

    func updateNSView(_ progressIndicator: NSProgressIndicator, context: Context) {
    }
}

struct MyLoadingIndicator: View {
    var interval: Double {
        0.08
    }

    func degrees(for date: Date) -> Double {
        let tick = floor((date.timeIntervalSinceReferenceDate/interval)).remainder(dividingBy: 8)

        return 45*tick
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: interval)) { context in
            let rotation = degrees(for: context.date)

            Image(systemName: "rays")
                .foregroundStyle(.angularGradient(colors: [.black.opacity(0), .black.opacity(0.55)], center: .center, startAngle: .degrees(-80 + rotation), endAngle: .degrees(280 + rotation)))
                .font(.system(size: 26, weight: .bold, design: .default))
        }
    }
}

struct LoadingIndicator: View {
    var body: some View {
        HStack {
            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                Spacer()
                Text("System")
            }
            .frame(width: 80, height: 65)

            VStack {
                MyLoadingIndicator()
                Spacer()
                Text("Mine")
            }
            .frame(width: 80, height: 65)

        }
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
