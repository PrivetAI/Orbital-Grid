import SwiftUI

// MARK: - Orbital Grid: crew browser + assignment

struct OrbitalGridCrewView: View {
    @EnvironmentObject var game: OrbitalGridGameStore
    @State private var detailCrewId: UUID?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(game.crew) { cm in
                    Button(action: {
                        detailCrewId = (detailCrewId == cm.id) ? nil : cm.id
                    }) {
                        crewCard(cm)
                    }
                    .buttonStyle(.plain)
                    if detailCrewId == cm.id {
                        crewDetail(for: cm)
                            .transition(.opacity)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(OrbitalGridPalette.bgDim.edgesIgnoringSafeArea(.all))
        .navigationTitle("Crew")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func crewCard(_ cm: CrewMember) -> some View {
        HStack(spacing: 10) {
            CrewPortrait(seed: cm.portraitSeed, role: cm.role, size: 60,
                         outlineColor: OrbitalGridPalette.indigo, fillColor: OrbitalGridPalette.teal)
                .frame(width: 60, height: 60)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(cm.name)
                        .font(OrbitalGridTypography.title(15))
                        .foregroundColor(OrbitalGridPalette.indigo)
                    Text(cm.role.display)
                        .font(OrbitalGridTypography.chip(10))
                        .padding(.horizontal, 7).padding(.vertical, 2)
                        .background(ChipBackground(color: OrbitalGridPalette.modScience))
                        .foregroundColor(OrbitalGridPalette.modScience)
                }
                HStack(spacing: 6) {
                    statRow("SK", cm.skill, OrbitalGridPalette.modScience)
                    statRow("MO", cm.morale, OrbitalGridPalette.success)
                    statRow("ST", cm.stress, OrbitalGridPalette.danger)
                    statRow("FT", cm.fatigue, OrbitalGridPalette.ember)
                }
                HStack(spacing: 4) {
                    Text(cm.dutyAssignment.label)
                        .font(OrbitalGridTypography.body(11))
                        .foregroundColor(OrbitalGridPalette.graphite)
                    if let mid = cm.assignedModuleSlotId,
                       let mod = game.placed.first(where: { $0.id.uuidString == mid }) {
                        Text("• \(OrbitalGridCatalog.module(mod.kind).name)")
                            .font(OrbitalGridTypography.body(10))
                            .foregroundColor(OrbitalGridPalette.graphite.opacity(0.65))
                    }
                }
            }
            Spacer(minLength: 4)
            VStack(spacing: 3) {
                ForEach(cm.traits, id: \.self) { tid in
                    let t = OrbitalGridCatalog.trait(tid)
                    Text(t.name)
                        .font(OrbitalGridTypography.chip(9))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(ChipBackground(color: OrbitalGridPalette.magenta))
                        .foregroundColor(OrbitalGridPalette.magenta)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14).fill(OrbitalGridPalette.panel))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(OrbitalGridPalette.hairline, lineWidth: 1))
    }

    private func statRow(_ label: String, _ val: Int, _ color: Color) -> some View {
        HStack(spacing: 3) {
            Text(label).font(OrbitalGridTypography.chip(9))
                .foregroundColor(color)
            Text("\(val)").font(OrbitalGridTypography.mono(11))
                .foregroundColor(OrbitalGridPalette.indigo)
            // mini bar
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.18)).frame(width: 36, height: 6)
                Capsule().fill(color).frame(width: CGFloat(val) / 100 * 36, height: 6)
            }
        }
    }

    @ViewBuilder
    private func crewDetail(for cm: CrewMember) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Traits")
                .font(OrbitalGridTypography.title(13)).foregroundColor(OrbitalGridPalette.indigo)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(cm.traits, id: \.self) { tid in
                    let t = OrbitalGridCatalog.trait(tid)
                    HStack(alignment: .top, spacing: 6) {
                        Circle().fill(OrbitalGridPalette.magenta).frame(width: 6, height: 6)
                            .padding(.top, 5)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(t.name)
                                .font(OrbitalGridTypography.chip(11))
                                .foregroundColor(OrbitalGridPalette.indigo)
                            Text(t.effect)
                                .font(OrbitalGridTypography.body(11))
                                .foregroundColor(OrbitalGridPalette.graphite.opacity(0.85))
                        }
                    }
                }
            }
            Divider().background(OrbitalGridPalette.hairline)

            Text("Duty Assignment")
                .font(OrbitalGridTypography.title(13)).foregroundColor(OrbitalGridPalette.indigo)

            HStack(spacing: 6) {
                ForEach(DutyKind.allCases, id: \.self) { duty in
                    Button(action: { game.setDuty(duty, for: cm.id) }) {
                        Text(duty.label)
                            .font(OrbitalGridTypography.chip(11))
                            .padding(.horizontal, 9).padding(.vertical, 5)
                            .background(
                                Capsule().fill(cm.dutyAssignment == duty
                                               ? OrbitalGridPalette.ember.opacity(0.15)
                                               : OrbitalGridPalette.panel)
                            )
                            .overlay(
                                Capsule().stroke(cm.dutyAssignment == duty
                                                 ? OrbitalGridPalette.ember
                                                 : OrbitalGridPalette.hairline,
                                                 lineWidth: cm.dutyAssignment == duty ? 2 : 1)
                            )
                            .foregroundColor(cm.dutyAssignment == duty ? OrbitalGridPalette.ember : OrbitalGridPalette.indigo)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 4)

            if cm.dutyAssignment == .work {
                Text("Assign to module")
                    .font(OrbitalGridTypography.title(13)).foregroundColor(OrbitalGridPalette.indigo)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // unassign option
                        Button(action: { game.assignCrew(cm.id, toModule: nil) }) {
                            VStack(spacing: 4) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).fill(OrbitalGridPalette.bgDim)
                                        .frame(width: 60, height: 60)
                                    ChevronUpShape().stroke(OrbitalGridPalette.graphite, lineWidth: 2)
                                        .frame(width: 22, height: 22)
                                }
                                Text("Unassign")
                                    .font(OrbitalGridTypography.chip(10))
                                    .foregroundColor(OrbitalGridPalette.graphite)
                            }
                        }
                        .buttonStyle(.plain)

                        ForEach(game.placed) { mod in
                            let spec = OrbitalGridCatalog.module(mod.kind)
                            let slotsLeft = spec.crewSlots - mod.assignedCrewIds.count
                            let constructionLeft = mod.constructionDaysLeft
                            let canAssign = slotsLeft > 0 && constructionLeft == 0 && spec.crewSlots > 0
                            let isCurrent = mod.id.uuidString == cm.assignedModuleSlotId
                            Button(action: {
                                if canAssign || isCurrent {
                                    game.assignCrew(cm.id, toModule: mod.id)
                                }
                            }) {
                                VStack(spacing: 4) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(spec.category.color.opacity(canAssign || isCurrent ? 0.15 : 0.05))
                                            .frame(width: 60, height: 60)
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(isCurrent ? OrbitalGridPalette.ember : spec.category.color.opacity(0.5),
                                                    lineWidth: isCurrent ? 2 : 1)
                                            .frame(width: 60, height: 60)
                                        ModuleGlyph(kind: mod.kind, color: spec.category.color, size: 36)
                                    }
                                    Text(spec.name)
                                        .font(OrbitalGridTypography.chip(9))
                                        .foregroundColor(OrbitalGridPalette.indigo)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .frame(width: 70)
                                    Text("\(spec.crewSlots - slotsLeft)/\(spec.crewSlots)")
                                        .font(OrbitalGridTypography.mono(9))
                                        .foregroundColor(OrbitalGridPalette.graphite.opacity(0.7))
                                }
                            }
                            .buttonStyle(.plain)
                            .opacity(canAssign || isCurrent ? 1.0 : 0.5)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(OrbitalGridPalette.panelDeep))
    }
}
