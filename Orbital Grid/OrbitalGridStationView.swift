import SwiftUI

// MARK: - Orbital Grid: grid + module palette

struct OrbitalGridStationView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @State private var showRemoveConfirmId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            // F-Major-3: first-steps onboarding banner shown only on fresh games.
            if showFirstStepsBanner {
                firstStepsBanner
                    .padding(.horizontal, 14)
                    .padding(.top, 8)
            }
            statusRow
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 6)

            GeometryReader { proxy in
                let cell = stationCellSize(in: proxy.size)
                let gridW = cell * CGFloat(OrbitalGridGameStore.gridW)
                let gridH = cell * CGFloat(OrbitalGridGameStore.gridH)
                let originX = (proxy.size.width - gridW) / 2
                let originY = (proxy.size.height - gridH) / 2

                ZStack(alignment: .topLeading) {
                    // background grid
                    StationGridBackground(cell: cell, screenSize: proxy.size)
                        .frame(width: gridW, height: gridH)
                        .position(x: originX + gridW/2, y: originY + gridH/2)

                    // placed modules
                    ForEach(game.placed) { mod in
                        let spec = OrbitalGridCatalog.module(mod.kind)
                        let x = originX + CGFloat(mod.origin.x) * cell
                        let y = originY + CGFloat(mod.origin.y) * cell
                        StationModuleCell(
                            mod: mod,
                            spec: spec,
                            cell: cell,
                            assignedCount: mod.assignedCrewIds.count,
                            onTap: {
                                if showRemoveConfirmId == mod.id {
                                    showRemoveConfirmId = nil
                                    game.remove(moduleId: mod.id)
                                } else {
                                    showRemoveConfirmId = mod.id
                                }
                            }
                        )
                        .frame(width: cell * CGFloat(spec.footprint.w),
                               height: cell * CGFloat(spec.footprint.h))
                        .position(x: x + cell * CGFloat(spec.footprint.w) / 2,
                                  y: y + cell * CGFloat(spec.footprint.h) / 2)
                    }

                    // ghost preview for selected module
                    if let kind = game.selectedPaletteModule {
                        let spec = OrbitalGridCatalog.module(kind)
                        if let target = game.selectedTile {
                            let valid = game.canPlace(kind: kind, at: target).0
                            let x = originX + CGFloat(target.x) * cell
                            let y = originY + CGFloat(target.y) * cell
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(valid ? OrbitalGridPalette.success : OrbitalGridPalette.danger,
                                        style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                                .frame(width: cell * CGFloat(spec.footprint.w),
                                       height: cell * CGFloat(spec.footprint.h))
                                .position(x: x + cell * CGFloat(spec.footprint.w) / 2,
                                          y: y + cell * CGFloat(spec.footprint.h) / 2)
                        }
                    }

                    // tap overlay (single layer that captures grid taps)
                    StationGridTapper(cell: cell, originX: originX, originY: originY) { pt in
                        handleTap(at: pt)
                    }
                    .frame(width: gridW, height: gridH)
                    .position(x: originX + gridW/2, y: originY + gridH/2)
                }
            }
            .background(OrbitalGridPalette.bgDim)

            modulePalette
        }
        .navigationTitle("Station")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stationCellSize(in containerSize: CGSize) -> CGFloat {
        let maxW = containerSize.width - 16
        let maxH = containerSize.height - 16
        let candidateW = maxW / CGFloat(OrbitalGridGameStore.gridW)
        let candidateH = maxH / CGFloat(OrbitalGridGameStore.gridH)
        return max(20, min(candidateW, candidateH))
    }

    private func handleTap(at pt: GridPoint) {
        // if a module is selected for placement
        if let kind = game.selectedPaletteModule {
            game.selectedTile = pt
            let ok = game.canPlace(kind: kind, at: pt).0
            if ok {
                game.place(kind: kind, at: pt)
                game.selectedPaletteModule = nil
                game.selectedTile = nil
                showRemoveConfirmId = nil
            }
            return
        }
        // otherwise, tapping cell — if a module is there, prompt remove
        if let mod = game.module(at: pt) {
            if showRemoveConfirmId == mod.id {
                showRemoveConfirmId = nil
                game.remove(moduleId: mod.id)
            } else {
                showRemoveConfirmId = mod.id
            }
        } else {
            showRemoveConfirmId = nil
        }
    }

    private var showFirstStepsBanner: Bool {
        // Hidden once any module is placed OR day > 4.
        return game.placed.isEmpty && game.day <= 4
    }

    private var firstStepsBanner: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("First Steps")
                .font(OrbitalGridTypography.title(13))
                .foregroundColor(OrbitalGridPalette.indigo)
            Text("1. Build a Power Cell Bank to seed the grid.")
                .font(OrbitalGridTypography.body(11))
                .foregroundColor(OrbitalGridPalette.graphite)
            Text("2. Place Life Support adjacent to it.")
                .font(OrbitalGridTypography.body(11))
                .foregroundColor(OrbitalGridPalette.graphite)
            Text("3. Open Crew tab to assign at least 2 crew to those modules.")
                .font(OrbitalGridTypography.body(11))
                .foregroundColor(OrbitalGridPalette.graphite)
            Text("4. Advance Day to see resources tick.")
                .font(OrbitalGridTypography.body(11))
                .foregroundColor(OrbitalGridPalette.graphite)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.ember.opacity(0.6), lineWidth: 1))
    }

    private var statusRow: some View {
        let (prod, cons) = game.powerProductionConsumption()
        let powerNet = prod - cons
        let (oxProd, oxCons) = game.oxygenProductionConsumption()
        let oxNet = oxProd - oxCons
        let warp = game.warpKeystoneCount()
        return VStack(spacing: 6) {
            HStack(spacing: 10) {
                netChip(label: "Power", net: powerNet, color: OrbitalGridPalette.modPower)
                netChip(label: "O2", net: oxNet, color: OrbitalGridPalette.modLife)
                Spacer(minLength: 4)
                Text("Warp: \(warp.0)/\(warp.1)")
                    .font(OrbitalGridTypography.mono(11))
                    .foregroundColor(OrbitalGridPalette.indigo)
                    .padding(.horizontal, 7).padding(.vertical, 3)
                    .background(ChipBackground(color: OrbitalGridPalette.magenta))
            }
            if let kind = game.selectedPaletteModule {
                let spec = OrbitalGridCatalog.module(kind)
                let canHint: String? = {
                    if let pt = game.selectedTile, !game.canPlace(kind: kind, at: pt).0 {
                        return game.canPlace(kind: kind, at: pt).1
                    }
                    return nil
                }()
                HStack(spacing: 8) {
                    ModuleGlyph(kind: kind, color: spec.category.color, size: 22)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Placing: \(spec.name)")
                            .font(OrbitalGridTypography.title(12))
                            .foregroundColor(OrbitalGridPalette.indigo)
                        if let hint = canHint {
                            Text(hint)
                                .font(OrbitalGridTypography.body(10))
                                .foregroundColor(OrbitalGridPalette.danger)
                        } else {
                            Text("Tap a grid cell to place. \(spec.buildCostParts) parts. \(spec.footprint.w)×\(spec.footprint.h).")
                                .font(OrbitalGridTypography.body(10))
                                .foregroundColor(OrbitalGridPalette.graphite.opacity(0.75))
                        }
                    }
                    Spacer(minLength: 4)
                    Button(action: { game.selectedPaletteModule = nil; game.selectedTile = nil }) {
                        Text("Cancel").font(OrbitalGridTypography.chip(11))
                            .padding(.horizontal, 9).padding(.vertical, 4)
                            .background(Capsule().stroke(OrbitalGridPalette.graphite.opacity(0.45), lineWidth: 1))
                            .foregroundColor(OrbitalGridPalette.graphite)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }
    private func netChip(label: String, net: Int, color: Color) -> some View {
        HStack(spacing: 4) {
            Text(label).font(OrbitalGridTypography.chip(11))
                .foregroundColor(color)
            Text(net >= 0 ? "+\(net)" : "\(net)")
                .font(OrbitalGridTypography.mono(11))
                .foregroundColor(net >= 0 ? OrbitalGridPalette.success : OrbitalGridPalette.danger)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(ChipBackground(color: color))
    }

    private var modulePalette: some View {
        VStack(spacing: 0) {
            Divider().background(OrbitalGridPalette.hairline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(OrbitalGridCatalog.modules) { spec in
                        moduleChoice(spec)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
            }
            .background(OrbitalGridPalette.panel)
        }
    }
    private func moduleChoice(_ spec: ModuleSpec) -> some View {
        let researchOk: Bool = {
            guard let req = spec.requiresResearchId else { return true }
            return game.completedResearchIds.contains(req)
        }()
        let unlocked = game.phaseAllows(spec.phaseUnlock) && researchOk
        // M-2: disable when player cannot afford parts or credits, even if unlocked
        let affordable = game.amount(.parts) >= spec.buildCostParts && game.amount(.credits) >= spec.buildCostCredits
        let enabled = unlocked && affordable
        let selected = game.selectedPaletteModule == spec.kind
        return Button(action: {
            if enabled {
                game.selectedPaletteModule = selected ? nil : spec.kind
                game.selectedTile = nil
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(spec.category.color.opacity(enabled ? 0.12 : 0.05))
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(selected ? OrbitalGridPalette.ember : spec.category.color.opacity(enabled ? 0.45 : 0.2),
                                lineWidth: selected ? 2.2 : 1)
                    ModuleGlyph(kind: spec.kind, color: spec.category.color.opacity(enabled ? 1 : 0.4), size: 38)
                        .frame(width: 50, height: 50)
                }
                .frame(width: 64, height: 64)

                Text(spec.name)
                    .font(OrbitalGridTypography.chip(10))
                    .foregroundColor(enabled ? OrbitalGridPalette.indigo : OrbitalGridPalette.graphite.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 70)
                Text("\(spec.buildCostParts)p")
                    .font(OrbitalGridTypography.mono(9))
                    .foregroundColor(unlocked && !affordable ? OrbitalGridPalette.danger : OrbitalGridPalette.graphite.opacity(0.7))
            }
        }
        .buttonStyle(.plain)
        .opacity(enabled ? 1.0 : 0.55)
        .disabled(!enabled)
    }
}

// MARK: Grid background drawing

struct StationGridBackground: View {
    let cell: CGFloat
    let screenSize: CGSize
    var body: some View {
        Canvas { ctx, _ in
            // anchor math to screenSize (parent), per the iOS 26 size pitfall
            let cols = OrbitalGridGameStore.gridW
            let rows = OrbitalGridGameStore.gridH
            let w = cell * CGFloat(cols)
            let h = cell * CGFloat(rows)
            // background
            ctx.fill(Path(CGRect(x: 0, y: 0, width: w, height: h)),
                     with: .color(OrbitalGridPalette.ivory))
            // hull edge band
            let band = Path(roundedRect: CGRect(x: 0, y: 0, width: w, height: h), cornerRadius: 8)
            ctx.stroke(band, with: .color(OrbitalGridPalette.indigo.opacity(0.4)), lineWidth: 2)
            // gridlines
            for c in 0...cols {
                let x = CGFloat(c) * cell
                ctx.stroke(Path { p in
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x, y: h))
                }, with: .color(OrbitalGridPalette.hairline.opacity(0.6)), lineWidth: 0.5)
            }
            for r in 0...rows {
                let y = CGFloat(r) * cell
                ctx.stroke(Path { p in
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: w, y: y))
                }, with: .color(OrbitalGridPalette.hairline.opacity(0.6)), lineWidth: 0.5)
            }
            // subtle ring at center
            let cx = w/2; let cy = h/2
            ctx.stroke(Path(ellipseIn: CGRect(x: cx - cell*0.8, y: cy - cell*0.8, width: cell*1.6, height: cell*1.6)),
                       with: .color(OrbitalGridPalette.teal.opacity(0.25)),
                       lineWidth: 1.2)
            _ = screenSize
        }
    }
}

// MARK: Grid tap layer

struct StationGridTapper: View {
    let cell: CGFloat
    let originX: CGFloat
    let originY: CGFloat
    let onTap: (GridPoint) -> Void

    var body: some View {
        // Use Color.clear as content but with .contentShape to capture taps.
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0).onEnded { value in
                    let local = value.location
                    let cx = Int(local.x / cell)
                    let cy = Int(local.y / cell)
                    if cx >= 0 && cx < OrbitalGridGameStore.gridW &&
                       cy >= 0 && cy < OrbitalGridGameStore.gridH {
                        onTap(GridPoint(x: cx, y: cy))
                    }
                }
            )
    }
}

// MARK: Module cell

struct StationModuleCell: View {
    let mod: PlacedModule
    let spec: ModuleSpec
    let cell: CGFloat
    let assignedCount: Int
    let onTap: () -> Void

    var body: some View {
        let underConstruction = mod.constructionDaysLeft > 0
        Button(action: onTap) {
            ZStack {
                TileBackground(accent: spec.category.color,
                               footprintColor: spec.category.color,
                               highlighted: false)
                VStack(spacing: 2) {
                    ModuleGlyph(kind: mod.kind, color: spec.category.color, size: cell*0.65)
                        .frame(width: cell*0.7, height: cell*0.7)
                    if spec.crewSlots > 0 {
                        HStack(spacing: 1) {
                            ForEach(0..<spec.crewSlots, id: \.self) { i in
                                Circle()
                                    .fill(i < assignedCount ? OrbitalGridPalette.ember : OrbitalGridPalette.hairline)
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                }
                if underConstruction {
                    ZStack {
                        Rectangle().fill(OrbitalGridPalette.ivory.opacity(0.55))
                        Text("\(mod.constructionDaysLeft)d")
                            .font(OrbitalGridTypography.mono(11))
                            .foregroundColor(OrbitalGridPalette.indigo)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}
