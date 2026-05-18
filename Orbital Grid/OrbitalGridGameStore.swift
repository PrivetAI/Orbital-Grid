import Foundation
import SwiftUI

// MARK: - Orbital Grid: state store
// UserDefaults key prefix `og.`

@MainActor
final class OrbitalGridGameStore: ObservableObject {
    static let gridW = 12
    static let gridH = 12
    static let saveKey = "og.state.v1"

    // MARK: Published state
    @Published var day: Int
    @Published var phase: CampaignPhase
    @Published var resources: [String: Int]
    @Published var crew: [CrewMember]
    @Published var placed: [PlacedModule]
    @Published var researchPoints: Int
    @Published var completedResearchIds: [String]
    @Published var activeResearchId: String?
    @Published var assignedScientistIds: [UUID] = []   // session-only research assignment
    @Published var unlockedAnomalyIds: [String]
    @Published var unlockedAchievementIds: [String]
    @Published var warpCoreProgressDays: Int
    @Published var endingShown: Bool
    // Permanent flag: ending has already been triggered once. Prevents re-trigger after the
    // player dismisses the overlay (F-C-1). `endingShown` controls only the overlay visibility.
    @Published var endingTriggered: Bool
    @Published var logEntries: [LogEntry]
    @Published var lastIncidentDay: Int
    @Published var fatalitiesTotal: Int
    @Published var lastFatalityDay: Int
    @Published var negativeNetTicks: Int
    // F-H-3: dedicated counter for resolved trader-like opportunity incidents.
    // Avoids log-string sniffing race; incremented inside resolveIncident before the achievement check.
    @Published var tradeResolveCount: Int
    // Persisted counter for resolved technical-category incidents.
    // Replaces a logEntries scan which lost old crises once the 250-entry log cap evicted them.
    @Published var technicalResolveCount: Int
    // counters for one-shot day-threshold achievements (M-1/L-4 defensive)
    @Published var awardedStartupWeek: Bool = false
    @Published var awardedMidRun: Bool = false
    // Parts delivered to the warp core during the 30-day final countdown.
    // Used in place of held-stock to gate the endgame so the build cost + delivery is reachable.
    @Published var warpCoreDeliveredParts: Int = 0

    // Snapshot of the most recent advanceDay() resource deltas, for the post-advance summary card.
    @Published var lastAdvanceSummary: OrbitalGridAdvanceSummary?

    // session state
    @Published var pendingIncident: IncidentSpec?
    @Published var pendingIncidentCrew: CrewMember?
    @Published var pendingAchievementBanner: AchievementSpec?
    @Published var selectedPaletteModule: ModuleKind?
    @Published var selectedTile: GridPoint?

    init() {
        if let saved = Self.loadSaved() {
            self.day = saved.day
            self.phase = saved.phase
            self.resources = saved.resources
            self.crew = saved.crew
            self.placed = saved.placed
            self.researchPoints = saved.researchPoints
            self.completedResearchIds = saved.completedResearchIds
            self.activeResearchId = saved.activeResearchId
            self.unlockedAnomalyIds = saved.unlockedAnomalyIds
            self.unlockedAchievementIds = saved.unlockedAchievementIds
            self.warpCoreProgressDays = saved.warpCoreProgressDays
            self.endingShown = saved.endingShown
            self.endingTriggered = saved.endingTriggered
            self.logEntries = saved.logEntries
            self.lastIncidentDay = saved.lastIncidentDay
            self.fatalitiesTotal = saved.fatalitiesTotal
            self.lastFatalityDay = saved.lastFatalityDay
            self.negativeNetTicks = saved.negativeNetTicks
            self.tradeResolveCount = saved.tradeResolveCount
            self.technicalResolveCount = saved.technicalResolveCount
            self.warpCoreDeliveredParts = saved.warpCoreDeliveredParts
            // these stay in-memory only; treat as awarded if the achievement is already unlocked
            self.awardedStartupWeek = saved.unlockedAchievementIds.contains("ach.startupWeek")
            self.awardedMidRun = saved.unlockedAchievementIds.contains("ach.midRun")
        } else {
            self.day = 1
            self.phase = .pioneering
            self.resources = OrbitalGridSave.defaultStartingResources
            self.crew = Self.generateStartingCrew()
            self.placed = []
            self.researchPoints = 0
            self.completedResearchIds = []
            self.activeResearchId = nil
            self.unlockedAnomalyIds = []
            self.unlockedAchievementIds = []
            self.warpCoreProgressDays = 0
            self.endingShown = false
            self.endingTriggered = false
            self.logEntries = [
                LogEntry(id: UUID(), day: 1, kind: .dayStart,
                         title: "Welcome to the Drift",
                         detail: "Your station has cleared its tether. Build, assign, advance.")
            ]
            self.lastIncidentDay = 0
            self.fatalitiesTotal = 0
            self.lastFatalityDay = 0
            self.negativeNetTicks = 0
            self.tradeResolveCount = 0
            self.technicalResolveCount = 0
            self.warpCoreDeliveredParts = 0
            self.awardedStartupWeek = false
            self.awardedMidRun = false
            persist()
        }
    }

    // MARK: Static helpers

    private static func loadSaved() -> OrbitalGridSave? {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return nil }
        // backward-compat: decodeIfPresent semantics via try?
        return try? JSONDecoder().decode(OrbitalGridSave.self, from: data)
    }

    private static let startingCrewNames: [(String, CrewRole)] = [
        ("Iris Halversen", .captain),
        ("Petriv Olano", .engineer),
        ("Eun Aoki", .medic),
        ("Tomas Ostrov", .scientist),
        ("Hana Sirko", .pilot),
        ("Mihai Boran", .botanist),
        ("Rosa Klem", .cook),
        ("Tariq Vinde", .comms),
        ("Lin Berask", .security),
        ("Yuri Caine", .maintenance),
        ("Maya Doroe", .researcher),
        ("Ben Kazu", .quartermaster),
    ]

    static func generateStartingCrew() -> [CrewMember] {
        var rng = SystemRandomNumberGenerator()
        let traits = TraitId.allCases
        return startingCrewNames.enumerated().map { idx, pair in
            let t1 = traits.randomElement(using: &rng) ?? .loyal
            var t2 = traits.randomElement(using: &rng) ?? .stoic
            if t2 == t1 { t2 = traits.first(where: { $0 != t1 }) ?? .stoic }
            return CrewMember(
                id: UUID(),
                name: pair.0,
                role: pair.1,
                portraitSeed: idx + 1,
                traits: [t1, t2],
                skill: Int.random(in: 35...65, using: &rng),
                morale: Int.random(in: 55...80, using: &rng),
                stress: Int.random(in: 10...25, using: &rng),
                fatigue: Int.random(in: 8...20, using: &rng),
                dutyAssignment: .rest,
                assignedModuleSlotId: nil,
                alive: true
            )
        }
    }

    // MARK: Persistence

    func persist() {
        let save = OrbitalGridSave(
            day: day, phase: phase, resources: resources, crew: crew, placed: placed,
            researchPoints: researchPoints, completedResearchIds: completedResearchIds,
            activeResearchId: activeResearchId, unlockedAnomalyIds: unlockedAnomalyIds,
            unlockedAchievementIds: unlockedAchievementIds, warpCoreProgressDays: warpCoreProgressDays,
            endingShown: endingShown, logEntries: logEntries,
            lastIncidentDay: lastIncidentDay, fatalitiesTotal: fatalitiesTotal,
            lastFatalityDay: lastFatalityDay, negativeNetTicks: negativeNetTicks,
            endingTriggered: endingTriggered,
            tradeResolveCount: tradeResolveCount,
            technicalResolveCount: technicalResolveCount,
            warpCoreDeliveredParts: warpCoreDeliveredParts
        )
        if let data = try? JSONEncoder().encode(save) {
            UserDefaults.standard.set(data, forKey: Self.saveKey)
        }
    }

    func hardReset() {
        UserDefaults.standard.removeObject(forKey: Self.saveKey)
        day = 1
        phase = .pioneering
        resources = OrbitalGridSave.defaultStartingResources
        crew = Self.generateStartingCrew()
        placed = []
        researchPoints = 0
        completedResearchIds = []
        activeResearchId = nil
        unlockedAnomalyIds = []
        unlockedAchievementIds = []
        warpCoreProgressDays = 0
        endingShown = false
        endingTriggered = false
        logEntries = [
            LogEntry(id: UUID(), day: 1, kind: .dayStart,
                     title: "Welcome to the Drift",
                     detail: "Your station has cleared its tether. Build, assign, advance.")
        ]
        lastIncidentDay = 0
        fatalitiesTotal = 0
        lastFatalityDay = 0
        negativeNetTicks = 0
        tradeResolveCount = 0
        technicalResolveCount = 0
        warpCoreDeliveredParts = 0
        lastAdvanceSummary = nil
        awardedStartupWeek = false
        awardedMidRun = false
        pendingIncident = nil
        pendingIncidentCrew = nil
        pendingAchievementBanner = nil
        selectedPaletteModule = nil
        selectedTile = nil
        assignedScientistIds = []
        persist()
    }

    // MARK: Resources

    func amount(_ kind: ResourceKind) -> Int {
        return resources[kind.rawValue] ?? 0
    }

    func adjust(_ kind: ResourceKind, by delta: Int) {
        let cap: Int = {
            switch kind {
            case .credits: return 99999
            case .parts: return 99999
            case .fuel: return 600
            default: return 9999
            }
        }()
        let floor: Int = 0
        var v = (resources[kind.rawValue] ?? 0) + delta
        if v < floor { v = floor }
        if v > cap { v = cap }
        resources[kind.rawValue] = v
    }

    // MARK: Phase helpers

    private func recomputePhase() {
        let oldPhase = phase
        var next: CampaignPhase = .pioneering
        for ph in CampaignPhase.allCases where day >= ph.startDay {
            next = ph
        }
        if next != oldPhase {
            phase = next
            logEntries.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                       title: "Phase: \(next.label)",
                                       detail: "The station enters a new chapter."))
            if next == .preWarp { unlockAchievement("ach.preWarp") }
        }
    }

    // MARK: Tile placement

    func canPlace(kind: ModuleKind, at origin: GridPoint) -> (Bool, String?) {
        let spec = OrbitalGridCatalog.module(kind)

        // phase unlock
        if !phaseAllows(spec.phaseUnlock) {
            return (false, "Locked until \(spec.phaseUnlock.label).")
        }
        if let req = spec.requiresResearchId, !completedResearchIds.contains(req) {
            let r = OrbitalGridCatalog.research(req)
            return (false, "Requires research: \(r?.name ?? req).")
        }

        // bounds
        if origin.x < 0 || origin.y < 0 { return (false, "Out of bounds.") }
        if origin.x + spec.footprint.w > Self.gridW { return (false, "Doesn't fit.") }
        if origin.y + spec.footprint.h > Self.gridH { return (false, "Doesn't fit.") }

        // collision
        for placedMod in placed {
            let otherSpec = OrbitalGridCatalog.module(placedMod.kind)
            if rectsOverlap(a1: origin, sz1: spec.footprint, a2: placedMod.origin, sz2: otherSpec.footprint) {
                return (false, "Cell occupied.")
            }
        }

        // adjacency: must border edge
        if spec.mustBorderEdge {
            let bordersEdge =
                origin.x == 0 ||
                origin.y == 0 ||
                origin.x + spec.footprint.w == Self.gridW ||
                origin.y + spec.footprint.h == Self.gridH
            if !bordersEdge { return (false, "Must mount on hull edge.") }
        }

        // adjacency: needs adjacent power
        if spec.needsAdjacentPower {
            let powerKinds: Set<ModuleKind> = [.powerCell, .solarArray]
            if !hasAdjacent(origin: origin, footprint: spec.footprint, anyKindIn: powerKinds) {
                return (false, "Needs adjacent power module.")
            }
        }
        if spec.needsAdjacentLifeSupport {
            if !hasAdjacent(origin: origin, footprint: spec.footprint, anyKindIn: [.lifeSupport]) {
                return (false, "Needs adjacent life support.")
            }
        }

        // build cost
        if amount(.parts) < spec.buildCostParts {
            return (false, "Need \(spec.buildCostParts) parts.")
        }
        if amount(.credits) < spec.buildCostCredits {
            return (false, "Need \(spec.buildCostCredits) credits.")
        }
        return (true, nil)
    }

    func place(kind: ModuleKind, at origin: GridPoint) {
        let check = canPlace(kind: kind, at: origin)
        guard check.0 else { return }
        let spec = OrbitalGridCatalog.module(kind)
        adjust(.parts, by: -spec.buildCostParts)
        adjust(.credits, by: -spec.buildCostCredits)
        // H-6: r.eng.welds — module construction days -1 (min 1, never reduce the warp core's 30-day clock below spec)
        var buildDays = spec.buildDays
        if completedResearchIds.contains("r.eng.welds") && kind != .warpCore {
            buildDays = max(1, buildDays - 1)
        }
        let mod = PlacedModule(
            id: UUID(),
            kind: kind,
            origin: origin,
            footprint: spec.footprint,
            constructionDaysLeft: buildDays,
            assignedCrewIds: []
        )
        placed.append(mod)
        if kind == .habSmall || kind == .habLarge {
            unlockAchievement("ach.firstHab")
        }
        if kind == .labBasic { unlockAchievement("ach.firstLab") }
        if kind == .labAdvanced { unlockAchievement("ach.firstAdvLab") }
        if kind == .warpCore {
            unlockAchievement("ach.warpStarted")
        }
        // milestone log
        logEntries.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                   title: "Started: \(spec.name)",
                                   detail: "Construction underway for \(buildDays) day(s)."))
        // achievement counts
        if placed.count >= 5 { unlockAchievement("ach.fiveModules") }
        if placed.count >= 10 { unlockAchievement("ach.tenModules") }
        if placed.count >= 20 { unlockAchievement("ach.twentyModules") }
        persist()
    }

    func remove(moduleId: UUID) {
        guard let i = placed.firstIndex(where: { $0.id == moduleId }) else { return }
        let mod = placed[i]
        let spec = OrbitalGridCatalog.module(mod.kind)
        // refund half rounded down
        let refund = spec.buildCostParts / 2
        adjust(.parts, by: refund)
        // unassign crew
        for cid in mod.assignedCrewIds {
            if let ci = crew.firstIndex(where: { $0.id == cid }) {
                crew[ci].assignedModuleSlotId = nil
                if crew[ci].dutyAssignment == .work {
                    crew[ci].dutyAssignment = .rest
                }
            }
        }
        placed.remove(at: i)
        logEntries.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                   title: "Removed: \(spec.name)",
                                   detail: "Refunded \(refund) parts."))
        persist()
    }

    // overlap helper
    private func rectsOverlap(a1: GridPoint, sz1: GridSize, a2: GridPoint, sz2: GridSize) -> Bool {
        let x1Min = a1.x, x1Max = a1.x + sz1.w
        let y1Min = a1.y, y1Max = a1.y + sz1.h
        let x2Min = a2.x, x2Max = a2.x + sz2.w
        let y2Min = a2.y, y2Max = a2.y + sz2.h
        if x1Max <= x2Min || x2Max <= x1Min { return false }
        if y1Max <= y2Min || y2Max <= y1Min { return false }
        return true
    }

    private func hasAdjacent(origin: GridPoint, footprint: GridSize, anyKindIn kinds: Set<ModuleKind>) -> Bool {
        for placedMod in placed where kinds.contains(placedMod.kind) {
            let other = OrbitalGridCatalog.module(placedMod.kind)
            if rectsAdjacent(a1: origin, sz1: footprint, a2: placedMod.origin, sz2: other.footprint) {
                return true
            }
        }
        return false
    }
    private func rectsAdjacent(a1: GridPoint, sz1: GridSize, a2: GridPoint, sz2: GridSize) -> Bool {
        // share an edge (4-neighbor)
        let x1Min = a1.x, x1Max = a1.x + sz1.w
        let y1Min = a1.y, y1Max = a1.y + sz1.h
        let x2Min = a2.x, x2Max = a2.x + sz2.w
        let y2Min = a2.y, y2Max = a2.y + sz2.h
        // Touching along a vertical edge
        if x1Max == x2Min || x2Max == x1Min {
            if y1Min < y2Max && y2Min < y1Max { return true }
        }
        if y1Max == y2Min || y2Max == y1Min {
            if x1Min < x2Max && x2Min < x1Max { return true }
        }
        return false
    }

    func module(at point: GridPoint) -> PlacedModule? {
        for m in placed {
            let sz = m.footprint
            if point.x >= m.origin.x && point.x < m.origin.x + sz.w &&
               point.y >= m.origin.y && point.y < m.origin.y + sz.h {
                return m
            }
        }
        return nil
    }

    // MARK: Crew assignments

    func assignCrew(_ crewId: UUID, toModule moduleId: UUID?) {
        guard let ci = crew.firstIndex(where: { $0.id == crewId }) else { return }
        // remove from any prior assignment
        for i in placed.indices {
            placed[i].assignedCrewIds.removeAll { $0 == crewId }
        }
        if let mid = moduleId, let mi = placed.firstIndex(where: { $0.id == mid }) {
            let spec = OrbitalGridCatalog.module(placed[mi].kind)
            if placed[mi].assignedCrewIds.count < spec.crewSlots && placed[mi].constructionDaysLeft == 0 {
                placed[mi].assignedCrewIds.append(crewId)
                crew[ci].assignedModuleSlotId = placed[mi].id.uuidString
                crew[ci].dutyAssignment = .work
            }
        } else {
            crew[ci].assignedModuleSlotId = nil
            if crew[ci].dutyAssignment == .work {
                crew[ci].dutyAssignment = .rest
            }
        }
        persist()
    }

    func setDuty(_ duty: DutyKind, for crewId: UUID) {
        guard let ci = crew.firstIndex(where: { $0.id == crewId }) else { return }
        if duty != .work {
            // unassign module
            for i in placed.indices {
                placed[i].assignedCrewIds.removeAll { $0 == crewId }
            }
            crew[ci].assignedModuleSlotId = nil
        }
        crew[ci].dutyAssignment = duty
        persist()
    }

    // MARK: Research

    func startResearch(_ id: String) {
        guard let r = OrbitalGridCatalog.research(id) else { return }
        // prereqs
        for pre in r.prereqIds where !completedResearchIds.contains(pre) {
            return
        }
        if !hasAvailableLab(tier: r.labTierRequired) { return }
        if activeResearchId == id { return }
        activeResearchId = id
        assignedScientistIds = []
        logEntries.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                   title: "Research started: \(r.name)",
                                   detail: r.summary))
        persist()
    }

    func toggleScientist(_ crewId: UUID) {
        if assignedScientistIds.contains(crewId) {
            assignedScientistIds.removeAll { $0 == crewId }
        } else {
            assignedScientistIds.append(crewId)
        }
    }

    private func hasAvailableLab(tier: Int) -> Bool {
        for m in placed where m.constructionDaysLeft == 0 {
            if tier <= 1 && (m.kind == .labBasic || m.kind == .labAdvanced) { return true }
            if tier == 2 && m.kind == .labAdvanced { return true }
        }
        return false
    }

    // MARK: Day advance (the daily tick)

    func advanceDay() {
        if pendingIncident != nil { return }   // resolve incident first
        if endingShown { return }
        // After the ending has fired and the player dismissed it, the game continues but the
        // overlay must not re-trigger — `endingTriggered` stays true forever.

        var rng = SystemRandomNumberGenerator()
        var newLog: [LogEntry] = []

        // Snapshot resources BEFORE the tick so we can compute deltas for the post-advance summary.
        let preTickPower = amount(.power)
        let preTickFood = amount(.food)
        let preTickWater = amount(.water)
        let preTickOxygen = amount(.oxygen)
        let preTickParts = amount(.parts)
        let preTickResearch = researchPoints
        let dayBeforeAdvance = day

        day += 1
        recomputePhase()
        newLog.append(LogEntry(id: UUID(), day: day, kind: .dayStart,
                               title: "Day \(day)",
                               detail: "The station hums into another rotation."))

        // 1) advance construction
        var warpCoreJustCompleted = false
        for i in placed.indices where placed[i].constructionDaysLeft > 0 {
            placed[i].constructionDaysLeft -= 1
            if placed[i].constructionDaysLeft == 0 {
                let spec = OrbitalGridCatalog.module(placed[i].kind)
                newLog.append(LogEntry(id: UUID(), day: day, kind: .moduleCompleted,
                                       title: "Online: \(spec.name)",
                                       detail: "Module is operational."))
                if placed[i].kind == .warpCore {
                    // C-2: start the 30-day final countdown at 0 so it actually runs 30 ticks
                    warpCoreProgressDays = 0
                    warpCoreJustCompleted = true
                }
            }
        }

        // 2) warp core progress separate from build clock (final-30 countdown)
        // Skip the same tick the core finishes; counts begin the day after completion.
        if !warpCoreJustCompleted,
           let core = placed.first(where: { $0.kind == .warpCore && $0.constructionDaysLeft == 0 }) {
            _ = core
            if warpCoreProgressDays < 30 {
                warpCoreProgressDays += 1
                // Auto-siphon up to 200 parts/day from stock into the warp-core delivery pool while
                // the countdown is running. Caps the running pool at 6000 (build cost is separate).
                if warpCoreDeliveredParts < 6000 {
                    let need = 6000 - warpCoreDeliveredParts
                    let take = min(min(amount(.parts), 200), need)
                    if take > 0 {
                        adjust(.parts, by: -take)
                        warpCoreDeliveredParts += take
                        newLog.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                               title: "Warp Core Delivery",
                                               detail: "Delivered \(take) parts to warp core (\(warpCoreDeliveredParts)/6000)."))
                    }
                }
            }
            if warpCoreProgressDays >= 30 {
                // check keystones AND the 6000 parts DELIVERED during countdown (C-1 fix).
                let haveAll = OrbitalGridCatalog.warpKeystoneIds.allSatisfy { completedResearchIds.contains($0) }
                if haveAll && warpCoreDeliveredParts >= 6000 && !endingTriggered {
                    endingShown = true
                    endingTriggered = true
                    unlockAchievement("ach.warpComplete")
                    newLog.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                           title: "Warp Core Active",
                                           detail: "Drift crossed. Station leaves orbit."))
                }
            }
        }

        // 3) compute network balance
        var powerProd = 0
        var powerCons = 0
        var oxNet = 0
        var watNet = 0
        var foodNet = 0
        for m in placed where m.constructionDaysLeft == 0 {
            let spec = OrbitalGridCatalog.module(m.kind)
            if spec.powerNet >= 0 { powerProd += spec.powerNet }
            else { powerCons += -spec.powerNet }
            oxNet += spec.oxygenNet
            watNet += spec.waterNet
            foodNet += spec.foodNet
        }
        // crew consumes food/water/oxygen
        let aliveCount = crew.filter { $0.alive }.count
        // ironStomach reduces food per day
        let ironStomachCount = crew.filter { $0.traits.contains(.ironStomach) }.count
        let foodConsume = max(0, aliveCount - ironStomachCount / 2)
        let waterConsume = aliveCount
        let oxygenConsume = aliveCount

        adjust(.power, by: powerProd - powerCons)
        adjust(.oxygen, by: oxNet - oxygenConsume)
        adjust(.water, by: watNet - waterConsume)
        adjust(.food, by: foodNet - foodConsume)

        // 4) generate research
        var addedResearch = 0
        if let activeId = activeResearchId, let spec = OrbitalGridCatalog.research(activeId) {
            var pts = 0
            // every active lab generates baseline points + per-crew points
            for m in placed where (m.kind == .labBasic || m.kind == .labAdvanced) && m.constructionDaysLeft == 0 {
                let mSpec = OrbitalGridCatalog.module(m.kind)
                for cid in m.assignedCrewIds {
                    if let cm = crew.first(where: { $0.id == cid && $0.alive }) {
                        var crewPts = mSpec.researchPerCrew * (Double(cm.skill) / 60.0)
                        // trait multipliers (researchMod)
                        for t in cm.traits {
                            crewPts *= OrbitalGridCatalog.trait(t).researchMod
                        }
                        // role boost
                        if let pref = mSpec.preferredRole, cm.role == pref { crewPts *= 1.25 }
                        // assigned scientist boost
                        if assignedScientistIds.contains(cm.id) { crewPts *= 1.10 }
                        pts += Int(round(crewPts))
                    }
                }
            }
            // observation deck small boost
            for m in placed where m.kind == .observation && m.constructionDaysLeft == 0 {
                pts += m.assignedCrewIds.isEmpty ? 0 : 1
            }
            researchPoints += pts
            adjust(.research, by: pts)
            addedResearch = pts
            // F-Major-5: daily research feedback — log the per-day point gain whenever a project
            // is active and we accrued at least one point (i.e. a lab is staffed).
            if pts > 0 {
                newLog.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                       title: "Research progress",
                                       detail: "+\(pts) research pts (\(min(researchPoints, spec.pointsRequired))/\(spec.pointsRequired) for \(spec.name))."))
            }
            if researchPoints >= spec.pointsRequired {
                completedResearchIds.append(spec.id)
                researchPoints = 0
                activeResearchId = nil
                assignedScientistIds = []
                newLog.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                       title: "Research complete: \(spec.name)",
                                       detail: spec.summary))
                unlockAchievement("ach.firstResearch")
                checkBranchAchievements()
            }
        }
        _ = addedResearch

        // 4.5) Machine Shop parts production (F-H-1)
        //   Base: 1 part per assigned crew per active shop per day.
        //   r.eng.fab2: +1 part per Machine Shop crew per day.
        //   r.eng.fab3: +50% total Machine Shop parts (rounded down).
        let hasFab2 = completedResearchIds.contains("r.eng.fab2")
        let hasFab3 = completedResearchIds.contains("r.eng.fab3")
        var partsFromShops = 0
        for m in placed where m.kind == .machineShop && m.constructionDaysLeft == 0 {
            // count only alive assigned crew
            let aliveAssigned = m.assignedCrewIds.filter { id in
                crew.contains(where: { $0.id == id && $0.alive })
            }.count
            if aliveAssigned == 0 { continue }
            let perCrew = 1 + (hasFab2 ? 1 : 0)
            partsFromShops += perCrew * aliveAssigned
        }
        if hasFab3 { partsFromShops += partsFromShops / 2 }   // +50%
        if partsFromShops > 0 {
            adjust(.parts, by: partsFromShops)
        }

        // 5) crew tick: stats per duty
        applyDailyCrewTick(rng: &rng)

        // 6) trait passives & specials
        applyTraitPassives()

        // 7) check shortfall incident triggers (H-3: 2 consecutive negative ticks)
        if amount(.power) <= 0 || amount(.oxygen) <= 0 {
            negativeNetTicks += 1
            if negativeNetTicks >= 2 {
                newLog.append(LogEntry(id: UUID(), day: day, kind: .resourceShortfall,
                                       title: "Critical Shortfall",
                                       detail: "Power or oxygen has been at zero for two ticks. Crew morale falls."))
                for i in crew.indices where crew[i].alive {
                    crew[i].morale = max(0, crew[i].morale - 4)
                }
            }
        } else {
            negativeNetTicks = 0
        }
        // F-Critical-2: food and water depletion now have their own feedback + morale hit so a
        // starving station no longer feels silent. Mirrors the power/oxygen pattern (-3 morale).
        if amount(.food) == 0 {
            newLog.append(LogEntry(id: UUID(), day: day, kind: .resourceShortfall,
                                   title: "Food Depleted",
                                   detail: "Galley stores are empty. Crew morale falls."))
            for i in crew.indices where crew[i].alive {
                crew[i].morale = max(0, crew[i].morale - 3)
            }
        }
        if amount(.water) == 0 {
            newLog.append(LogEntry(id: UUID(), day: day, kind: .resourceShortfall,
                                   title: "Water Depleted",
                                   detail: "Recyclers are dry. Crew morale falls."))
            for i in crew.indices where crew[i].alive {
                crew[i].morale = max(0, crew[i].morale - 3)
            }
        }

        // 8) opportunity: roll incidents
        rollAndQueueIncident(rng: &rng)

        // 9) achievement checks (L-4: defensive >= n flags rather than == n)
        // F-Minor-7: startupWeek should not fire while any vital resource is at zero — gate on a
        // "not in crisis" condition so the player earns it for surviving, not just enduring.
        if day >= 7 && !awardedStartupWeek
            && amount(.food) > 0 && amount(.water) > 0
            && amount(.oxygen) > 0 && amount(.power) > 0 {
            awardedStartupWeek = true
            unlockAchievement("ach.startupWeek")
        }
        if day >= 180 && !awardedMidRun {
            awardedMidRun = true
            unlockAchievement("ach.midRun")
        }
        if amount(.fuel) >= 100 { unlockAchievement("ach.fuel100") }
        if amount(.parts) >= 5000 { unlockAchievement("ach.parts5000") }
        if amount(.credits) >= 5000 { unlockAchievement("ach.cred5k") }
        let avgMorale = averageMorale()
        if avgMorale >= 90 { unlockAchievement("ach.morale90") }
        // F-H-4: "Station Full" requires 12+ alive crew AND every alive crew on a non-trivial
        // duty (not the passive .rest or .rAndR fallback). Previously the filter accepted all
        // DutyKind values which made it vacuously true.
        let aliveAll = crew.filter { $0.alive }
        let activelyAssigned = aliveAll.filter {
            $0.dutyAssignment == .work ||
            $0.dutyAssignment == .train ||
            $0.dutyAssignment == .recreation
        }.count
        if aliveAll.count >= 12 && activelyAssigned == aliveAll.count {
            unlockAchievement("ach.stationFull")
        }
        // M-7: use the stored lastFatalityDay state, not log-string sniffing
        let fatalCleanDays = day - lastFatalityDay
        if fatalCleanDays >= 30 { unlockAchievement("ach.thirtyClean") }
        if fatalCleanDays >= 90 { unlockAchievement("ach.ninetyClean") }
        if unlockedAnomalyIds.count >= 5 { unlockAchievement("ach.anomaly5") }
        if unlockedAnomalyIds.count >= 20 { unlockAchievement("ach.anomaly20") }
        if unlockedAnomalyIds.count == OrbitalGridCatalog.anomalies.count {
            unlockAchievement("ach.anomalyAll")
        }
        if completedResearchIds.count == OrbitalGridCatalog.research.count {
            unlockAchievement("ach.maxResearch")
        }

        // 10) commit
        logEntries.append(contentsOf: newLog)
        if logEntries.count > 250 {
            logEntries = Array(logEntries.suffix(250))
        }

        // Build post-advance summary (F-Major-4): deltas and incident note for the visible tick.
        let dPower = amount(.power) - preTickPower
        let dFood = amount(.food) - preTickFood
        let dWater = amount(.water) - preTickWater
        let dOxygen = amount(.oxygen) - preTickOxygen
        let dParts = amount(.parts) - preTickParts
        _ = preTickResearch
        func fmt(_ n: Int) -> String { return n >= 0 ? "+\(n)" : "\(n)" }
        let deltasLine = "\(fmt(dPower)) power, \(fmt(dFood)) food, \(fmt(dWater)) water, \(fmt(dOxygen)) O2, \(fmt(dParts)) parts"
        let incidentLine: String
        if let p = pendingIncident {
            incidentLine = "Incident: \(p.title)"
        } else {
            incidentLine = "Quiet rotation."
        }
        lastAdvanceSummary = OrbitalGridAdvanceSummary(
            dayEnded: dayBeforeAdvance,
            deltasLine: deltasLine,
            incidentLine: incidentLine
        )

        persist()
    }

    // L-3: average morale across alive crew only
    private func averageMorale() -> Double {
        let alive = crew.filter { $0.alive }
        guard !alive.isEmpty else { return 0 }
        return alive.map { Double($0.morale) }.reduce(0, +) / Double(alive.count)
    }

    // M-6 / M-7: increment when crew dies. Currently no incident outcome directly kills crew,
    // but route any future death (e.g. via resolved-incident hooks or future system) through here.
    func recordFatality(crewId: UUID, day: Int) {
        if let ci = crew.firstIndex(where: { $0.id == crewId }) {
            crew[ci].alive = false
        }
        fatalitiesTotal += 1
        lastFatalityDay = day
        logEntries.append(LogEntry(id: UUID(), day: day, kind: .milestone,
                                   title: "Lost crew",
                                   detail: "A crew member is gone. Day \(day)."))
    }

    private func applyDailyCrewTick(rng: inout SystemRandomNumberGenerator) {
        let workingHabHasLarge = placed.contains(where: { $0.kind == .habLarge && $0.constructionDaysLeft == 0 })
        let workingMed = placed.contains(where: { $0.kind == .medBay && $0.constructionDaysLeft == 0 })
        let workingRec = placed.contains(where: { $0.kind == .recreation && $0.constructionDaysLeft == 0 })

        // H-6: research-buff hooks
        let hasPsych = completedResearchIds.contains("r.med.psych")   // +20% stress decay in rest
        let hasDream = completedResearchIds.contains("r.med.dream")   // +10% fatigue drop in rest

        for i in crew.indices where crew[i].alive {
            var stressMod = 1.0
            var moraleDecayMod = 1.0
            var fatigueGainMod = 1.0
            for t in crew[i].traits {
                let ts = OrbitalGridCatalog.trait(t)
                stressMod *= ts.stressGainMod
                moraleDecayMod *= ts.moraleDecayMod
                // H-4: insomniac trait now actually adds +15% fatigue gain
                if t == .insomniac { fatigueGainMod *= 1.15 }
            }
            // baseline drift
            switch crew[i].dutyAssignment {
            case .work:
                var fatigueGain = 7 * (workingHabHasLarge ? 0.85 : 1.0) * fatigueGainMod
                // H-4: earlyRiser skips fatigue penalty on first work duty (proxied: -50% one-shot per tick)
                if crew[i].traits.contains(.earlyRiser) { fatigueGain *= 0.5 }
                crew[i].fatigue += Int(round(fatigueGain))
                crew[i].stress += Int(round(3 * stressMod))
                crew[i].morale -= Int(round(1 * moraleDecayMod))
                // matched role bumps skill
                if let mid = crew[i].assignedModuleSlotId, let m = placed.first(where: { $0.id.uuidString == mid }) {
                    let s = OrbitalGridCatalog.module(m.kind)
                    if let pref = s.preferredRole, pref == crew[i].role, Int.random(in: 0..<100, using: &rng) < 18 {
                        crew[i].skill += 1
                    }
                }
            case .rest:
                var fatigueDrop = 14
                if hasDream { fatigueDrop = Int(round(Double(fatigueDrop) * 1.10)) }
                crew[i].fatigue -= fatigueDrop
                var stressDrop = Int(round(3 / stressMod))
                if hasPsych { stressDrop = Int(round(Double(stressDrop) * 1.20)) }
                crew[i].stress -= stressDrop
                crew[i].morale -= Int(round(1 * moraleDecayMod))
                if crew[i].traits.contains(.sleeper) { crew[i].fatigue -= 6 }
                // H-4: nightOwl now grants morale resilience (smaller decay on rest)
                if crew[i].traits.contains(.nightOwl) { crew[i].morale += 1 }
            case .train:
                crew[i].fatigue += Int(round(5 * fatigueGainMod))
                crew[i].stress += 1
                if Int.random(in: 0..<100, using: &rng) < 30 { crew[i].skill += 1 }
            case .recreation:
                crew[i].morale += workingRec ? 6 : 4
                crew[i].stress -= Int(round(5 / stressMod))
                crew[i].fatigue -= 3
            case .rAndR:
                crew[i].morale += 4
                crew[i].stress -= 8
                var rrFatigueDrop = 18
                if hasDream { rrFatigueDrop = Int(round(Double(rrFatigueDrop) * 1.10)) }
                crew[i].fatigue -= rrFatigueDrop
            }
            // med-bay passive
            if workingMed {
                if crew[i].stress > 60 { crew[i].stress -= 2 }
            }
            // clamp
            crew[i].skill = max(0, min(100, crew[i].skill))
            crew[i].morale = max(0, min(100, crew[i].morale))
            crew[i].stress = max(0, min(100, crew[i].stress))
            crew[i].fatigue = max(0, min(100, crew[i].fatigue))
        }
    }

    private func applyTraitPassives() {
        // hoarder: +1 part per cargo per day
        for m in placed where m.kind == .cargo && m.constructionDaysLeft == 0 {
            let hoarders = m.assignedCrewIds.filter { id in
                crew.contains(where: { $0.id == id && $0.traits.contains(.hoarder) })
            }.count
            if hoarders > 0 { adjust(.parts, by: hoarders) }
        }
        // empath: morale boost for habitat-mates
        for m in placed where (m.kind == .habSmall || m.kind == .habLarge) && m.constructionDaysLeft == 0 {
            let empaths = m.assignedCrewIds.filter { id in
                crew.contains(where: { $0.id == id && $0.traits.contains(.empath) })
            }.count
            if empaths > 0 {
                for cid in m.assignedCrewIds {
                    if let ci = crew.firstIndex(where: { $0.id == cid }) {
                        crew[ci].morale = min(100, crew[ci].morale + empaths)
                    }
                }
            }
        }

        // H-4: prankster — +1 morale per day to crew sharing a module ("nearby")
        for m in placed where m.constructionDaysLeft == 0 {
            let pranksters = m.assignedCrewIds.filter { id in
                crew.contains(where: { $0.id == id && $0.traits.contains(.prankster) })
            }.count
            if pranksters > 0 {
                for cid in m.assignedCrewIds {
                    if let ci = crew.firstIndex(where: { $0.id == cid }),
                       !crew[ci].traits.contains(.prankster) {
                        crew[ci].morale = min(100, crew[ci].morale + pranksters)
                    }
                }
            }
        }

        // H-4: mentor — small passive skill gain for crew sharing a module with a mentor
        for m in placed where m.constructionDaysLeft == 0 {
            let mentors = m.assignedCrewIds.filter { id in
                crew.contains(where: { $0.id == id && $0.traits.contains(.mentor) })
            }.count
            if mentors > 0 {
                var rng = SystemRandomNumberGenerator()
                for cid in m.assignedCrewIds {
                    if let ci = crew.firstIndex(where: { $0.id == cid }),
                       !crew[ci].traits.contains(.mentor) {
                        if Int.random(in: 0..<100, using: &rng) < min(60, 8 * mentors) {
                            crew[ci].skill = min(100, crew[ci].skill + 1)
                        }
                    }
                }
            }
        }

        // H-4: gambler — periodic credit swing every 10 days (±10) per gambler
        if day % 10 == 0 {
            var rng = SystemRandomNumberGenerator()
            let gamblerCount = crew.filter { $0.alive && $0.traits.contains(.gambler) }.count
            for _ in 0..<gamblerCount {
                let swing = Bool.random(using: &rng) ? 10 : -10
                adjust(.credits, by: swing)
            }
        }

        // H-6: research effect — r.log.contracts grants +25 credits every 5 days
        if day % 5 == 0 && completedResearchIds.contains("r.log.contracts") {
            adjust(.credits, by: 25)
        }
        // F-M-2: r.astro.specs supersedes r.astro.optics for observation-deck research bonuses.
        // If both are researched, only the per-crew (specs) bonus applies; otherwise optics
        // grants +1/deck flat.
        let hasSpecs = completedResearchIds.contains("r.astro.specs")
        let hasOptics = completedResearchIds.contains("r.astro.optics")
        if hasSpecs {
            for m in placed where m.kind == .observation && m.constructionDaysLeft == 0 {
                let crewOn = m.assignedCrewIds.count
                if crewOn > 0 { adjust(.research, by: crewOn) }
            }
        } else if hasOptics {
            for m in placed where m.kind == .observation && m.constructionDaysLeft == 0 && !m.assignedCrewIds.isEmpty {
                adjust(.research, by: 1)
            }
        }
        // H-6: research effect — r.bio.gene2 (2x injury recovery): morale recovers an extra +1 in recreation/R&R
        if completedResearchIds.contains("r.bio.gene2") {
            for i in crew.indices where crew[i].alive &&
                (crew[i].dutyAssignment == .recreation || crew[i].dutyAssignment == .rAndR) {
                crew[i].morale = min(100, crew[i].morale + 1)
            }
        }
    }

    // MARK: Incident rolling

    private func rollAndQueueIncident(rng: inout SystemRandomNumberGenerator) {
        if pendingIncident != nil { return }
        // base 0-3 weighted: 35% none, 35% 1, 20% 2, 10% 3
        let roll = Int.random(in: 0..<100, using: &rng)
        let n: Int
        if roll < 35 { n = 0 }
        else if roll < 70 { n = 1 }
        else if roll < 90 { n = 2 }
        else { n = 3 }
        guard n > 0 else { return }
        // 1-day cooldown between forced incidents. `lastIncidentDay` is set to `day` after firing,
        // so on the next tick `day - lastIncidentDay == 1`; we want a real 1-day gap, hence `< 2`.
        // Rolls inside the cooldown window have a 60% chance to skip.
        if day - lastIncidentDay < 2 && Int.random(in: 0..<100, using: &rng) > 40 { return }

        let pool = OrbitalGridCatalog.incidents(in: phase)
        if pool.isEmpty { return }
        var pick = pool[Int.random(in: 0..<pool.count, using: &rng)]
        // H-6: r.eng.dampers — technical-incident roll weight -20% (re-roll once on tech if researched)
        if completedResearchIds.contains("r.eng.dampers") && pick.category == .technical {
            if Int.random(in: 0..<100, using: &rng) < 20 {
                // try to find a non-technical alternative; if none, suppress this tick
                let nonTech = pool.filter { $0.category != .technical }
                if let alt = nonTech.randomElement(using: &rng) {
                    pick = alt
                } else {
                    return
                }
            }
        }
        // pick crew if needed
        if pick.needsCrewInvolvement {
            let alive = crew.filter { $0.alive }
            pendingIncidentCrew = alive.randomElement(using: &rng)
        } else {
            pendingIncidentCrew = nil
        }
        pendingIncident = pick
        lastIncidentDay = day
        logEntries.append(LogEntry(id: UUID(), day: day, kind: .incident,
                                   title: pick.title,
                                   detail: pick.body))
    }

    func resolveIncident(choice: IncidentChoice) {
        guard let inc = pendingIncident else { return }
        // apply resource deltas
        for (k, d) in choice.outcome.resourceDelta {
            if let r = ResourceKind(rawValue: k) { adjust(r, by: d) }
        }
        // crew stat impact
        var fatalityThisResolve = false
        if let cm = pendingIncidentCrew, let ci = crew.firstIndex(where: { $0.id == cm.id }) {
            crew[ci].stress = max(0, min(100, crew[ci].stress + choice.outcome.stressDelta))
            crew[ci].morale = max(0, min(100, crew[ci].morale + choice.outcome.moraleDelta))
            crew[ci].fatigue = max(0, min(100, crew[ci].fatigue + choice.outcome.fatigueDelta))
            crew[ci].skill = max(0, min(100, crew[ci].skill + choice.outcome.skillDelta))
            // F-H-2: roll for fatality on outcomes that carry a real risk to the involved crew.
            if choice.outcome.fatalityRiskPct > 0 && crew[ci].alive {
                var rng = SystemRandomNumberGenerator()
                if Int.random(in: 0..<100, using: &rng) < choice.outcome.fatalityRiskPct {
                    recordFatality(crewId: crew[ci].id, day: day)
                    fatalityThisResolve = true
                }
            }
        } else {
            // spread morale across crew
            for i in crew.indices {
                crew[i].morale = max(0, min(100, crew[i].morale + (choice.outcome.moraleDelta / 2)))
            }
        }
        _ = fatalityThisResolve   // fatality already logged via recordFatality
        if choice.outcome.addCrewMember {
            addNewCrewMember()
        }
        if let id = choice.outcome.revealAnomalyId, !unlockedAnomalyIds.contains(id) {
            unlockedAnomalyIds.append(id)
            logEntries.append(LogEntry(id: UUID(), day: day, kind: .anomaly,
                                       title: "Anomaly: \(OrbitalGridCatalog.anomaly(id)?.title ?? "")",
                                       detail: OrbitalGridCatalog.anomaly(id)?.text ?? ""))
        }
        // trader stat (F-H-3: dedicated counter incremented before the achievement check,
        // so the achievement fires on the 3rd resolved trader, not the 4th).
        if inc.category == .opportunity {
            let traderTitles: Set<String> = [
                "Visiting Trader", "Fuel Vendor", "Warp Theorist Drops In"
            ]
            if traderTitles.contains(inc.title) {
                tradeResolveCount += 1
                if tradeResolveCount >= 3 { unlockAchievement("ach.threeTrades") }
            }
        }
        if inc.category == .technical {
            // Persisted counter (mirrors tradeResolveCount). Survives the 250-entry log cap
            // unlike the prior logEntries scan which made late-game unlock impossible.
            technicalResolveCount += 1
            if technicalResolveCount >= 5 { unlockAchievement("ach.fiveCrisis") }
        }

        logEntries.append(LogEntry(id: UUID(), day: day, kind: .incident,
                                   title: "Resolved: \(inc.title)",
                                   detail: choice.outcome.resolveText))
        pendingIncident = nil
        pendingIncidentCrew = nil
        persist()
    }

    private func addNewCrewMember() {
        let traits = TraitId.allCases
        var rng = SystemRandomNumberGenerator()
        let t1 = traits.randomElement(using: &rng) ?? .loyal
        var t2 = traits.randomElement(using: &rng) ?? .stoic
        if t2 == t1 { t2 = traits.first(where: { $0 != t1 }) ?? .stoic }
        let firstNames = ["Atlas", "Vera", "Ko", "Mira", "Solen", "Iko", "Pell", "Nour", "Hade", "Sayer", "Ji-Won", "Ranj"]
        let lastNames = ["Vela", "Brask", "Olari", "Tay", "Quinn", "Mara", "Soren", "Trev", "Lume"]
        let firstName = firstNames.randomElement(using: &rng) ?? "Crew"
        let lastName = lastNames.randomElement(using: &rng) ?? "Drift"
        let role = CrewRole.allCases.randomElement(using: &rng) ?? .researcher
        let cm = CrewMember(
            id: UUID(),
            name: "\(firstName) \(lastName)",
            role: role,
            portraitSeed: crew.count + 5,
            traits: [t1, t2],
            skill: Int.random(in: 30...60, using: &rng),
            morale: 60,
            stress: 15,
            fatigue: 15,
            dutyAssignment: .rest,
            assignedModuleSlotId: nil,
            alive: true
        )
        crew.append(cm)
    }

    // MARK: Achievements

    func unlockAchievement(_ id: String) {
        if unlockedAchievementIds.contains(id) { return }
        guard let spec = OrbitalGridCatalog.achievements.first(where: { $0.id == id }) else { return }
        unlockedAchievementIds.append(id)
        pendingAchievementBanner = spec
        logEntries.append(LogEntry(id: UUID(), day: day, kind: .achievement,
                                   title: "Achievement: \(spec.title)",
                                   detail: spec.detail))
    }
    func dismissAchievementBanner() {
        pendingAchievementBanner = nil
    }
    private func checkBranchAchievements() {
        let branches: [ResearchBranch: String] = [
            .engineering: "ach.engBranch",
            .biology:    "ach.bioBranch",
            .astrophysics: "ach.astroBranch",
            .medicine:   "ach.medBranch",
            .logistics:  "ach.logBranch",
        ]
        for (br, achId) in branches {
            let allOfBranch = OrbitalGridCatalog.research.filter { $0.branch == br }
            let done = allOfBranch.allSatisfy { completedResearchIds.contains($0.id) }
            if done { unlockAchievement(achId) }
        }
    }

    // MARK: Convenience derived

    func phaseAllows(_ ph: CampaignPhase) -> Bool {
        let order = CampaignPhase.allCases
        guard let cur = order.firstIndex(of: phase),
              let req = order.firstIndex(of: ph) else { return false }
        return cur >= req
    }

    func powerProductionConsumption() -> (Int, Int) {
        var prod = 0; var cons = 0
        for m in placed where m.constructionDaysLeft == 0 {
            let s = OrbitalGridCatalog.module(m.kind)
            if s.powerNet > 0 { prod += s.powerNet } else { cons += -s.powerNet }
        }
        return (prod, cons)
    }

    func oxygenProductionConsumption() -> (Int, Int) {
        var prod = 0; var cons = crew.filter { $0.alive }.count
        for m in placed where m.constructionDaysLeft == 0 {
            let s = OrbitalGridCatalog.module(m.kind)
            if s.oxygenNet > 0 { prod += s.oxygenNet } else { cons += -s.oxygenNet }
        }
        return (prod, cons)
    }

    func warpKeystoneCount() -> (Int, Int) {
        let total = OrbitalGridCatalog.warpKeystoneIds.count
        let have = OrbitalGridCatalog.warpKeystoneIds.filter { completedResearchIds.contains($0) }.count
        return (have, total)
    }
}
