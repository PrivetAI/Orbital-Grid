import SwiftUI

// MARK: - Orbital Grid: log + advance day + incident sheet

struct OrbitalGridLogView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @Binding var activeSheet: OrbitalGridActiveSheet?

    var body: some View {
        VStack(spacing: 0) {
            advanceDayBar
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, game.lastAdvanceSummary == nil ? 10 : 6)
            if let summary = game.lastAdvanceSummary {
                advanceSummaryCard(summary)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
            }
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(game.logEntries.reversed())) { entry in
                        logRow(entry)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .background(OrbitalGridPalette.bgDim)
        }
        .background(OrbitalGridPalette.bgDim.edgesIgnoringSafeArea(.all))
        .navigationTitle("Log")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var advanceDayBar: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Day \(game.day) — \(game.phase.label)")
                    .font(OrbitalGridTypography.title(15))
                    .foregroundColor(OrbitalGridPalette.indigo)
                if game.pendingIncident != nil {
                    Text("Resolve the pending incident first.")
                        .font(OrbitalGridTypography.body(11))
                        .foregroundColor(OrbitalGridPalette.danger)
                } else {
                    Text("Roll dawn, run a tick of crew + research + incidents.")
                        .font(OrbitalGridTypography.body(11))
                        .foregroundColor(OrbitalGridPalette.graphite.opacity(0.7))
                }
            }
            Spacer(minLength: 6)
            Button(action: {
                if game.pendingIncident != nil {
                    activeSheet = .incident
                } else {
                    game.advanceDay()
                    if game.pendingIncident != nil { activeSheet = .incident }
                }
            }) {
                HStack(spacing: 6) {
                    ArrowRightShape().stroke(OrbitalGridPalette.ivory, lineWidth: 2)
                        .frame(width: 18, height: 18)
                    Text(game.pendingIncident == nil ? "Advance Day" : "Open Incident")
                        .font(OrbitalGridTypography.title(13))
                        .foregroundColor(OrbitalGridPalette.ivory)
                }
                .padding(.horizontal, 14).padding(.vertical, 9)
                .background(Capsule().fill(OrbitalGridPalette.indigo))
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }

    // F-Major-4: compact summary card shown below the Advance button after each tick.
    private func advanceSummaryCard(_ summary: OrbitalGridAdvanceSummary) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Day \(summary.dayEnded) ended")
                .font(OrbitalGridTypography.title(12))
                .foregroundColor(OrbitalGridPalette.indigo)
            Text(summary.deltasLine)
                .font(OrbitalGridTypography.mono(11))
                .foregroundColor(OrbitalGridPalette.graphite)
            Text(summary.incidentLine)
                .font(OrbitalGridTypography.body(11))
                .foregroundColor(OrbitalGridPalette.graphite.opacity(0.8))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(OrbitalGridPalette.teal.opacity(0.5), lineWidth: 1))
    }

    private func logRow(_ entry: LogEntry) -> some View {
        HStack(alignment: .top, spacing: 8) {
            kindDot(entry.kind)
                .frame(width: 14)
                .padding(.top, 4)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("D\(entry.day)")
                        .font(OrbitalGridTypography.mono(10))
                        .foregroundColor(OrbitalGridPalette.graphite.opacity(0.6))
                    Text(entry.title)
                        .font(OrbitalGridTypography.title(12))
                        .foregroundColor(OrbitalGridPalette.indigo)
                }
                Text(entry.detail)
                    .font(OrbitalGridTypography.body(11))
                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.85))
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }
    private func kindDot(_ kind: AdvanceEventKind) -> some View {
        let color: Color = {
            switch kind {
            case .dayStart: return OrbitalGridPalette.teal
            case .incident: return OrbitalGridPalette.ember
            case .resourceShortfall: return OrbitalGridPalette.danger
            case .moduleCompleted: return OrbitalGridPalette.success
            case .achievement: return OrbitalGridPalette.modPower
            case .anomaly: return OrbitalGridPalette.magenta
            case .milestone: return OrbitalGridPalette.modScience
            }
        }()
        return Circle().fill(color).frame(width: 10, height: 10)
    }
}

// MARK: - Incident sheet (.sheet content)

struct OrbitalGridIncidentSheet: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if let inc = game.pendingIncident {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        DiamondShape().fill(inc.category.color).frame(width: 12, height: 12)
                        Text(inc.category.label.uppercased())
                            .font(OrbitalGridTypography.chip(11))
                            .foregroundColor(inc.category.color)
                        Spacer()
                        Text("Day \(game.day)").font(OrbitalGridTypography.mono(11))
                            .foregroundColor(OrbitalGridPalette.graphite.opacity(0.7))
                    }
                    Text(inc.title)
                        .font(OrbitalGridTypography.display(20))
                        .foregroundColor(OrbitalGridPalette.indigo)

                    if let cm = game.pendingIncidentCrew {
                        HStack(spacing: 10) {
                            CrewPortrait(seed: cm.portraitSeed, role: cm.role, size: 56,
                                         outlineColor: OrbitalGridPalette.indigo, fillColor: inc.category.color)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(cm.name)
                                    .font(OrbitalGridTypography.title(14))
                                    .foregroundColor(OrbitalGridPalette.indigo)
                                Text(cm.role.display)
                                    .font(OrbitalGridTypography.body(11))
                                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.7))
                                HStack(spacing: 4) {
                                    ForEach(cm.traits, id: \.self) { tid in
                                        Text(OrbitalGridCatalog.trait(tid).name)
                                            .font(OrbitalGridTypography.chip(9))
                                            .padding(.horizontal, 5).padding(.vertical, 1.5)
                                            .background(ChipBackground(color: OrbitalGridPalette.magenta))
                                            .foregroundColor(OrbitalGridPalette.magenta)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(OrbitalGridPalette.panel))
                    }

                    Text(inc.body)
                        .font(OrbitalGridTypography.body(14))
                        .foregroundColor(OrbitalGridPalette.graphite)

                    Divider().background(OrbitalGridPalette.hairline)

                    Text("Choose").font(OrbitalGridTypography.title(14))
                        .foregroundColor(OrbitalGridPalette.indigo)

                    ForEach(Array(inc.choices.enumerated()), id: \.offset) { _, choice in
                        Button(action: {
                            game.resolveIncident(choice: choice)
                            dismiss()
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(choice.label)
                                        .font(OrbitalGridTypography.title(13))
                                        .foregroundColor(OrbitalGridPalette.indigo)
                                    Spacer()
                                    Text(choice.costPreview)
                                        .font(OrbitalGridTypography.mono(11))
                                        .foregroundColor(OrbitalGridPalette.ember)
                                }
                                Text(choice.detail)
                                    .font(OrbitalGridTypography.body(11))
                                    .foregroundColor(OrbitalGridPalette.graphite.opacity(0.85))
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 12).fill(OrbitalGridPalette.panel))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(inc.category.color.opacity(0.5), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
            .background(OrbitalGridPalette.ivory.edgesIgnoringSafeArea(.all))
        } else {
            VStack {
                Text("No active incident.")
                    .font(OrbitalGridTypography.body(14))
                    .foregroundColor(OrbitalGridPalette.graphite)
                Button(action: { dismiss() }) {
                    Text("Close").padding(.horizontal, 14).padding(.vertical, 7)
                        .background(Capsule().fill(OrbitalGridPalette.indigo))
                        .foregroundColor(OrbitalGridPalette.ivory)
                }
            }
            .padding(28)
            .background(OrbitalGridPalette.ivory)
        }
    }
}
