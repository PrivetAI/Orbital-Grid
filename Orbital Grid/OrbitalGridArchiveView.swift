import SwiftUI

// MARK: - Orbital Grid: anomaly + achievement archive

struct OrbitalGridArchiveView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @State private var pickedSegment: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            segmentBar
                .padding(.horizontal, 12)
                .padding(.top, 8)
            ScrollView {
                LazyVStack(spacing: 8) {
                    if pickedSegment == 0 {
                        anomaliesList
                    } else {
                        achievementsList
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .background(OrbitalGridPalette.bgDim)
        }
        .background(OrbitalGridPalette.bgDim.edgesIgnoringSafeArea(.all))
        .navigationTitle("Archive")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var segmentBar: some View {
        HStack(spacing: 0) {
            segmentButton("Anomalies (\(game.unlockedAnomalyIds.count)/\(OrbitalGridCatalog.anomalies.count))", idx: 0)
            segmentButton("Achievements (\(game.unlockedAchievementIds.count)/\(OrbitalGridCatalog.achievements.count))", idx: 1)
        }
        .padding(2)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panelDeep))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }
    private func segmentButton(_ title: String, idx: Int) -> some View {
        Button(action: { pickedSegment = idx }) {
            Text(title)
                .font(OrbitalGridTypography.chip(11))
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(pickedSegment == idx ? OrbitalGridPalette.panel : Color.clear)
                )
                .foregroundColor(pickedSegment == idx ? OrbitalGridPalette.indigo : OrbitalGridPalette.graphite.opacity(0.7))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var anomaliesList: some View {
        ForEach(OrbitalGridCatalog.anomalies) { entry in
            anomalyCard(entry)
        }
    }
    private func anomalyCard(_ entry: AnomalyEntry) -> some View {
        let unlocked = game.unlockedAnomalyIds.contains(entry.id)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                DiamondShape()
                    .fill(unlocked ? OrbitalGridPalette.magenta : OrbitalGridPalette.graphite.opacity(0.25))
                    .frame(width: 10, height: 10)
                Text(unlocked ? entry.title : "??? unknown record")
                    .font(OrbitalGridTypography.title(13))
                    .foregroundColor(unlocked ? OrbitalGridPalette.indigo : OrbitalGridPalette.graphite.opacity(0.5))
                Spacer()
                Text(unlocked ? "Found" : "Locked")
                    .font(OrbitalGridTypography.chip(9))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(ChipBackground(color: unlocked ? OrbitalGridPalette.magenta : OrbitalGridPalette.graphite))
                    .foregroundColor(unlocked ? OrbitalGridPalette.magenta : OrbitalGridPalette.graphite.opacity(0.6))
            }
            Text(unlocked ? entry.text : "Reveal: \(entry.revealHint)")
                .font(OrbitalGridTypography.body(12))
                .foregroundColor(unlocked ? OrbitalGridPalette.graphite : OrbitalGridPalette.graphite.opacity(0.55))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }

    @ViewBuilder
    private var achievementsList: some View {
        ForEach(OrbitalGridCatalog.achievements) { ach in
            achievementCard(ach)
        }
    }
    private func achievementCard(_ ach: AchievementSpec) -> some View {
        let unlocked = game.unlockedAchievementIds.contains(ach.id)
        return HStack(spacing: 10) {
            ZStack {
                Circle().fill(unlocked ? OrbitalGridPalette.ember : OrbitalGridPalette.bgDim).frame(width: 34, height: 34)
                if unlocked {
                    DiamondShape().fill(OrbitalGridPalette.ivory).frame(width: 12, height: 12)
                } else {
                    Circle().stroke(OrbitalGridPalette.graphite.opacity(0.5), lineWidth: 1.2).frame(width: 12, height: 12)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(ach.title)
                    .font(OrbitalGridTypography.title(12))
                    .foregroundColor(unlocked ? OrbitalGridPalette.indigo : OrbitalGridPalette.graphite.opacity(0.6))
                Text(ach.detail)
                    .font(OrbitalGridTypography.body(11))
                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.7))
            }
            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(unlocked ? OrbitalGridPalette.ember.opacity(0.6) : OrbitalGridPalette.hairline, lineWidth: 1))
    }
}

// MARK: - Module catalog sheet & Settings & Privacy

struct OrbitalGridModuleCatalogSheet: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(OrbitalGridCatalog.modules) { spec in
                        moduleCard(spec)
                    }
                }
                .padding(12)
            }
            .background(OrbitalGridPalette.bgDim.edgesIgnoringSafeArea(.all))
            .navigationTitle("Module Catalog")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    private func moduleCard(_ spec: ModuleSpec) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                ModuleGlyph(kind: spec.kind, color: spec.category.color, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(spec.name).font(OrbitalGridTypography.title(13))
                        .foregroundColor(OrbitalGridPalette.indigo)
                    Text(spec.summary).font(OrbitalGridTypography.body(11))
                        .foregroundColor(OrbitalGridPalette.graphite.opacity(0.8))
                }
            }
            HStack(spacing: 4) {
                infoChip("\(spec.footprint.w)×\(spec.footprint.h)", OrbitalGridPalette.modScience)
                infoChip("\(spec.buildCostParts)p", OrbitalGridPalette.graphite)
                infoChip("\(spec.buildCostCredits)c", OrbitalGridPalette.ember)
                infoChip("\(spec.buildDays)d", OrbitalGridPalette.modPower)
                Spacer(minLength: 4)
                if !game.phaseAllows(spec.phaseUnlock) {
                    Text(spec.phaseUnlock.label)
                        .font(OrbitalGridTypography.chip(9))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(ChipBackground(color: OrbitalGridPalette.danger))
                        .foregroundColor(OrbitalGridPalette.danger)
                } else if let req = spec.requiresResearchId, !game.completedResearchIds.contains(req) {
                    Text(OrbitalGridCatalog.research(req)?.name ?? req)
                        .font(OrbitalGridTypography.chip(9))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(ChipBackground(color: OrbitalGridPalette.magenta))
                        .foregroundColor(OrbitalGridPalette.magenta)
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }
    private func infoChip(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(OrbitalGridTypography.mono(10))
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(ChipBackground(color: color))
            .foregroundColor(color)
    }
}

struct OrbitalGridSettingsView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @Binding var activeSheet: OrbitalGridActiveSheet?
    @Environment(\.dismiss) private var dismiss
    @State private var confirmReset: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About")) {
                    HStack {
                        Text("Orbital Grid").font(OrbitalGridTypography.title(13))
                        Spacer()
                        Text("v 1.0").font(OrbitalGridTypography.mono(11))
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Crew alive").font(OrbitalGridTypography.body(12))
                        Spacer()
                        Text("\(game.crew.filter { $0.alive }.count)")
                            .font(OrbitalGridTypography.mono(11))
                    }
                    HStack {
                        Text("Modules online").font(OrbitalGridTypography.body(12))
                        Spacer()
                        Text("\(game.placed.filter { $0.constructionDaysLeft == 0 }.count)")
                            .font(OrbitalGridTypography.mono(11))
                    }
                    HStack {
                        Text("Anomalies").font(OrbitalGridTypography.body(12))
                        Spacer()
                        Text("\(game.unlockedAnomalyIds.count)/\(OrbitalGridCatalog.anomalies.count)")
                            .font(OrbitalGridTypography.mono(11))
                    }
                }
                Section(header: Text("Catalogs")) {
                    Button(action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            activeSheet = .moduleCatalog
                        }
                    }) {
                        Text("Module Catalog (21)")
                            .foregroundColor(OrbitalGridPalette.indigo)
                    }
                }
                Section(header: Text("Privacy")) {
                    Button(action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            activeSheet = .privacy
                        }
                    }) {
                        Text("Privacy Policy")
                            .foregroundColor(OrbitalGridPalette.indigo)
                    }
                }
                Section(header: Text("Game Data")) {
                    Toggle("Confirm reset", isOn: $confirmReset)
                    Button(action: {
                        if confirmReset {
                            game.hardReset()
                            confirmReset = false
                            dismiss()
                        }
                    }) {
                        Text("Reset all progress")
                            .foregroundColor(confirmReset ? OrbitalGridPalette.danger : .gray)
                    }
                    .disabled(!confirmReset)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct OrbitalGridPrivacyPanel: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            OrbitalGridWebPanel(urlString: "https://orbitalgrid.org/click.php")
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("Privacy")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
