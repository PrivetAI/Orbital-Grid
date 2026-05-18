import Foundation
import SwiftUI

// MARK: - Orbital Grid data model

enum ResourceKind: String, Codable, CaseIterable, Hashable {
    case power, oxygen, water, food, parts, medicine, fuel, research, credits, morale

    var display: String {
        switch self {
        case .power: return "Power"
        case .oxygen: return "Oxygen"
        case .water: return "Water"
        case .food: return "Food"
        case .parts: return "Parts"
        case .medicine: return "Meds"
        case .fuel: return "Fuel"
        case .research: return "Research"
        case .credits: return "Credits"
        case .morale: return "Morale"
        }
    }

    var color: Color {
        switch self {
        case .power: return OrbitalGridPalette.modPower
        case .oxygen: return OrbitalGridPalette.teal
        case .water: return Color(red: 0x35/255, green: 0x6E/255, blue: 0x9E/255)
        case .food: return OrbitalGridPalette.success
        case .parts: return OrbitalGridPalette.graphite
        case .medicine: return OrbitalGridPalette.danger
        case .fuel: return OrbitalGridPalette.ember
        case .research: return OrbitalGridPalette.magenta
        case .credits: return Color(red: 0xB5/255, green: 0x8E/255, blue: 0x3E/255)
        case .morale: return OrbitalGridPalette.modHab
        }
    }
}

enum ModuleKind: String, Codable, CaseIterable, Hashable {
    case command, lifeSupport, hydroponics, powerCell, solarArray
    case labBasic, labAdvanced, medBay, airlock
    case habSmall, habLarge, galley, cargo
    case observation, machineShop, comms, recreation
    case scienceGreenhouse, fuelTank, warpCore, botany
}

enum ModuleCategory: String, Codable {
    case ops, life, power, science, hab, special
    var color: Color {
        switch self {
        case .ops: return OrbitalGridPalette.modOps
        case .life: return OrbitalGridPalette.modLife
        case .power: return OrbitalGridPalette.modPower
        case .science: return OrbitalGridPalette.modScience
        case .hab: return OrbitalGridPalette.modHab
        case .special: return OrbitalGridPalette.modSpecial
        }
    }
}

struct ModuleSpec: Identifiable, Codable, Hashable {
    let id: String
    let kind: ModuleKind
    let name: String
    let summary: String
    let footprint: GridSize
    let category: ModuleCategory

    // economy
    let buildCostParts: Int
    let buildCostCredits: Int
    let buildDays: Int

    // continuous effect (per tick)
    let powerNet: Int       // +produced, -consumed
    let oxygenNet: Int
    let waterNet: Int
    let foodNet: Int
    let researchPerCrew: Double
    let crewSlots: Int

    // adjacency / placement rules
    let mustBorderEdge: Bool
    let needsAdjacentPower: Bool
    let needsAdjacentLifeSupport: Bool

    // unlock
    let phaseUnlock: CampaignPhase
    let requiresResearchId: String?

    // crew specialization boost
    let preferredRole: CrewRole?
}

struct GridSize: Codable, Hashable {
    let w: Int
    let h: Int
}

enum CrewRole: String, Codable, CaseIterable, Hashable {
    case captain, engineer, medic, scientist, pilot, botanist
    case cook, comms, security, maintenance, researcher, quartermaster

    var display: String {
        switch self {
        case .captain: return "Captain"
        case .engineer: return "Engineer"
        case .medic: return "Medic"
        case .scientist: return "Scientist"
        case .pilot: return "Pilot"
        case .botanist: return "Botanist"
        case .cook: return "Cook"
        case .comms: return "Comms"
        case .security: return "Security"
        case .maintenance: return "Maintenance"
        case .researcher: return "Researcher"
        case .quartermaster: return "Quartermaster"
        }
    }
}

enum TraitId: String, Codable, CaseIterable, Hashable {
    case ambitious, paranoid, quiet, loyal, abrasive, religious, prankster, loneWolf
    case methodical, optimist, pessimist, insomniac, claustrophobic, daredevil
    case stoic, hothead, mentor, ironStomach, frail, photoMemory
    case nightOwl, earlyRiser, perfectionist, gambler, sleeper, hoarder
    case empath, cynic, restless, dreamer, dutiful, jaded
}

struct TraitSpec: Identifiable, Codable, Hashable {
    let id: TraitId
    let name: String
    let effect: String

    // small mechanical modifiers (defaults to zero/false)
    let skillMod: Int          // applied to assigned-module output
    let stressGainMod: Double  // multiplier on stress gained per day
    let moraleDecayMod: Double // multiplier on morale decay
    let conflictChanceMod: Double
    let refuseMysteryChance: Double  // 0..1: chance to refuse mysterious-event tasks
    let researchMod: Double          // multiplier on research output
    let medicalBonus: Double
    let mechanicalBonus: Double
    let securityBonus: Double
}

enum IncidentCategory: String, Codable, CaseIterable, Hashable {
    case technical, medical, social, external, opportunity
    var label: String {
        switch self {
        case .technical: return "Technical"
        case .medical: return "Medical"
        case .social: return "Social"
        case .external: return "External"
        case .opportunity: return "Opportunity"
        }
    }
    var color: Color {
        switch self {
        case .technical: return OrbitalGridPalette.modPower
        case .medical: return OrbitalGridPalette.danger
        case .social: return OrbitalGridPalette.modHab
        case .external: return OrbitalGridPalette.modScience
        case .opportunity: return OrbitalGridPalette.success
        }
    }
}

struct IncidentOutcome: Codable, Hashable {
    var resourceDelta: [String: Int] = [:]   // ResourceKind.rawValue -> delta
    var stressDelta: Int = 0
    var moraleDelta: Int = 0
    var fatigueDelta: Int = 0
    var skillDelta: Int = 0
    var revealAnomalyId: String? = nil
    var addCrewMember: Bool = false
    var grantResearchId: String? = nil
    // F-H-2: fatality risk percentage (0..100) applied to the involved crew when this outcome
    // resolves. Used by `resolveIncident` to roll for crew death. 0 means no fatality risk.
    var fatalityRiskPct: Int = 0
    var resolveText: String
}

struct IncidentChoice: Codable, Hashable {
    let label: String
    let detail: String
    let costPreview: String
    let outcome: IncidentOutcome
}

struct IncidentSpec: Identifiable, Codable, Hashable {
    let id: String
    let category: IncidentCategory
    let title: String
    let body: String
    let needsCrewInvolvement: Bool
    let phaseUnlock: CampaignPhase
    let choices: [IncidentChoice]
}

enum ResearchBranch: String, Codable, CaseIterable, Hashable {
    case engineering, biology, astrophysics, medicine, logistics
    var label: String {
        switch self {
        case .engineering: return "Engineering"
        case .biology: return "Biology"
        case .astrophysics: return "Astrophysics"
        case .medicine: return "Medicine"
        case .logistics: return "Logistics"
        }
    }
    var color: Color {
        switch self {
        case .engineering: return OrbitalGridPalette.modPower
        case .biology: return OrbitalGridPalette.success
        case .astrophysics: return OrbitalGridPalette.magenta
        case .medicine: return OrbitalGridPalette.danger
        case .logistics: return OrbitalGridPalette.modScience
        }
    }
}

struct ResearchSpec: Identifiable, Codable, Hashable {
    let id: String
    let branch: ResearchBranch
    let tier: Int             // 1..5
    let name: String
    let summary: String
    let pointsRequired: Int
    let prereqIds: [String]
    let labTierRequired: Int  // 1 basic, 2 advanced
    let warpCoreKey: Bool     // counts toward warp-core unlock
}

enum CampaignPhase: String, Codable, CaseIterable, Hashable {
    case pioneering, stabilization, expansion, crisis, preWarp, warpLaunch
    var label: String {
        switch self {
        case .pioneering:   return "Pioneering"
        case .stabilization:return "Stabilization"
        case .expansion:    return "Expansion"
        case .crisis:       return "Crisis"
        case .preWarp:      return "Pre-Warp"
        case .warpLaunch:   return "Warp Launch"
        }
    }
    var startDay: Int {
        switch self {
        case .pioneering: return 1
        case .stabilization: return 45
        case .expansion: return 110
        case .crisis: return 200
        case .preWarp: return 290
        case .warpLaunch: return 355
        }
    }
}

struct AnomalyEntry: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let text: String
    let revealHint: String
}

struct AchievementSpec: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let detail: String
}

// MARK: Crew & placement runtime model

struct CrewMember: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var role: CrewRole
    var portraitSeed: Int
    var traits: [TraitId]
    var skill: Int      // 0..100
    var morale: Int     // 0..100
    var stress: Int     // 0..100
    var fatigue: Int    // 0..100
    var dutyAssignment: DutyKind
    var assignedModuleSlotId: String?  // if duty is .work, where
    var alive: Bool = true
}

enum DutyKind: String, Codable, CaseIterable, Hashable {
    case work, rest, train, recreation, rAndR

    var label: String {
        switch self {
        case .work: return "Work"
        case .rest: return "Rest"
        case .train: return "Train"
        case .recreation: return "Recreation"
        case .rAndR: return "R&R"
        }
    }
    var detail: String {
        switch self {
        case .work: return "Assigned to a module slot."
        case .rest: return "Recovers fatigue."
        case .train: return "Slowly gains skill."
        case .recreation: return "Recovers morale, slight stress drop."
        case .rAndR: return "Deep recovery, no output."
        }
    }
}

struct PlacedModule: Identifiable, Codable, Hashable {
    let id: UUID
    let kind: ModuleKind
    let origin: GridPoint     // top-left cell
    let footprint: GridSize
    var constructionDaysLeft: Int  // 0 means active
    var assignedCrewIds: [UUID]    // ordered by slot
}

struct GridPoint: Codable, Hashable {
    let x: Int
    let y: Int
}

enum AdvanceEventKind: String, Codable, Hashable {
    case dayStart, incident, resourceShortfall, moduleCompleted, achievement, anomaly, milestone
}

struct LogEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let day: Int
    let kind: AdvanceEventKind
    let title: String
    let detail: String
}

// Compact summary of the most recent advanceDay() tick, surfaced as a post-advance card.
struct OrbitalGridAdvanceSummary: Equatable {
    let dayEnded: Int
    let deltasLine: String
    let incidentLine: String
}

// MARK: Persistence root

struct OrbitalGridSave: Codable {
    var day: Int
    var phase: CampaignPhase
    var resources: [String: Int]   // ResourceKind.rawValue -> amount
    var crew: [CrewMember]
    var placed: [PlacedModule]
    var researchPoints: Int
    var completedResearchIds: [String]
    var activeResearchId: String?
    var unlockedAnomalyIds: [String]
    var unlockedAchievementIds: [String]
    var warpCoreProgressDays: Int
    var endingShown: Bool
    var logEntries: [LogEntry]
    var lastIncidentDay: Int
    var fatalitiesTotal: Int
    var lastFatalityDay: Int
    var negativeNetTicks: Int
    var endingTriggered: Bool
    var tradeResolveCount: Int
    var technicalResolveCount: Int
    var warpCoreDeliveredParts: Int

    init(day: Int, phase: CampaignPhase, resources: [String: Int], crew: [CrewMember],
         placed: [PlacedModule], researchPoints: Int, completedResearchIds: [String],
         activeResearchId: String?, unlockedAnomalyIds: [String], unlockedAchievementIds: [String],
         warpCoreProgressDays: Int, endingShown: Bool, logEntries: [LogEntry],
         lastIncidentDay: Int, fatalitiesTotal: Int,
         lastFatalityDay: Int = 0, negativeNetTicks: Int = 0,
         endingTriggered: Bool = false,
         tradeResolveCount: Int = 0,
         technicalResolveCount: Int = 0,
         warpCoreDeliveredParts: Int = 0) {
        self.day = day
        self.phase = phase
        self.resources = resources
        self.crew = crew
        self.placed = placed
        self.researchPoints = researchPoints
        self.completedResearchIds = completedResearchIds
        self.activeResearchId = activeResearchId
        self.unlockedAnomalyIds = unlockedAnomalyIds
        self.unlockedAchievementIds = unlockedAchievementIds
        self.warpCoreProgressDays = warpCoreProgressDays
        self.endingShown = endingShown
        self.logEntries = logEntries
        self.lastIncidentDay = lastIncidentDay
        self.fatalitiesTotal = fatalitiesTotal
        self.lastFatalityDay = lastFatalityDay
        self.negativeNetTicks = negativeNetTicks
        self.endingTriggered = endingTriggered
        self.tradeResolveCount = tradeResolveCount
        self.technicalResolveCount = technicalResolveCount
        self.warpCoreDeliveredParts = warpCoreDeliveredParts
    }

    private enum CodingKeys: String, CodingKey {
        case day, phase, resources, crew, placed, researchPoints, completedResearchIds,
             activeResearchId, unlockedAnomalyIds, unlockedAchievementIds,
             warpCoreProgressDays, endingShown, logEntries, lastIncidentDay,
             fatalitiesTotal, lastFatalityDay, negativeNetTicks, endingTriggered,
             tradeResolveCount, technicalResolveCount, warpCoreDeliveredParts
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.day = (try? c.decodeIfPresent(Int.self, forKey: .day)) ?? 1
        self.phase = (try? c.decodeIfPresent(CampaignPhase.self, forKey: .phase)) ?? .pioneering
        self.resources = (try? c.decodeIfPresent([String: Int].self, forKey: .resources)) ?? OrbitalGridSave.defaultStartingResources
        self.crew = (try? c.decodeIfPresent([CrewMember].self, forKey: .crew)) ?? []
        self.placed = (try? c.decodeIfPresent([PlacedModule].self, forKey: .placed)) ?? []
        self.researchPoints = (try? c.decodeIfPresent(Int.self, forKey: .researchPoints)) ?? 0
        self.completedResearchIds = (try? c.decodeIfPresent([String].self, forKey: .completedResearchIds)) ?? []
        self.activeResearchId = (try? c.decodeIfPresent(String.self, forKey: .activeResearchId)) ?? nil
        self.unlockedAnomalyIds = (try? c.decodeIfPresent([String].self, forKey: .unlockedAnomalyIds)) ?? []
        self.unlockedAchievementIds = (try? c.decodeIfPresent([String].self, forKey: .unlockedAchievementIds)) ?? []
        self.warpCoreProgressDays = (try? c.decodeIfPresent(Int.self, forKey: .warpCoreProgressDays)) ?? 0
        self.endingShown = (try? c.decodeIfPresent(Bool.self, forKey: .endingShown)) ?? false
        self.logEntries = (try? c.decodeIfPresent([LogEntry].self, forKey: .logEntries)) ?? []
        self.lastIncidentDay = (try? c.decodeIfPresent(Int.self, forKey: .lastIncidentDay)) ?? 0
        self.fatalitiesTotal = (try? c.decodeIfPresent(Int.self, forKey: .fatalitiesTotal)) ?? 0
        self.lastFatalityDay = (try? c.decodeIfPresent(Int.self, forKey: .lastFatalityDay)) ?? 0
        self.negativeNetTicks = (try? c.decodeIfPresent(Int.self, forKey: .negativeNetTicks)) ?? 0
        // backward-compat: derive from endingShown for older saves where the ending could only
        // be reached by setting endingShown=true.
        let storedEndingTriggered = (try? c.decodeIfPresent(Bool.self, forKey: .endingTriggered)) ?? nil
        self.endingTriggered = storedEndingTriggered ?? self.endingShown
        self.tradeResolveCount = (try? c.decodeIfPresent(Int.self, forKey: .tradeResolveCount)) ?? 0
        self.technicalResolveCount = (try? c.decodeIfPresent(Int.self, forKey: .technicalResolveCount)) ?? 0
        self.warpCoreDeliveredParts = (try? c.decodeIfPresent(Int.self, forKey: .warpCoreDeliveredParts)) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(day, forKey: .day)
        try c.encode(phase, forKey: .phase)
        try c.encode(resources, forKey: .resources)
        try c.encode(crew, forKey: .crew)
        try c.encode(placed, forKey: .placed)
        try c.encode(researchPoints, forKey: .researchPoints)
        try c.encode(completedResearchIds, forKey: .completedResearchIds)
        try c.encodeIfPresent(activeResearchId, forKey: .activeResearchId)
        try c.encode(unlockedAnomalyIds, forKey: .unlockedAnomalyIds)
        try c.encode(unlockedAchievementIds, forKey: .unlockedAchievementIds)
        try c.encode(warpCoreProgressDays, forKey: .warpCoreProgressDays)
        try c.encode(endingShown, forKey: .endingShown)
        try c.encode(logEntries, forKey: .logEntries)
        try c.encode(lastIncidentDay, forKey: .lastIncidentDay)
        try c.encode(fatalitiesTotal, forKey: .fatalitiesTotal)
        try c.encode(lastFatalityDay, forKey: .lastFatalityDay)
        try c.encode(negativeNetTicks, forKey: .negativeNetTicks)
        try c.encode(endingTriggered, forKey: .endingTriggered)
        try c.encode(tradeResolveCount, forKey: .tradeResolveCount)
        try c.encode(technicalResolveCount, forKey: .technicalResolveCount)
        try c.encode(warpCoreDeliveredParts, forKey: .warpCoreDeliveredParts)
    }

    static let defaultStartingResources: [String: Int] = [
        ResourceKind.power.rawValue: 60,
        ResourceKind.oxygen.rawValue: 80,
        ResourceKind.water.rawValue: 60,
        ResourceKind.food.rawValue: 50,
        ResourceKind.parts.rawValue: 1200,
        ResourceKind.medicine.rawValue: 25,
        ResourceKind.fuel.rawValue: 18,
        ResourceKind.research.rawValue: 0,
        ResourceKind.credits.rawValue: 800,
        ResourceKind.morale.rawValue: 60,
    ]
}
