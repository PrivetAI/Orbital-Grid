import SwiftUI

// MARK: - Orbital Grid: custom Shapes & glyphs
// All icons drawn with Shape / Canvas, no SF Symbols, no emoji.

// MARK: Hex / star polygons

struct HexShape: Shape {
    var pointyTop: Bool = true
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        for i in 0..<6 {
            let a = (Double(i) * 60.0 - (pointyTop ? 90.0 : 60.0)) * .pi / 180
            let pt = CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

struct ChevronUpShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY * 0.75))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.15))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.75))
        return p
    }
}

struct ArrowRightShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let midY = rect.midY
        p.move(to: CGPoint(x: rect.minX, y: midY))
        p.addLine(to: CGPoint(x: rect.maxX * 0.78, y: midY))
        p.move(to: CGPoint(x: rect.maxX * 0.55, y: rect.minY + rect.height * 0.18))
        p.addLine(to: CGPoint(x: rect.maxX, y: midY))
        p.addLine(to: CGPoint(x: rect.maxX * 0.55, y: rect.maxY - rect.height * 0.18))
        return p
    }
}

struct RingShape: Shape {
    var thickness: CGFloat = 6
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let inset = rect.insetBy(dx: thickness/2, dy: thickness/2)
        p.addEllipse(in: inset)
        return p.strokedPath(.init(lineWidth: thickness))
    }
}

// MARK: Module glyph dispatcher

struct ModuleGlyph: View {
    let kind: ModuleKind
    let color: Color
    let size: CGFloat

    var body: some View {
        Group {
            switch kind {
            case .command:           commandG
            case .lifeSupport:       lifeG
            case .hydroponics:       hydroG
            case .powerCell:         powerCellG
            case .solarArray:        solarG
            case .labBasic:          labBasicG
            case .labAdvanced:       labAdvG
            case .medBay:            medG
            case .airlock:           airlockG
            case .habSmall:          habG(rooms: 2)
            case .habLarge:          habG(rooms: 4)
            case .galley:            galleyG
            case .cargo:             cargoG
            case .observation:       observationG
            case .machineShop:       machineG
            case .comms:             commsG
            case .recreation:        recG
            case .scienceGreenhouse: greenG
            case .fuelTank:          fuelG
            case .warpCore:          warpG
            case .botany:            botanyG
            }
        }
        .frame(width: size, height: size)
    }

    private var commandG: some View {
        ZStack {
            HexShape().stroke(color, lineWidth: size * 0.10)
            Circle().fill(color.opacity(0.25)).frame(width: size*0.35, height: size*0.35)
            Circle().stroke(color, lineWidth: size*0.08).frame(width: size*0.55, height: size*0.55)
        }
    }
    private var lifeG: some View {
        ZStack {
            DiamondShape().stroke(color, lineWidth: size*0.10)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.18))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.82))
                p.move(to: CGPoint(x: size*0.18, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.82, y: size*0.5))
            }.stroke(color, lineWidth: size*0.07)
        }
    }
    private var hydroG: some View {
        ZStack {
            // leaf pair
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.92))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.25))
            }.stroke(color, lineWidth: size*0.07)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.42))
                p.addQuadCurve(to: CGPoint(x: size*0.22, y: size*0.30),
                               control: CGPoint(x: size*0.30, y: size*0.20))
                p.addQuadCurve(to: CGPoint(x: size*0.5, y: size*0.42),
                               control: CGPoint(x: size*0.30, y: size*0.42))
            }.fill(color.opacity(0.6))
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.55))
                p.addQuadCurve(to: CGPoint(x: size*0.78, y: size*0.42),
                               control: CGPoint(x: size*0.70, y: size*0.30))
                p.addQuadCurve(to: CGPoint(x: size*0.5, y: size*0.55),
                               control: CGPoint(x: size*0.70, y: size*0.55))
            }.fill(color.opacity(0.85))
        }
    }
    private var powerCellG: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size*0.18).stroke(color, lineWidth: size*0.09)
                .frame(width: size*0.7, height: size*0.85)
            Path { p in
                p.move(to: CGPoint(x: size*0.55, y: size*0.20))
                p.addLine(to: CGPoint(x: size*0.36, y: size*0.55))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.55))
                p.addLine(to: CGPoint(x: size*0.40, y: size*0.85))
                p.addLine(to: CGPoint(x: size*0.65, y: size*0.48))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.48))
                p.closeSubpath()
            }.fill(color)
        }
    }
    private var solarG: some View {
        ZStack {
            Path { p in
                for i in 0..<3 {
                    let x = size * (0.18 + 0.30 * CGFloat(i))
                    p.addRect(CGRect(x: x, y: size*0.18, width: size*0.18, height: size*0.55))
                }
            }.fill(color.opacity(0.85))
            Path { p in
                p.move(to: CGPoint(x: size*0.08, y: size*0.85))
                p.addLine(to: CGPoint(x: size*0.92, y: size*0.85))
            }.stroke(color, lineWidth: size*0.08)
        }
    }
    private var labBasicG: some View {
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: size*0.35, y: size*0.18))
                p.addLine(to: CGPoint(x: size*0.35, y: size*0.55))
                p.addLine(to: CGPoint(x: size*0.20, y: size*0.85))
                p.addLine(to: CGPoint(x: size*0.80, y: size*0.85))
                p.addLine(to: CGPoint(x: size*0.65, y: size*0.55))
                p.addLine(to: CGPoint(x: size*0.65, y: size*0.18))
            }.stroke(color, lineWidth: size*0.09)
            Circle().fill(color).frame(width: size*0.12, height: size*0.12)
                .offset(x: 0, y: size*0.18)
        }
    }
    private var labAdvG: some View {
        ZStack {
            labBasicG
            RingShape(thickness: size*0.05)
                .fill(color.opacity(0.8))
                .frame(width: size*0.45, height: size*0.45)
                .offset(y: -size*0.05)
        }
    }
    private var medG: some View {
        ZStack {
            Circle().stroke(color, lineWidth: size*0.10)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.25))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.75))
                p.move(to: CGPoint(x: size*0.25, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.75, y: size*0.5))
            }.stroke(color, lineWidth: size*0.13)
        }
    }
    private var airlockG: some View {
        ZStack {
            Circle().stroke(color, lineWidth: size*0.10)
            ForEach(0..<6) { i in
                Path { p in
                    let a = Double(i) * (.pi/3)
                    let r1 = size*0.36
                    let r2 = size*0.46
                    p.move(to: CGPoint(x: size*0.5 + CGFloat(cos(a))*r1, y: size*0.5 + CGFloat(sin(a))*r1))
                    p.addLine(to: CGPoint(x: size*0.5 + CGFloat(cos(a))*r2, y: size*0.5 + CGFloat(sin(a))*r2))
                }.stroke(color, lineWidth: size*0.08)
            }
        }
    }
    private func habG(rooms: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: size*0.12)
                .stroke(color, lineWidth: size*0.08)
                .frame(width: size*0.84, height: size*0.62)
            ForEach(0..<rooms, id: \.self) { i in
                Path { p in
                    let x = size * (0.16 + 0.84/CGFloat(rooms) * CGFloat(i+1) * 0.85)
                    if i < rooms - 1 {
                        p.move(to: CGPoint(x: x, y: size*0.26))
                        p.addLine(to: CGPoint(x: x, y: size*0.74))
                    }
                }.stroke(color, lineWidth: size*0.05)
            }
        }
    }
    private var galleyG: some View {
        ZStack {
            Path { p in
                p.addArc(center: CGPoint(x: size*0.5, y: size*0.55),
                         radius: size*0.32,
                         startAngle: .degrees(0),
                         endAngle: .degrees(180),
                         clockwise: true)
                p.closeSubpath()
            }.stroke(color, lineWidth: size*0.08)
            Path { p in
                p.move(to: CGPoint(x: size*0.20, y: size*0.55))
                p.addLine(to: CGPoint(x: size*0.80, y: size*0.55))
            }.stroke(color, lineWidth: size*0.07)
            Path { p in
                p.move(to: CGPoint(x: size*0.40, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.40, y: size*0.18))
                p.move(to: CGPoint(x: size*0.55, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.55, y: size*0.18))
            }.stroke(color, lineWidth: size*0.05)
        }
    }
    private var cargoG: some View {
        ZStack {
            Rectangle().stroke(color, lineWidth: size*0.08)
                .frame(width: size*0.72, height: size*0.72)
            Path { p in
                p.move(to: CGPoint(x: size*0.14, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.86, y: size*0.5))
                p.move(to: CGPoint(x: size*0.5, y: size*0.14))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.86))
            }.stroke(color, lineWidth: size*0.05)
        }
    }
    private var observationG: some View {
        ZStack {
            Circle().stroke(color, lineWidth: size*0.10).frame(width: size*0.75, height: size*0.75)
            Circle().fill(color.opacity(0.3)).frame(width: size*0.45, height: size*0.45)
            Circle().fill(color).frame(width: size*0.16, height: size*0.16)
                .offset(x: size*0.12, y: -size*0.08)
        }
    }
    private var machineG: some View {
        ZStack {
            HexShape(pointyTop: false).stroke(color, lineWidth: size*0.10).frame(width: size*0.7, height: size*0.7)
            ForEach(0..<6) { i in
                Path { p in
                    let a = Double(i) * (.pi/3) + .pi/6
                    let r1 = size*0.38
                    let r2 = size*0.48
                    p.move(to: CGPoint(x: size*0.5 + CGFloat(cos(a))*r1, y: size*0.5 + CGFloat(sin(a))*r1))
                    p.addLine(to: CGPoint(x: size*0.5 + CGFloat(cos(a))*r2, y: size*0.5 + CGFloat(sin(a))*r2))
                }.stroke(color, lineWidth: size*0.10)
            }
            Circle().fill(color).frame(width: size*0.15, height: size*0.15)
        }
    }
    private var commsG: some View {
        ZStack {
            ForEach(0..<3) { i in
                let r = size * (0.18 + 0.12 * CGFloat(i+1))
                Path { p in
                    p.addArc(center: CGPoint(x: size*0.5, y: size*0.78),
                             radius: r,
                             startAngle: .degrees(200),
                             endAngle: .degrees(340),
                             clockwise: false)
                }.stroke(color, lineWidth: size*0.06)
            }
            Circle().fill(color).frame(width: size*0.14, height: size*0.14)
                .offset(y: size*0.28)
        }
    }
    private var recG: some View {
        ZStack {
            Path { p in
                let cx = size*0.5
                let cy = size*0.55
                let r1 = size*0.30
                let r2 = size*0.12
                let n = 10
                for i in 0..<n {
                    let a = Double(i) * (.pi / Double(n/2)) - .pi/2
                    let r = (i % 2 == 0) ? r1 : r2
                    let pt = CGPoint(x: cx + CGFloat(cos(a))*r, y: cy + CGFloat(sin(a))*r)
                    if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                }
                p.closeSubpath()
            }.stroke(color, lineWidth: size*0.07)
        }
    }
    private var greenG: some View {
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: size*0.14, y: size*0.84))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.16))
                p.addLine(to: CGPoint(x: size*0.86, y: size*0.84))
                p.closeSubpath()
            }.stroke(color, lineWidth: size*0.08)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.40))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.84))
            }.stroke(color, lineWidth: size*0.06)
        }
    }
    private var fuelG: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size*0.30)
                .stroke(color, lineWidth: size*0.10)
                .frame(width: size*0.5, height: size*0.78)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.70))
                p.move(to: CGPoint(x: size*0.32, y: size*0.50))
                p.addLine(to: CGPoint(x: size*0.68, y: size*0.50))
            }.stroke(color.opacity(0.6), lineWidth: size*0.05)
        }
    }
    private var warpG: some View {
        ZStack {
            Circle().stroke(color, lineWidth: size*0.05).frame(width: size*0.86, height: size*0.86)
            Circle().stroke(color, lineWidth: size*0.05).frame(width: size*0.62, height: size*0.62)
            Circle().fill(color).frame(width: size*0.20, height: size*0.20)
            ForEach(0..<4) { i in
                Path { p in
                    let a = Double(i) * (.pi/2) + .pi/4
                    let r1 = size*0.14
                    let r2 = size*0.42
                    p.move(to: CGPoint(x: size*0.5 + CGFloat(cos(a))*r1, y: size*0.5 + CGFloat(sin(a))*r1))
                    p.addLine(to: CGPoint(x: size*0.5 + CGFloat(cos(a))*r2, y: size*0.5 + CGFloat(sin(a))*r2))
                }.stroke(color, lineWidth: size*0.07)
            }
        }
    }
    private var botanyG: some View {
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.88))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.35))
            }.stroke(color, lineWidth: size*0.06)
            ForEach(0..<3) { i in
                let y = size * (0.40 + 0.18 * CGFloat(i))
                Path { p in
                    p.move(to: CGPoint(x: size*0.5, y: y))
                    p.addQuadCurve(to: CGPoint(x: size*0.5 + (i%2==0 ? -size*0.22 : size*0.22), y: y - size*0.08),
                                   control: CGPoint(x: size*0.5 + (i%2==0 ? -size*0.10 : size*0.10), y: y - size*0.14))
                }.stroke(color, lineWidth: size*0.05)
            }
        }
    }
}

// MARK: Resource glyphs (used in resource bar)

struct ResourceIcon: View {
    let kind: ResourceKind
    let size: CGFloat
    let color: Color

    var body: some View {
        Group {
            switch kind {
            case .power:    powerG
            case .oxygen:   oxygenG
            case .water:    waterG
            case .food:     foodG
            case .parts:    partsG
            case .medicine: medicineG
            case .fuel:     fuelG
            case .research: researchG
            case .credits:  creditsG
            case .morale:   moraleG
            }
        }
        .frame(width: size, height: size)
    }

    private var powerG: some View {
        Path { p in
            p.move(to: CGPoint(x: size*0.55, y: 0))
            p.addLine(to: CGPoint(x: size*0.18, y: size*0.55))
            p.addLine(to: CGPoint(x: size*0.50, y: size*0.55))
            p.addLine(to: CGPoint(x: size*0.34, y: size))
            p.addLine(to: CGPoint(x: size*0.82, y: size*0.42))
            p.addLine(to: CGPoint(x: size*0.50, y: size*0.42))
            p.closeSubpath()
        }.fill(color)
    }
    private var oxygenG: some View {
        ZStack {
            // Main O ring (the "O" of O2)
            Circle()
                .stroke(color, lineWidth: size*0.10)
                .frame(width: size*0.62, height: size*0.62)
                .offset(x: -size*0.12, y: -size*0.04)
            // Inner accent on the ring (two molecular dots, evoking O2)
            Circle()
                .fill(color)
                .frame(width: size*0.10, height: size*0.10)
                .offset(x: -size*0.30, y: -size*0.04)
            Circle()
                .fill(color)
                .frame(width: size*0.10, height: size*0.10)
                .offset(x: size*0.06, y: -size*0.04)
            // Subscript "2" rendered as a stylized shape (curve + base bar)
            Path { p in
                let bx = size*0.62
                let by = size*0.58
                let w = size*0.28
                let h = size*0.30
                // Top curve of "2"
                p.move(to: CGPoint(x: bx, y: by + h*0.25))
                p.addQuadCurve(
                    to: CGPoint(x: bx + w, y: by + h*0.25),
                    control: CGPoint(x: bx + w*0.5, y: by - h*0.10)
                )
                // Diagonal stroke down
                p.addLine(to: CGPoint(x: bx, y: by + h))
                // Bottom bar
                p.addLine(to: CGPoint(x: bx + w, y: by + h))
            }
            .stroke(color, lineWidth: size*0.08)
        }
    }
    private var waterG: some View {
        Path { p in
            p.move(to: CGPoint(x: size*0.5, y: size*0.04))
            p.addQuadCurve(to: CGPoint(x: size*0.92, y: size*0.7),
                           control: CGPoint(x: size*0.96, y: size*0.42))
            p.addArc(center: CGPoint(x: size*0.5, y: size*0.7), radius: size*0.42,
                     startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            p.addQuadCurve(to: CGPoint(x: size*0.5, y: size*0.04),
                           control: CGPoint(x: size*0.04, y: size*0.42))
            p.closeSubpath()
        }.fill(color)
    }
    private var foodG: some View {
        ZStack {
            Circle().fill(color.opacity(0.3))
            Circle().stroke(color, lineWidth: size*0.08)
            Path { p in
                p.move(to: CGPoint(x: size*0.50, y: size*0.18))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.84))
            }.stroke(color, lineWidth: size*0.06)
            Path { p in
                p.move(to: CGPoint(x: size*0.30, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.30, y: size*0.55))
                p.move(to: CGPoint(x: size*0.70, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.70, y: size*0.55))
            }.stroke(color, lineWidth: size*0.05)
        }
    }
    private var partsG: some View {
        HexShape().stroke(color, lineWidth: size*0.12)
    }
    private var medicineG: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size*0.15)
                .fill(color.opacity(0.3))
            RoundedRectangle(cornerRadius: size*0.15)
                .stroke(color, lineWidth: size*0.07)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.22))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.78))
                p.move(to: CGPoint(x: size*0.22, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.78, y: size*0.5))
            }.stroke(color, lineWidth: size*0.14)
        }
    }
    private var fuelG: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size*0.22)
                .stroke(color, lineWidth: size*0.10)
                .frame(width: size*0.6, height: size*0.85)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.50))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.78))
            }.stroke(color, lineWidth: size*0.10)
        }
    }
    private var researchG: some View {
        ZStack {
            Path { p in
                let cx = size*0.5; let cy = size*0.5
                let outer = size*0.42; let inner = size*0.18
                let n = 14
                for i in 0..<n {
                    let a = Double(i) * (.pi / Double(n/2)) - .pi/2
                    let r = (i % 2 == 0) ? outer : inner
                    let pt = CGPoint(x: cx + CGFloat(cos(a))*r, y: cy + CGFloat(sin(a))*r)
                    if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                }
                p.closeSubpath()
            }.fill(color)
        }
    }
    private var creditsG: some View {
        ZStack {
            Circle().stroke(color, lineWidth: size*0.10)
            Path { p in
                p.move(to: CGPoint(x: size*0.30, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.70, y: size*0.70))
                p.move(to: CGPoint(x: size*0.70, y: size*0.30))
                p.addLine(to: CGPoint(x: size*0.30, y: size*0.70))
            }.stroke(color, lineWidth: size*0.07)
        }
    }
    private var moraleG: some View {
        ZStack {
            Path { p in
                let cx = size*0.5; let cy = size*0.55
                let r = size*0.34
                p.move(to: CGPoint(x: cx - r, y: cy))
                p.addCurve(to: CGPoint(x: cx, y: cy + r*0.9),
                           control1: CGPoint(x: cx - r, y: cy + r),
                           control2: CGPoint(x: cx - r*0.5, y: cy + r*0.9))
                p.addCurve(to: CGPoint(x: cx + r, y: cy),
                           control1: CGPoint(x: cx + r*0.5, y: cy + r*0.9),
                           control2: CGPoint(x: cx + r, y: cy + r))
                p.addCurve(to: CGPoint(x: cx, y: cy - r*0.4),
                           control1: CGPoint(x: cx + r, y: cy - r*0.5),
                           control2: CGPoint(x: cx + r*0.4, y: cy - r*0.4))
                p.addCurve(to: CGPoint(x: cx - r, y: cy),
                           control1: CGPoint(x: cx - r*0.4, y: cy - r*0.4),
                           control2: CGPoint(x: cx - r, y: cy - r*0.5))
                p.closeSubpath()
            }.fill(color)
        }
    }
}

// MARK: Crew portrait shape

struct CrewPortrait: View {
    let seed: Int
    let role: CrewRole
    let size: CGFloat
    let outlineColor: Color
    let fillColor: Color

    var body: some View {
        ZStack {
            // background plate
            HexShape(pointyTop: true)
                .fill(fillColor.opacity(0.25))
            HexShape(pointyTop: true)
                .stroke(outlineColor, lineWidth: size*0.05)

            // head
            Circle()
                .fill(outlineColor.opacity(0.85))
                .frame(width: size*0.32, height: size*0.32)
                .offset(y: -size*0.08)

            // collar / shoulders
            Path { p in
                p.move(to: CGPoint(x: size*0.22, y: size*0.78))
                p.addQuadCurve(to: CGPoint(x: size*0.78, y: size*0.78),
                               control: CGPoint(x: size*0.5, y: size*0.50))
                p.addLine(to: CGPoint(x: size*0.78, y: size*0.90))
                p.addLine(to: CGPoint(x: size*0.22, y: size*0.90))
                p.closeSubpath()
            }.fill(outlineColor)

            // role accent (small chevron mark)
            roleMark(role: role, size: size, color: fillColor)
                .offset(y: size*0.13)

            // hair tag (vary by seed)
            let hairOffset = CGFloat((seed % 5) - 2) * 0.012 * size
            Path { p in
                let r = size*0.18
                p.move(to: CGPoint(x: size*0.5 - r + hairOffset, y: size*0.30))
                p.addQuadCurve(to: CGPoint(x: size*0.5 + r + hairOffset, y: size*0.30),
                               control: CGPoint(x: size*0.5 + hairOffset, y: size*0.16))
            }.stroke(outlineColor.opacity(0.5), lineWidth: size*0.05)
        }
        .frame(width: size, height: size)
    }

    @ViewBuilder
    private func roleMark(role: CrewRole, size: CGFloat, color: Color) -> some View {
        switch role {
        case .captain:
            // pip/chevron
            Path { p in
                p.move(to: CGPoint(x: size*0.40, y: size*0.84))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.74))
                p.addLine(to: CGPoint(x: size*0.60, y: size*0.84))
            }.stroke(color, lineWidth: size*0.04)
        case .engineer:
            HexShape(pointyTop: false).stroke(color, lineWidth: size*0.04)
                .frame(width: size*0.18, height: size*0.18)
                .offset(y: size*0.10)
        case .medic:
            ZStack {
                Path { p in
                    p.move(to: CGPoint(x: size*0.5, y: size*0.72))
                    p.addLine(to: CGPoint(x: size*0.5, y: size*0.86))
                    p.move(to: CGPoint(x: size*0.43, y: size*0.79))
                    p.addLine(to: CGPoint(x: size*0.57, y: size*0.79))
                }.stroke(color, lineWidth: size*0.05)
            }
        case .scientist:
            Circle().stroke(color, lineWidth: size*0.03).frame(width: size*0.18, height: size*0.18)
                .offset(y: size*0.10)
        case .pilot:
            DiamondShape().stroke(color, lineWidth: size*0.04).frame(width: size*0.18, height: size*0.18)
                .offset(y: size*0.10)
        case .botanist:
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.86))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.70))
                p.addQuadCurve(to: CGPoint(x: size*0.62, y: size*0.68),
                               control: CGPoint(x: size*0.60, y: size*0.74))
            }.stroke(color, lineWidth: size*0.04)
        case .cook:
            Path { p in
                p.addArc(center: CGPoint(x: size*0.5, y: size*0.84),
                         radius: size*0.10,
                         startAngle: .degrees(180),
                         endAngle: .degrees(360),
                         clockwise: false)
                p.closeSubpath()
            }.stroke(color, lineWidth: size*0.04)
        case .comms:
            ForEach(0..<3) { i in
                Path { p in
                    p.addArc(center: CGPoint(x: size*0.5, y: size*0.84),
                             radius: size*0.06 + size*0.04*CGFloat(i),
                             startAngle: .degrees(200),
                             endAngle: .degrees(340),
                             clockwise: false)
                }.stroke(color, lineWidth: size*0.02)
            }
        case .security:
            Path { p in
                p.move(to: CGPoint(x: size*0.40, y: size*0.74))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.70))
                p.addLine(to: CGPoint(x: size*0.60, y: size*0.74))
                p.addLine(to: CGPoint(x: size*0.55, y: size*0.86))
                p.addLine(to: CGPoint(x: size*0.45, y: size*0.86))
                p.closeSubpath()
            }.stroke(color, lineWidth: size*0.04)
        case .maintenance:
            Path { p in
                p.move(to: CGPoint(x: size*0.38, y: size*0.78))
                p.addLine(to: CGPoint(x: size*0.62, y: size*0.78))
                p.move(to: CGPoint(x: size*0.50, y: size*0.70))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.86))
            }.stroke(color, lineWidth: size*0.04)
        case .researcher:
            Path { p in
                p.move(to: CGPoint(x: size*0.40, y: size*0.84))
                p.addLine(to: CGPoint(x: size*0.50, y: size*0.74))
                p.addLine(to: CGPoint(x: size*0.60, y: size*0.84))
                p.move(to: CGPoint(x: size*0.42, y: size*0.84))
                p.addLine(to: CGPoint(x: size*0.58, y: size*0.84))
            }.stroke(color, lineWidth: size*0.04)
        case .quartermaster:
            Rectangle().stroke(color, lineWidth: size*0.04).frame(width: size*0.18, height: size*0.14)
                .offset(y: size*0.11)
        }
    }
}

// MARK: Pill / chip background

struct ChipBackground: View {
    let color: Color
    var body: some View {
        Capsule().fill(color.opacity(0.16))
            .overlay(Capsule().stroke(color.opacity(0.45), lineWidth: 1))
    }
}

// MARK: Tile cell drawing (used by station grid)

struct TileBackground: View {
    let accent: Color
    let footprintColor: Color
    let highlighted: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(colors: [
                        accent.opacity(0.18),
                        accent.opacity(0.06)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            RoundedRectangle(cornerRadius: 10)
                .stroke(highlighted ? OrbitalGridPalette.ember : accent.opacity(0.55),
                        lineWidth: highlighted ? 2.2 : 1)
            // small dotted corners
            ForEach(0..<4) { i in
                Circle().fill(footprintColor.opacity(0.45))
                    .frame(width: 3, height: 3)
                    .offset(
                        x: (i % 2 == 0 ? -1 : 1) * 6,
                        y: (i < 2 ? -1 : 1) * 6
                    )
            }
        }
    }
}

// MARK: Tab bar glyphs

struct StationTabGlyph: View { let size: CGFloat; let color: Color
    var body: some View {
        ZStack {
            HexShape().stroke(color, lineWidth: size*0.10)
            HexShape().stroke(color.opacity(0.5), lineWidth: size*0.06)
                .frame(width: size*0.55, height: size*0.55)
        }.frame(width: size, height: size)
    }
}
struct CrewTabGlyph: View { let size: CGFloat; let color: Color
    var body: some View {
        ZStack {
            Circle().fill(color).frame(width: size*0.32, height: size*0.32).offset(y: -size*0.15)
            Capsule().fill(color).frame(width: size*0.66, height: size*0.34).offset(y: size*0.18)
        }.frame(width: size, height: size)
    }
}
struct ResearchTabGlyph: View { let size: CGFloat; let color: Color
    var body: some View {
        ZStack {
            Circle().stroke(color, lineWidth: size*0.10).frame(width: size*0.6, height: size*0.6)
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: size*0.10))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.30))
                p.move(to: CGPoint(x: size*0.5, y: size*0.70))
                p.addLine(to: CGPoint(x: size*0.5, y: size*0.90))
                p.move(to: CGPoint(x: size*0.10, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.30, y: size*0.5))
                p.move(to: CGPoint(x: size*0.70, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.90, y: size*0.5))
            }.stroke(color, lineWidth: size*0.10)
        }.frame(width: size, height: size)
    }
}
struct LogTabGlyph: View { let size: CGFloat; let color: Color
    var body: some View {
        ZStack {
            Rectangle().stroke(color, lineWidth: size*0.08)
                .frame(width: size*0.66, height: size*0.78)
            Path { p in
                p.move(to: CGPoint(x: size*0.25, y: size*0.34))
                p.addLine(to: CGPoint(x: size*0.75, y: size*0.34))
                p.move(to: CGPoint(x: size*0.25, y: size*0.5))
                p.addLine(to: CGPoint(x: size*0.75, y: size*0.5))
                p.move(to: CGPoint(x: size*0.25, y: size*0.66))
                p.addLine(to: CGPoint(x: size*0.60, y: size*0.66))
            }.stroke(color, lineWidth: size*0.05)
        }.frame(width: size, height: size)
    }
}
struct ArchiveTabGlyph: View { let size: CGFloat; let color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size*0.10)
                .stroke(color, lineWidth: size*0.08)
                .frame(width: size*0.72, height: size*0.72)
            Path { p in
                p.move(to: CGPoint(x: size*0.18, y: size*0.36))
                p.addLine(to: CGPoint(x: size*0.82, y: size*0.36))
            }.stroke(color, lineWidth: size*0.08)
            Path { p in
                p.addEllipse(in: CGRect(x: size*0.40, y: size*0.50, width: size*0.20, height: size*0.20))
            }.fill(color.opacity(0.6))
        }.frame(width: size, height: size)
    }
}
