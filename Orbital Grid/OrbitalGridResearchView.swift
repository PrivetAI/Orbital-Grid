import SwiftUI

// MARK: - Orbital Grid: research tree, organized by branch/tier

struct OrbitalGridResearchView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @State private var selectedBranch: ResearchBranch = .engineering

    var body: some View {
        VStack(spacing: 0) {
            branchTabs
                .padding(.top, 8)
                .padding(.horizontal, 10)
            activeBar
                .padding(.horizontal, 10)
                .padding(.top, 6)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(1...5, id: \.self) { tier in
                            tierBlock(tier: tier)
                                .id("tier-\(tier)")
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                }
                .background(OrbitalGridPalette.bgDim)
                .onAppear {
                    if let activeId = game.activeResearchId,
                       let r = OrbitalGridCatalog.research(activeId),
                       r.branch == selectedBranch {
                        withAnimation { proxy.scrollTo("tier-\(r.tier)", anchor: .top) }
                    }
                }
            }
        }
        .background(OrbitalGridPalette.bgDim.edgesIgnoringSafeArea(.all))
        .navigationTitle("Research")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var branchTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(ResearchBranch.allCases, id: \.self) { br in
                    Button(action: { selectedBranch = br }) {
                        HStack(spacing: 5) {
                            DiamondShape().fill(br.color).frame(width: 8, height: 8)
                            Text(br.label).font(OrbitalGridTypography.chip(11))
                        }
                        .foregroundColor(selectedBranch == br ? OrbitalGridPalette.indigo : OrbitalGridPalette.graphite.opacity(0.7))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(
                            Capsule().fill(selectedBranch == br ? br.color.opacity(0.18) : OrbitalGridPalette.panel)
                        )
                        .overlay(
                            Capsule().stroke(selectedBranch == br ? br.color : OrbitalGridPalette.hairline,
                                             lineWidth: selectedBranch == br ? 2 : 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var activeBar: some View {
        if let activeId = game.activeResearchId, let r = OrbitalGridCatalog.research(activeId) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    DiamondShape().fill(r.branch.color).frame(width: 10, height: 10)
                    Text("Researching: \(r.name)")
                        .font(OrbitalGridTypography.title(13)).foregroundColor(OrbitalGridPalette.indigo)
                    Spacer()
                    Text("\(game.researchPoints)/\(r.pointsRequired)")
                        .font(OrbitalGridTypography.mono(11)).foregroundColor(OrbitalGridPalette.magenta)
                }
                ZStack(alignment: .leading) {
                    Capsule().fill(r.branch.color.opacity(0.18)).frame(height: 6)
                    GeometryReader { proxy in
                        Capsule().fill(r.branch.color)
                            .frame(width: max(0, min(CGFloat(game.researchPoints) / CGFloat(r.pointsRequired), 1)) * proxy.size.width,
                                   height: 6)
                    }.frame(height: 6)
                }
                Text(r.summary)
                    .font(OrbitalGridTypography.body(11)).foregroundColor(OrbitalGridPalette.graphite.opacity(0.85))
                scientistAssignBar
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
        } else {
            HStack {
                Text("No active research. Tap a tier 1 project below.")
                    .font(OrbitalGridTypography.body(12))
                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.75))
                Spacer()
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
        }
    }
    private var scientistAssignBar: some View {
        let scientists = game.crew.filter { ($0.role == .scientist || $0.role == .researcher) && $0.alive }
        return Group {
            if !scientists.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Assign extra scientists (+10% each)")
                        .font(OrbitalGridTypography.chip(10)).foregroundColor(OrbitalGridPalette.graphite.opacity(0.75))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(scientists) { cm in
                                let toggled = game.assignedScientistIds.contains(cm.id)
                                Button(action: { game.toggleScientist(cm.id) }) {
                                    HStack(spacing: 5) {
                                        CrewPortrait(seed: cm.portraitSeed, role: cm.role, size: 22,
                                                     outlineColor: OrbitalGridPalette.indigo, fillColor: OrbitalGridPalette.teal)
                                        Text(cm.name.components(separatedBy: " ").first ?? cm.name)
                                            .font(OrbitalGridTypography.chip(9))
                                    }
                                    .padding(.horizontal, 7).padding(.vertical, 4)
                                    .background(
                                        Capsule().fill(toggled ? OrbitalGridPalette.magenta.opacity(0.15) : OrbitalGridPalette.panelDeep)
                                    )
                                    .overlay(Capsule().stroke(toggled ? OrbitalGridPalette.magenta : OrbitalGridPalette.hairline, lineWidth: 1))
                                    .foregroundColor(toggled ? OrbitalGridPalette.magenta : OrbitalGridPalette.indigo)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
    }

    private func tierBlock(tier: Int) -> some View {
        let items = OrbitalGridCatalog.research
            .filter { $0.branch == selectedBranch && $0.tier == tier }
        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("Tier \(tier)").font(OrbitalGridTypography.title(13))
                    .foregroundColor(OrbitalGridPalette.indigo)
                Rectangle().fill(OrbitalGridPalette.hairline).frame(height: 1)
            }
            // grid of nodes
            let rows = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
            LazyVGrid(columns: rows, alignment: .leading, spacing: 8) {
                ForEach(items) { r in
                    researchNode(r)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }

    private func researchNode(_ r: ResearchSpec) -> some View {
        let done = game.completedResearchIds.contains(r.id)
        let active = game.activeResearchId == r.id
        let prereqs = r.prereqIds.allSatisfy { game.completedResearchIds.contains($0) }
        let labOk: Bool = {
            if r.labTierRequired <= 1 {
                return game.placed.contains(where: { ($0.kind == .labBasic || $0.kind == .labAdvanced) && $0.constructionDaysLeft == 0 })
            }
            return game.placed.contains(where: { $0.kind == .labAdvanced && $0.constructionDaysLeft == 0 })
        }()
        let actionable = !done && !active && prereqs && labOk
        return Button(action: {
            if actionable { game.startResearch(r.id) }
        }) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    if r.warpCoreKey {
                        DiamondShape().fill(OrbitalGridPalette.ember).frame(width: 8, height: 8)
                    } else {
                        Circle().fill(r.branch.color).frame(width: 8, height: 8)
                    }
                    Text(r.name).font(OrbitalGridTypography.title(12))
                        .foregroundColor(OrbitalGridPalette.indigo)
                        .lineLimit(2)
                }
                Text(r.summary)
                    .font(OrbitalGridTypography.body(10))
                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.85))
                    .lineLimit(2)
                HStack(spacing: 6) {
                    Text("\(r.pointsRequired) pts")
                        .font(OrbitalGridTypography.mono(9))
                        .foregroundColor(OrbitalGridPalette.magenta)
                    Text("Lab \(r.labTierRequired)")
                        .font(OrbitalGridTypography.mono(9))
                        .foregroundColor(OrbitalGridPalette.modScience)
                    Spacer(minLength: 4)
                    statusChip(done: done, active: active, prereqs: prereqs, labOk: labOk)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(done ? OrbitalGridPalette.success.opacity(0.15) :
                          active ? OrbitalGridPalette.ember.opacity(0.12) :
                          actionable ? OrbitalGridPalette.panel : OrbitalGridPalette.bgDim.opacity(0.7))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(done ? OrbitalGridPalette.success :
                            active ? OrbitalGridPalette.ember :
                            actionable ? r.branch.color.opacity(0.6) : OrbitalGridPalette.hairline,
                            lineWidth: active ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func statusChip(done: Bool, active: Bool, prereqs: Bool, labOk: Bool) -> some View {
        let label: String = {
            if done { return "Done" }
            if active { return "Active" }
            if !prereqs { return "Locked" }
            if !labOk { return "Lab" }
            return "Start"
        }()
        let color: Color = {
            if done { return OrbitalGridPalette.success }
            if active { return OrbitalGridPalette.ember }
            if !prereqs || !labOk { return OrbitalGridPalette.graphite.opacity(0.6) }
            return OrbitalGridPalette.magenta
        }()
        return Text(label)
            .font(OrbitalGridTypography.chip(9))
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(ChipBackground(color: color))
            .foregroundColor(color)
    }
}
