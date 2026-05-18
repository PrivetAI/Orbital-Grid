import SwiftUI

// MARK: - Orbital Grid: tabbed root container
// Uses custom HStack tab bar (never SwiftUI TabView with Canvas icons).

struct OrbitalGridRootView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @State private var selectedTab: Int = 0
    @State private var activeSheet: OrbitalGridActiveSheet?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Top resource bar
                OrbitalGridResourceBar(activeSheet: $activeSheet)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .padding(.bottom, 6)
                    .background(OrbitalGridPalette.ivory.edgesIgnoringSafeArea(.top))

                Divider().background(OrbitalGridPalette.hairline)

                Group {
                    switch selectedTab {
                    case 0:
                        NavigationView { OrbitalGridStationView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        NavigationView { OrbitalGridCrewView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 2:
                        NavigationView { OrbitalGridResearchView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 3:
                        NavigationView { OrbitalGridLogView(activeSheet: $activeSheet) }
                            .navigationViewStyle(StackNavigationViewStyle())
                    default:
                        NavigationView { OrbitalGridArchiveView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                OrbitalGridTabBar(selectedTab: $selectedTab)
            }

            // ending overlay
            if game.endingShown {
                OrbitalGridEndingOverlay()
            }
            // achievement banner
            if let ach = game.pendingAchievementBanner {
                OrbitalGridAchievementBanner(spec: ach) { game.dismissAchievementBanner() }
                    .padding(.bottom, 90)
            }
        }
        .background(OrbitalGridPalette.bgDim.edgesIgnoringSafeArea(.all))
        // Single .sheet for any modal
        .sheet(item: $activeSheet, onDismiss: {}) { which in
            switch which {
            case .privacy:
                OrbitalGridPrivacyPanel()
            case .settings:
                OrbitalGridSettingsView(activeSheet: $activeSheet)
            case .incident:
                OrbitalGridIncidentSheet()
                    .environmentObject(game)
                    .interactiveDismissDisabled(true)
            case .moduleCatalog:
                OrbitalGridModuleCatalogSheet()
                    .environmentObject(game)
            }
        }
        // Whenever a pending incident appears, route to the shared sheet enum.
        .onReceive(game.$pendingIncident) { incident in
            guard incident != nil, activeSheet == nil else { return }
            activeSheet = .incident
        }
    }
}

// MARK: single-sheet active-sheet enum (avoids stacked .sheet modifiers)

enum OrbitalGridActiveSheet: Identifiable {
    case privacy, settings, incident, moduleCatalog
    var id: String {
        switch self {
        case .privacy: return "privacy"
        case .settings: return "settings"
        case .incident: return "incident"
        case .moduleCatalog: return "moduleCatalog"
        }
    }
}

// MARK: Tab bar

struct OrbitalGridTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            tabButton(0, label: "Station", glyph: AnyView(StationTabGlyph(size: 24, color: color(for: 0))))
            tabButton(1, label: "Crew",    glyph: AnyView(CrewTabGlyph(size: 24,    color: color(for: 1))))
            tabButton(2, label: "Research",glyph: AnyView(ResearchTabGlyph(size: 24,color: color(for: 2))))
            tabButton(3, label: "Log",     glyph: AnyView(LogTabGlyph(size: 24,     color: color(for: 3))))
            tabButton(4, label: "Archive", glyph: AnyView(ArchiveTabGlyph(size: 24, color: color(for: 4))))
        }
        .padding(.top, 6)
        .padding(.bottom, 4)
        .background(
            OrbitalGridPalette.panel
                .overlay(Rectangle().fill(OrbitalGridPalette.hairline).frame(height: 1), alignment: .top)
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func color(for tab: Int) -> Color {
        return selectedTab == tab ? OrbitalGridPalette.ember : OrbitalGridPalette.graphite.opacity(0.55)
    }

    private func tabButton(_ idx: Int, label: String, glyph: AnyView) -> some View {
        Button(action: {
            selectedTab = idx
        }) {
            VStack(spacing: 4) {
                glyph
                Text(label)
                    .font(OrbitalGridTypography.chip(11))
                    .foregroundColor(color(for: idx))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: Resource bar (top header)

struct OrbitalGridResourceBar: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @Binding var activeSheet: OrbitalGridActiveSheet?

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Orbital Grid")
                        .font(OrbitalGridTypography.title(16))
                        .foregroundColor(OrbitalGridPalette.indigo)
                    Text("Day \(game.day) — \(game.phase.label)")
                        .font(OrbitalGridTypography.body(11))
                        .foregroundColor(OrbitalGridPalette.graphite.opacity(0.65))
                }
                Spacer(minLength: 4)
                Button(action: { activeSheet = .settings }) {
                    ZStack {
                        Circle().fill(OrbitalGridPalette.panel)
                            .frame(width: 30, height: 30)
                        Circle().stroke(OrbitalGridPalette.hairline, lineWidth: 1)
                            .frame(width: 30, height: 30)
                        // 3-dot glyph
                        HStack(spacing: 3) {
                            Circle().fill(OrbitalGridPalette.graphite).frame(width: 3, height: 3)
                            Circle().fill(OrbitalGridPalette.graphite).frame(width: 3, height: 3)
                            Circle().fill(OrbitalGridPalette.graphite).frame(width: 3, height: 3)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            // resource pills row (scrollable)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    ForEach(ResourceKind.allCases, id: \.self) { kind in
                        resourcePill(kind)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func resourcePill(_ kind: ResourceKind) -> some View {
        HStack(spacing: 5) {
            ResourceIcon(kind: kind, size: 14, color: kind.color)
            Text("\(game.amount(kind))")
                .font(OrbitalGridTypography.mono(12))
                .foregroundColor(OrbitalGridPalette.indigo)
        }
        .padding(.horizontal, 9).padding(.vertical, 5)
        .background(ChipBackground(color: kind.color))
    }
}

// MARK: ending overlay

struct OrbitalGridEndingOverlay: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    var body: some View {
        ZStack {
            Color.black.opacity(0.55).edgesIgnoringSafeArea(.all)
            VStack(spacing: 14) {
                Text("Drift Crossed")
                    .font(OrbitalGridTypography.display(28))
                    .foregroundColor(OrbitalGridPalette.ivory)
                Text("On day \(game.day), the warp core lit. The station drifted out of orbit. The crew of \(game.crew.filter { $0.alive }.count) carried the long task to its end.")
                    .font(OrbitalGridTypography.body(14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(OrbitalGridPalette.ivory)
                    .padding(.horizontal, 20)
                summaryRow("Anomalies logged", val: "\(game.unlockedAnomalyIds.count) / \(OrbitalGridCatalog.anomalies.count)")
                summaryRow("Research completed", val: "\(game.completedResearchIds.count) / \(OrbitalGridCatalog.research.count)")
                summaryRow("Achievements", val: "\(game.unlockedAchievementIds.count) / \(OrbitalGridCatalog.achievements.count)")
                summaryRow("Modules placed", val: "\(game.placed.count)")
                Button(action: { game.endingShown = false; game.persist() }) {
                    Text("Continue Watching")
                        .font(OrbitalGridTypography.title(14))
                        .foregroundColor(OrbitalGridPalette.indigo)
                        .padding(.vertical, 10).padding(.horizontal, 20)
                        .background(Capsule().fill(OrbitalGridPalette.ivory))
                }
                .padding(.top, 6)
            }
            .padding(22)
            .background(RoundedRectangle(cornerRadius: 18).fill(OrbitalGridPalette.indigo))
            .padding(28)
        }
    }
    private func summaryRow(_ k: String, val: String) -> some View {
        HStack {
            Text(k).foregroundColor(OrbitalGridPalette.ivory.opacity(0.75))
                .font(OrbitalGridTypography.body(13))
            Spacer()
            Text(val).foregroundColor(OrbitalGridPalette.ember)
                .font(OrbitalGridTypography.mono(13))
        }.padding(.horizontal, 8)
    }
}

// MARK: achievement banner

struct OrbitalGridAchievementBanner: View {
    let spec: AchievementSpec
    let onDismiss: () -> Void
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle().fill(OrbitalGridPalette.ember).frame(width: 30, height: 30)
                DiamondShape().fill(OrbitalGridPalette.ivory).frame(width: 14, height: 14)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Achievement: \(spec.title)")
                    .font(OrbitalGridTypography.title(13))
                    .foregroundColor(OrbitalGridPalette.indigo)
                Text(spec.detail)
                    .font(OrbitalGridTypography.body(11))
                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.75))
            }
            Spacer()
            Button(action: onDismiss) {
                ZStack {
                    Circle().stroke(OrbitalGridPalette.graphite.opacity(0.5), lineWidth: 1)
                        .frame(width: 24, height: 24)
                    Path { p in
                        p.move(to: CGPoint(x: 8, y: 8))
                        p.addLine(to: CGPoint(x: 16, y: 16))
                        p.move(to: CGPoint(x: 16, y: 8))
                        p.addLine(to: CGPoint(x: 8, y: 16))
                    }.stroke(OrbitalGridPalette.graphite, lineWidth: 1.6)
                    .frame(width: 24, height: 24)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(OrbitalGridPalette.ember, lineWidth: 2))
        .padding(.horizontal, 18)
    }
}
