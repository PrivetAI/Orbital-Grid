import SwiftUI

struct OrbitalGridLoadingScreen: View {
    @State private var spin: Double = 0
    @State private var pulse: Bool = false
    @State private var animationStarted = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [OrbitalGridPalette.ivory, OrbitalGridPalette.panel],
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .stroke(OrbitalGridPalette.teal.opacity(0.18), lineWidth: 6)
                        .frame(width: 144, height: 144)
                    HexShape()
                        .stroke(OrbitalGridPalette.teal, lineWidth: 3.5)
                        .frame(width: 102, height: 102)
                        .rotationEffect(.degrees(spin))
                    HexShape()
                        .stroke(OrbitalGridPalette.magenta.opacity(0.5), lineWidth: 2.5)
                        .frame(width: 78, height: 78)
                        .rotationEffect(.degrees(-spin))
                    Circle()
                        .fill(OrbitalGridPalette.ember)
                        .frame(width: pulse ? 22 : 16, height: pulse ? 22 : 16)
                }

                Text("Orbital Grid")
                    .font(OrbitalGridTypography.title(22))
                    .foregroundColor(OrbitalGridPalette.indigo)

                Text("Aligning the station log...")
                    .font(OrbitalGridTypography.body(13))
                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.75))
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            guard !animationStarted else { return }
            animationStarted = true
            withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                spin = 360
            }
            withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
