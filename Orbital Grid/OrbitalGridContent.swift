import Foundation

// MARK: - Static content catalogs for Orbital Grid

enum OrbitalGridCatalog {

    // MARK: Modules (21)

    static let modules: [ModuleSpec] = [
        ModuleSpec(
            id: "m.command", kind: .command, name: "Command Deck",
            summary: "Central command. Houses the captain and primary status link.",
            footprint: GridSize(w: 2, h: 2), category: .ops,
            buildCostParts: 120, buildCostCredits: 100, buildDays: 2,
            powerNet: -2, oxygenNet: -1, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 2,
            mustBorderEdge: false, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: .captain
        ),
        ModuleSpec(
            id: "m.life", kind: .lifeSupport, name: "Life Support",
            summary: "Atmospheric scrubber and oxygen generator.",
            footprint: GridSize(w: 1, h: 2), category: .life,
            buildCostParts: 80, buildCostCredits: 40, buildDays: 1,
            powerNet: -3, oxygenNet: 8, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 1,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: .engineer
        ),
        ModuleSpec(
            id: "m.hydro", kind: .hydroponics, name: "Hydroponics Bay",
            summary: "Grows quick-cycle algae and beans.",
            footprint: GridSize(w: 2, h: 1), category: .life,
            buildCostParts: 100, buildCostCredits: 60, buildDays: 2,
            powerNet: -2, oxygenNet: 1, waterNet: -2, foodNet: 4,
            researchPerCrew: 0.0, crewSlots: 1,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: .botanist
        ),
        ModuleSpec(
            id: "m.power", kind: .powerCell, name: "Power Cell Bank",
            summary: "Reliable internal energy buffer.",
            footprint: GridSize(w: 1, h: 1), category: .power,
            buildCostParts: 60, buildCostCredits: 30, buildDays: 1,
            powerNet: 4, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 0,
            mustBorderEdge: false, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.solar", kind: .solarArray, name: "Solar Array",
            summary: "Panel cluster — must mount on hull edge.",
            footprint: GridSize(w: 2, h: 1), category: .power,
            buildCostParts: 90, buildCostCredits: 50, buildDays: 2,
            powerNet: 7, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 0,
            mustBorderEdge: true, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.labB", kind: .labBasic, name: "Basic Lab",
            summary: "Lab tier 1. Generates research points.",
            footprint: GridSize(w: 2, h: 2), category: .science,
            buildCostParts: 140, buildCostCredits: 80, buildDays: 3,
            powerNet: -2, oxygenNet: 0, waterNet: -1, foodNet: 0,
            researchPerCrew: 1.2, crewSlots: 2,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: .researcher
        ),
        ModuleSpec(
            id: "m.labA", kind: .labAdvanced, name: "Advanced Lab",
            summary: "Lab tier 2. Required for late-game research.",
            footprint: GridSize(w: 2, h: 2), category: .science,
            buildCostParts: 260, buildCostCredits: 220, buildDays: 4,
            powerNet: -4, oxygenNet: 0, waterNet: -1, foodNet: 0,
            researchPerCrew: 2.4, crewSlots: 3,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: true,
            phaseUnlock: .expansion, requiresResearchId: "r.eng.lab2",
            preferredRole: .scientist
        ),
        ModuleSpec(
            id: "m.med", kind: .medBay, name: "Med Bay",
            summary: "Treats injuries, reduces stress.",
            footprint: GridSize(w: 2, h: 1), category: .life,
            buildCostParts: 110, buildCostCredits: 100, buildDays: 2,
            powerNet: -1, oxygenNet: 0, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.2, crewSlots: 1,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .stabilization, requiresResearchId: nil,
            preferredRole: .medic
        ),
        ModuleSpec(
            id: "m.airlock", kind: .airlock, name: "Airlock",
            summary: "Required for EVA and trader arrivals. Must border hull.",
            footprint: GridSize(w: 1, h: 1), category: .ops,
            buildCostParts: 70, buildCostCredits: 30, buildDays: 1,
            powerNet: -1, oxygenNet: -1, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 0,
            mustBorderEdge: true, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.habS", kind: .habSmall, name: "Small Habitat",
            summary: "Sleeping quarters for 2 crew.",
            footprint: GridSize(w: 1, h: 2), category: .hab,
            buildCostParts: 70, buildCostCredits: 40, buildDays: 1,
            powerNet: -1, oxygenNet: -1, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 2,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.habL", kind: .habLarge, name: "Large Habitat",
            summary: "Comfortable suite for 4 crew. Boosts morale.",
            footprint: GridSize(w: 2, h: 2), category: .hab,
            buildCostParts: 140, buildCostCredits: 110, buildDays: 2,
            powerNet: -2, oxygenNet: -2, waterNet: -2, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 4,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: true,
            phaseUnlock: .stabilization, requiresResearchId: nil,
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.galley", kind: .galley, name: "Galley",
            summary: "Hot meals. Boosts crew morale on assigned days.",
            footprint: GridSize(w: 2, h: 1), category: .hab,
            buildCostParts: 80, buildCostCredits: 60, buildDays: 2,
            powerNet: -1, oxygenNet: 0, waterNet: -1, foodNet: 1,
            researchPerCrew: 0.0, crewSlots: 1,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: .cook
        ),
        ModuleSpec(
            id: "m.cargo", kind: .cargo, name: "Cargo Hold",
            summary: "Storage capacity boost. Idle module.",
            footprint: GridSize(w: 2, h: 2), category: .ops,
            buildCostParts: 60, buildCostCredits: 30, buildDays: 1,
            powerNet: 0, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 0,
            mustBorderEdge: false, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .pioneering, requiresResearchId: nil,
            preferredRole: .quartermaster
        ),
        ModuleSpec(
            id: "m.obs", kind: .observation, name: "Observation Deck",
            summary: "Stellar observation. Slight research, big morale.",
            footprint: GridSize(w: 2, h: 1), category: .science,
            buildCostParts: 130, buildCostCredits: 90, buildDays: 2,
            powerNet: -1, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.6, crewSlots: 1,
            mustBorderEdge: true, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .stabilization, requiresResearchId: nil,
            preferredRole: .scientist
        ),
        ModuleSpec(
            id: "m.shop", kind: .machineShop, name: "Machine Shop",
            summary: "Produces parts at a power cost.",
            footprint: GridSize(w: 2, h: 2), category: .ops,
            buildCostParts: 160, buildCostCredits: 120, buildDays: 3,
            powerNet: -3, oxygenNet: 0, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 2,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .stabilization, requiresResearchId: "r.eng.fab1",
            preferredRole: .maintenance
        ),
        ModuleSpec(
            id: "m.comms", kind: .comms, name: "Comms Array",
            summary: "Receives trader / signal incidents more often.",
            footprint: GridSize(w: 1, h: 2), category: .ops,
            buildCostParts: 100, buildCostCredits: 90, buildDays: 2,
            powerNet: -2, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.3, crewSlots: 1,
            mustBorderEdge: true, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .stabilization, requiresResearchId: nil,
            preferredRole: .comms
        ),
        ModuleSpec(
            id: "m.rec", kind: .recreation, name: "Recreation Room",
            summary: "Replenishes morale for assigned crew.",
            footprint: GridSize(w: 2, h: 1), category: .hab,
            buildCostParts: 90, buildCostCredits: 80, buildDays: 2,
            powerNet: -1, oxygenNet: 0, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 2,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: false,
            phaseUnlock: .stabilization, requiresResearchId: nil,
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.sgreen", kind: .scienceGreenhouse, name: "Science Greenhouse",
            summary: "Biology-focused. Generates research + food.",
            footprint: GridSize(w: 2, h: 2), category: .science,
            buildCostParts: 180, buildCostCredits: 150, buildDays: 3,
            powerNet: -3, oxygenNet: 2, waterNet: -3, foodNet: 3,
            researchPerCrew: 1.0, crewSlots: 2,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: true,
            phaseUnlock: .expansion, requiresResearchId: "r.bio.green2",
            preferredRole: .botanist
        ),
        ModuleSpec(
            id: "m.fuel", kind: .fuelTank, name: "Fuel Tank",
            summary: "Stores starship-grade fuel. Required for warp.",
            footprint: GridSize(w: 1, h: 2), category: .special,
            buildCostParts: 200, buildCostCredits: 100, buildDays: 3,
            powerNet: -1, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 0,
            mustBorderEdge: true, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .crisis, requiresResearchId: "r.log.fuel1",
            preferredRole: nil
        ),
        ModuleSpec(
            id: "m.warp", kind: .warpCore, name: "Warp Core",
            summary: "Endgame. 30-day construction. Requires 8 keystone projects.",
            footprint: GridSize(w: 2, h: 2), category: .special,
            buildCostParts: 6000, buildCostCredits: 2500, buildDays: 30,
            powerNet: -8, oxygenNet: 0, waterNet: 0, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 3,
            mustBorderEdge: false, needsAdjacentPower: true, needsAdjacentLifeSupport: true,
            phaseUnlock: .preWarp, requiresResearchId: "r.astro.warp4",
            preferredRole: .engineer
        ),
        ModuleSpec(
            id: "m.botany", kind: .botany, name: "Botany Annex",
            summary: "Cosmetic annex linked to greenhouse research.",
            footprint: GridSize(w: 1, h: 1), category: .hab,
            buildCostParts: 50, buildCostCredits: 40, buildDays: 1,
            powerNet: 0, oxygenNet: 1, waterNet: -1, foodNet: 0,
            researchPerCrew: 0.0, crewSlots: 0,
            mustBorderEdge: false, needsAdjacentPower: false, needsAdjacentLifeSupport: false,
            phaseUnlock: .expansion, requiresResearchId: "r.bio.green2",
            preferredRole: .botanist
        ),
    ]

    static func module(_ kind: ModuleKind) -> ModuleSpec {
        return modules.first(where: { $0.kind == kind }) ?? modules[0]
    }

    // MARK: Traits (32)

    static let traits: [TraitSpec] = [
        TraitSpec(id: .ambitious, name: "Ambitious",
                  effect: "+6 skill while assigned to work; +0.1x morale decay.",
                  skillMod: 6, stressGainMod: 1.0, moraleDecayMod: 1.1,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.05, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .paranoid, name: "Paranoid",
                  effect: "+10% accuracy in security tasks. 5% chance to refuse mysterious events.",
                  skillMod: 0, stressGainMod: 1.05, moraleDecayMod: 1.0,
                  conflictChanceMod: 0.04, refuseMysteryChance: 0.05,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0.10),
        TraitSpec(id: .quiet, name: "Quiet",
                  effect: "-0.2x conflict chance. Slow morale recovery in groups.",
                  skillMod: 0, stressGainMod: 0.9, moraleDecayMod: 1.05,
                  conflictChanceMod: -0.20, refuseMysteryChance: 0,
                  researchMod: 1.02, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .loyal, name: "Loyal",
                  effect: "Will not desert. Lowers global crisis chance.",
                  skillMod: 2, stressGainMod: 0.95, moraleDecayMod: 0.9,
                  conflictChanceMod: -0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .abrasive, name: "Abrasive",
                  effect: "+0.25x conflict chance among crew.",
                  skillMod: 1, stressGainMod: 1.0, moraleDecayMod: 1.1,
                  conflictChanceMod: 0.25, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .religious, name: "Religious",
                  effect: "Stable morale. -0.15x stress gain.",
                  skillMod: 0, stressGainMod: 0.85, moraleDecayMod: 0.85,
                  conflictChanceMod: -0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .prankster, name: "Prankster",
                  effect: "+1 morale per day to crew nearby. +0.15x conflict chance.",
                  skillMod: 0, stressGainMod: 0.95, moraleDecayMod: 0.85,
                  conflictChanceMod: 0.15, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .loneWolf, name: "Lone Wolf",
                  effect: "Best in single-slot modules. Penalizes social events.",
                  skillMod: 3, stressGainMod: 1.0, moraleDecayMod: 1.1,
                  conflictChanceMod: 0.10, refuseMysteryChance: 0,
                  researchMod: 1.05, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .methodical, name: "Methodical",
                  effect: "+8% research output. Slower morale recovery.",
                  skillMod: 1, stressGainMod: 0.95, moraleDecayMod: 1.05,
                  conflictChanceMod: -0.05, refuseMysteryChance: 0,
                  researchMod: 1.08, medicalBonus: 0, mechanicalBonus: 0.05, securityBonus: 0),
        TraitSpec(id: .optimist, name: "Optimist",
                  effect: "Slower morale decay. Easier crisis recovery.",
                  skillMod: 0, stressGainMod: 0.85, moraleDecayMod: 0.8,
                  conflictChanceMod: -0.10, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .pessimist, name: "Pessimist",
                  effect: "Faster morale decay. Reads risk well.",
                  skillMod: 1, stressGainMod: 1.10, moraleDecayMod: 1.2,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0.05),
        TraitSpec(id: .insomniac, name: "Insomniac",
                  effect: "+15% fatigue gain. +0.05 conflict.",
                  skillMod: 0, stressGainMod: 1.1, moraleDecayMod: 1.1,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .claustrophobic, name: "Claustrophobic",
                  effect: "+0.2 stress while station fills up.",
                  skillMod: 0, stressGainMod: 1.20, moraleDecayMod: 1.1,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .daredevil, name: "Daredevil",
                  effect: "Better at EVA / risky picks. Higher stress.",
                  skillMod: 4, stressGainMod: 1.15, moraleDecayMod: 1.0,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0.05, securityBonus: 0.05),
        TraitSpec(id: .stoic, name: "Stoic",
                  effect: "-0.25x stress gain. Average everything else.",
                  skillMod: 0, stressGainMod: 0.75, moraleDecayMod: 0.95,
                  conflictChanceMod: -0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .hothead, name: "Hothead",
                  effect: "High output, very high conflict chance.",
                  skillMod: 4, stressGainMod: 1.1, moraleDecayMod: 1.1,
                  conflictChanceMod: 0.30, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0.05, securityBonus: 0.05),
        TraitSpec(id: .mentor, name: "Mentor",
                  effect: "Trains nearby crew passively.",
                  skillMod: 2, stressGainMod: 0.95, moraleDecayMod: 0.9,
                  conflictChanceMod: -0.10, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .ironStomach, name: "Iron Stomach",
                  effect: "Eats less food per day.",
                  skillMod: 0, stressGainMod: 1.0, moraleDecayMod: 1.0,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .frail, name: "Frail",
                  effect: "Higher injury chance during incidents.",
                  skillMod: -2, stressGainMod: 1.1, moraleDecayMod: 1.0,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .photoMemory, name: "Photographic",
                  effect: "+12% research output. Reads anomalies faster.",
                  skillMod: 2, stressGainMod: 1.0, moraleDecayMod: 1.05,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.12, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .nightOwl, name: "Night Owl",
                  effect: "Better night-shift performance.",
                  skillMod: 1, stressGainMod: 1.0, moraleDecayMod: 1.0,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .earlyRiser, name: "Early Riser",
                  effect: "Skips fatigue penalty on first task of the day.",
                  skillMod: 1, stressGainMod: 0.95, moraleDecayMod: 0.95,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .perfectionist, name: "Perfectionist",
                  effect: "Slower, but cuts failure odds.",
                  skillMod: 3, stressGainMod: 1.10, moraleDecayMod: 1.05,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.06, medicalBonus: 0.04, mechanicalBonus: 0.08, securityBonus: 0),
        TraitSpec(id: .gambler, name: "Gambler",
                  effect: "Pushes risky incident choices. Periodic credit swings.",
                  skillMod: 0, stressGainMod: 1.05, moraleDecayMod: 1.0,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .sleeper, name: "Heavy Sleeper",
                  effect: "Recovers a lot of fatigue when resting.",
                  skillMod: 0, stressGainMod: 0.95, moraleDecayMod: 1.0,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .hoarder, name: "Hoarder",
                  effect: "+1 part per cargo per day.",
                  skillMod: 0, stressGainMod: 1.0, moraleDecayMod: 1.0,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0.05, securityBonus: 0),
        TraitSpec(id: .empath, name: "Empath",
                  effect: "Big morale boost for nearby crew.",
                  skillMod: 0, stressGainMod: 0.9, moraleDecayMod: 0.8,
                  conflictChanceMod: -0.15, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0.05, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .cynic, name: "Cynic",
                  effect: "Resists manipulation. Loses morale faster.",
                  skillMod: 1, stressGainMod: 1.0, moraleDecayMod: 1.15,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .restless, name: "Restless",
                  effect: "Generates more action; bad at long-rest.",
                  skillMod: 2, stressGainMod: 1.0, moraleDecayMod: 1.05,
                  conflictChanceMod: 0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0.05, securityBonus: 0),
        TraitSpec(id: .dreamer, name: "Dreamer",
                  effect: "+5% astrophysics research. Slow conflicts.",
                  skillMod: 0, stressGainMod: 0.95, moraleDecayMod: 0.95,
                  conflictChanceMod: -0.10, refuseMysteryChance: 0,
                  researchMod: 1.05, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .dutiful, name: "Dutiful",
                  effect: "Never refuses a duty. Stable everything.",
                  skillMod: 1, stressGainMod: 0.95, moraleDecayMod: 0.95,
                  conflictChanceMod: -0.05, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
        TraitSpec(id: .jaded, name: "Jaded",
                  effect: "Ignores morale events. Hard to retrain.",
                  skillMod: 0, stressGainMod: 0.95, moraleDecayMod: 0.95,
                  conflictChanceMod: 0, refuseMysteryChance: 0,
                  researchMod: 1.0, medicalBonus: 0, mechanicalBonus: 0, securityBonus: 0),
    ]

    static func trait(_ id: TraitId) -> TraitSpec {
        return traits.first(where: { $0.id == id }) ?? traits[0]
    }

    // MARK: Research (80+)

    static let research: [ResearchSpec] = makeResearchCatalog()

    private static func makeResearchCatalog() -> [ResearchSpec] {
        var list: [ResearchSpec] = []

        // ENGINEERING (17)
        list.append(ResearchSpec(id: "r.eng.power1", branch: .engineering, tier: 1,
            name: "Optimized Power Routing",
            summary: "+5% power efficiency across station.",
            pointsRequired: 30, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.fab1", branch: .engineering, tier: 1,
            name: "Basic Fabrication",
            summary: "Unlocks Machine Shop.",
            pointsRequired: 40, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.airfilters", branch: .engineering, tier: 1,
            name: "Air Filter Recycling",
            summary: "+10% oxygen output in life support modules.",
            pointsRequired: 35, prereqIds: ["r.eng.power1"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.lab2", branch: .engineering, tier: 2,
            name: "Advanced Lab Build",
            summary: "Unlocks Advanced Lab construction.",
            pointsRequired: 80, prereqIds: ["r.eng.fab1"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.dampers", branch: .engineering, tier: 2,
            name: "Vibration Dampers",
            summary: "-20% chance of part-leak incidents.",
            pointsRequired: 70, prereqIds: ["r.eng.airfilters"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.solar2", branch: .engineering, tier: 2,
            name: "Bifacial Solar",
            summary: "+2 power per solar array.",
            pointsRequired: 65, prereqIds: ["r.eng.power1"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.welds", branch: .engineering, tier: 2,
            name: "Composite Welds",
            summary: "Module construction days -1 (min 1).",
            pointsRequired: 75, prereqIds: ["r.eng.fab1"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.fab2", branch: .engineering, tier: 3,
            name: "Precision Fab",
            summary: "+1 part per Machine Shop crew per day.",
            pointsRequired: 110, prereqIds: ["r.eng.welds"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.power2", branch: .engineering, tier: 3,
            name: "High-Density Cells",
            summary: "+2 power per Power Cell Bank.",
            pointsRequired: 100, prereqIds: ["r.eng.solar2"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.thermal", branch: .engineering, tier: 3,
            name: "Thermal Mesh",
            summary: "Crew assigned to power lose less fatigue.",
            pointsRequired: 95, prereqIds: ["r.eng.dampers"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.diag", branch: .engineering, tier: 3,
            name: "Diagnostics Suite",
            summary: "Technical incident chance -10%.",
            pointsRequired: 105, prereqIds: ["r.eng.welds"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.power3", branch: .engineering, tier: 4,
            name: "Fusion Pre-Studies",
            summary: "Required for warp containment.",
            pointsRequired: 150, prereqIds: ["r.eng.power2"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.eng.shield1", branch: .engineering, tier: 4,
            name: "Mag-Shield Prototype",
            summary: "External-event severity -20%.",
            pointsRequired: 140, prereqIds: ["r.eng.thermal"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.fab3", branch: .engineering, tier: 4,
            name: "Closed-Loop Fab",
            summary: "Machine Shop parts +50%.",
            pointsRequired: 145, prereqIds: ["r.eng.fab2"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.containment", branch: .engineering, tier: 5,
            name: "Warp Containment Field",
            summary: "Warp keystone.",
            pointsRequired: 220, prereqIds: ["r.eng.power3"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.eng.repair", branch: .engineering, tier: 4,
            name: "Field Repair Drones",
            summary: "Tech incidents resolve auto on a 20% roll.",
            pointsRequired: 130, prereqIds: ["r.eng.diag"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.eng.frame", branch: .engineering, tier: 5,
            name: "Reinforced Frame",
            summary: "Tier 5 hull frame upgrade.",
            pointsRequired: 200, prereqIds: ["r.eng.shield1"], labTierRequired: 2, warpCoreKey: false))

        // BIOLOGY (16)
        list.append(ResearchSpec(id: "r.bio.algae", branch: .biology, tier: 1,
            name: "Fast Algae",
            summary: "+1 food per Hydroponics.",
            pointsRequired: 30, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.seeds", branch: .biology, tier: 1,
            name: "Seed Library",
            summary: "Hydroponics water cost -1.",
            pointsRequired: 40, prereqIds: ["r.bio.algae"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.green2", branch: .biology, tier: 2,
            name: "Greenhouse Build",
            summary: "Unlocks Science Greenhouse + Botany Annex.",
            pointsRequired: 80, prereqIds: ["r.bio.seeds"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.symbiosis", branch: .biology, tier: 2,
            name: "Algae Symbiosis",
            summary: "Hydroponics oxygen +1.",
            pointsRequired: 70, prereqIds: ["r.bio.algae"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.gene1", branch: .biology, tier: 3,
            name: "Field Genetics",
            summary: "Greenhouse research +0.4 per crew.",
            pointsRequired: 105, prereqIds: ["r.bio.green2"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.compost", branch: .biology, tier: 2,
            name: "Composter",
            summary: "Recycles waste for food/water.",
            pointsRequired: 60, prereqIds: ["r.bio.symbiosis"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.tissue", branch: .biology, tier: 3,
            name: "Tissue Culture",
            summary: "Medicine yield +1 per Med Bay tick.",
            pointsRequired: 110, prereqIds: ["r.bio.gene1"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.gravplant", branch: .biology, tier: 3,
            name: "Microgravity Plant Stock",
            summary: "Greenhouse food +1.",
            pointsRequired: 100, prereqIds: ["r.bio.green2"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.crop3", branch: .biology, tier: 4,
            name: "Synthetic Crops",
            summary: "Food network +20% across all greens.",
            pointsRequired: 150, prereqIds: ["r.bio.gravplant"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.gene2", branch: .biology, tier: 4,
            name: "Cellular Repair",
            summary: "Crew injury recovery is 2x.",
            pointsRequired: 140, prereqIds: ["r.bio.tissue"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.warpflora", branch: .biology, tier: 5,
            name: "Warp-Compatible Flora",
            summary: "Warp keystone — life support for jump.",
            pointsRequired: 210, prereqIds: ["r.bio.crop3"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.bio.mycology", branch: .biology, tier: 2,
            name: "Mycology",
            summary: "+5% morale globally.",
            pointsRequired: 65, prereqIds: ["r.bio.compost"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.bact", branch: .biology, tier: 3,
            name: "Bacteriology",
            summary: "Med incidents -10%.",
            pointsRequired: 95, prereqIds: ["r.bio.tissue"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.zero", branch: .biology, tier: 4,
            name: "Zero-G Biome",
            summary: "Greenhouse adjacency unlocks bonus.",
            pointsRequired: 135, prereqIds: ["r.bio.crop3"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.flag", branch: .biology, tier: 4,
            name: "Flagship Crops",
            summary: "+1 morale every 3 days.",
            pointsRequired: 130, prereqIds: ["r.bio.gravplant"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.bio.cycle", branch: .biology, tier: 5,
            name: "Closed Biome",
            summary: "Fully closed biological loop.",
            pointsRequired: 200, prereqIds: ["r.bio.warpflora"], labTierRequired: 2, warpCoreKey: false))

        // ASTROPHYSICS (16)
        list.append(ResearchSpec(id: "r.astro.optics", branch: .astrophysics, tier: 1,
            name: "Survey Optics",
            summary: "Observation deck +0.3 research.",
            pointsRequired: 35, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.charts", branch: .astrophysics, tier: 1,
            name: "Charting Models",
            summary: "Comms incidents -10%.",
            pointsRequired: 30, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.specs", branch: .astrophysics, tier: 2,
            name: "Spectrograph",
            summary: "+1 research per Observation Deck crew.",
            pointsRequired: 80, prereqIds: ["r.astro.optics"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.deepfield", branch: .astrophysics, tier: 2,
            name: "Deep Field Lensing",
            summary: "Unlocks anomaly logs.",
            pointsRequired: 70, prereqIds: ["r.astro.charts"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.metric", branch: .astrophysics, tier: 3,
            name: "Metric Distortion",
            summary: "Pre-warp baseline.",
            pointsRequired: 105, prereqIds: ["r.astro.specs"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.relay", branch: .astrophysics, tier: 3,
            name: "Phase Relay",
            summary: "Trader rate +20%.",
            pointsRequired: 100, prereqIds: ["r.astro.deepfield"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.field", branch: .astrophysics, tier: 4,
            name: "Field Equations",
            summary: "Foundational warp-field equations.",
            pointsRequired: 140, prereqIds: ["r.astro.metric"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.warp1", branch: .astrophysics, tier: 4,
            name: "Warp Spool I",
            summary: "Warp keystone.",
            pointsRequired: 150, prereqIds: ["r.astro.field"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.astro.warp2", branch: .astrophysics, tier: 5,
            name: "Warp Spool II",
            summary: "Tier 5 warp spool refinement.",
            pointsRequired: 170, prereqIds: ["r.astro.warp1"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.warp3", branch: .astrophysics, tier: 5,
            name: "Warp Spool III",
            summary: "Tier 5 warp spool tuning.",
            pointsRequired: 190, prereqIds: ["r.astro.warp2"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.warp4", branch: .astrophysics, tier: 5,
            name: "Warp Core Theory",
            summary: "Unlocks Warp Core construction.",
            pointsRequired: 240, prereqIds: ["r.astro.warp3"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.astro.beacon", branch: .astrophysics, tier: 3,
            name: "Long Beacons",
            summary: "Comms gives +1 research per day.",
            pointsRequired: 95, prereqIds: ["r.astro.relay"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.driftmap", branch: .astrophysics, tier: 2,
            name: "Drift Maps",
            summary: "Anomaly hint rate +25%.",
            pointsRequired: 70, prereqIds: ["r.astro.deepfield"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.gyro", branch: .astrophysics, tier: 3,
            name: "Gyro Stabilization",
            summary: "Reduces some external incidents.",
            pointsRequired: 90, prereqIds: ["r.astro.specs"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.tachy", branch: .astrophysics, tier: 4,
            name: "Tachyon Modeling",
            summary: "+5% research everywhere.",
            pointsRequired: 130, prereqIds: ["r.astro.field"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.astro.observe", branch: .astrophysics, tier: 2,
            name: "Sky Watcher Rota",
            summary: "Observation morale +1 per day.",
            pointsRequired: 60, prereqIds: ["r.astro.optics"], labTierRequired: 1, warpCoreKey: false))

        // MEDICINE (16)
        list.append(ResearchSpec(id: "r.med.firstaid", branch: .medicine, tier: 1,
            name: "Updated First Aid",
            summary: "Medical incident damage -15%.",
            pointsRequired: 30, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.psych", branch: .medicine, tier: 1,
            name: "Crew Psych Sessions",
            summary: "Stress decay +20% in rest.",
            pointsRequired: 35, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.bay2", branch: .medicine, tier: 2,
            name: "Med Bay Upgrades",
            summary: "Med Bay holds +1 slot.",
            pointsRequired: 75, prereqIds: ["r.med.firstaid"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.synthmeds", branch: .medicine, tier: 2,
            name: "Synth Meds",
            summary: "+1 medicine produced per Med Bay day.",
            pointsRequired: 80, prereqIds: ["r.med.firstaid"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.surgery", branch: .medicine, tier: 3,
            name: "Field Surgery",
            summary: "Fatal injury chance -50%.",
            pointsRequired: 110, prereqIds: ["r.med.bay2"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.cryo", branch: .medicine, tier: 3,
            name: "Cryo Protocols",
            summary: "Warp keystone — crew prep.",
            pointsRequired: 130, prereqIds: ["r.med.synthmeds"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.med.vax", branch: .medicine, tier: 2,
            name: "Vaccination Loop",
            summary: "Illness pool size -1.",
            pointsRequired: 70, prereqIds: ["r.med.psych"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.gene", branch: .medicine, tier: 4,
            name: "Genetic Therapy",
            summary: "Crew skill recovery +5%.",
            pointsRequired: 135, prereqIds: ["r.med.surgery"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.dream", branch: .medicine, tier: 3,
            name: "Sleep Cycles",
            summary: "Fatigue drop +10% during Rest.",
            pointsRequired: 100, prereqIds: ["r.med.psych"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.bay3", branch: .medicine, tier: 4,
            name: "Trauma Center",
            summary: "Med Bay halves medical incident severity.",
            pointsRequired: 140, prereqIds: ["r.med.surgery"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.warp", branch: .medicine, tier: 5,
            name: "Warp Adaptation",
            summary: "Long-haul crew warp tolerance.",
            pointsRequired: 210, prereqIds: ["r.med.cryo"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.bionics", branch: .medicine, tier: 4,
            name: "Bionic Patches",
            summary: "Crew skill +1 globally.",
            pointsRequired: 145, prereqIds: ["r.med.gene"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.spore", branch: .medicine, tier: 3,
            name: "Sporecounter",
            summary: "Removes biology-injury incidents.",
            pointsRequired: 100, prereqIds: ["r.med.vax"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.therapy", branch: .medicine, tier: 2,
            name: "Group Therapy",
            summary: "Recreation morale +1 per crew.",
            pointsRequired: 60, prereqIds: ["r.med.psych"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.empath", branch: .medicine, tier: 3,
            name: "Empath Training",
            summary: "Reduces conflict ticks by 20%.",
            pointsRequired: 95, prereqIds: ["r.med.therapy"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.med.tetra", branch: .medicine, tier: 4,
            name: "Tetra-Patch",
            summary: "Medicine inventory cap +50.",
            pointsRequired: 125, prereqIds: ["r.med.synthmeds"], labTierRequired: 2, warpCoreKey: false))

        // LOGISTICS (17)
        list.append(ResearchSpec(id: "r.log.invent", branch: .logistics, tier: 1,
            name: "Inventory Pass",
            summary: "Cargo modules cost -10%.",
            pointsRequired: 30, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.trade", branch: .logistics, tier: 1,
            name: "Trade Protocols",
            summary: "Trader credit price -10%.",
            pointsRequired: 35, prereqIds: [], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.fuel1", branch: .logistics, tier: 2,
            name: "Fuel Containment",
            summary: "Unlocks Fuel Tank.",
            pointsRequired: 90, prereqIds: ["r.log.trade"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.scheduler", branch: .logistics, tier: 2,
            name: "Auto-Scheduler",
            summary: "Crew fatigue gain -10%.",
            pointsRequired: 65, prereqIds: ["r.log.invent"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.bulk", branch: .logistics, tier: 3,
            name: "Bulk Sourcing",
            summary: "Trader incoming parts +25%.",
            pointsRequired: 100, prereqIds: ["r.log.trade"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.docking", branch: .logistics, tier: 2,
            name: "Docking Codes",
            summary: "Airlock construction days -1.",
            pointsRequired: 60, prereqIds: ["r.log.invent"], labTierRequired: 1, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.fuel2", branch: .logistics, tier: 3,
            name: "Fuel Conditioning",
            summary: "Fuel Tank stores +50% fuel.",
            pointsRequired: 110, prereqIds: ["r.log.fuel1"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.contracts", branch: .logistics, tier: 3,
            name: "Standing Contracts",
            summary: "+25 credits every 5 days.",
            pointsRequired: 95, prereqIds: ["r.log.bulk"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.couriers", branch: .logistics, tier: 4,
            name: "Courier Rota",
            summary: "Opportunity incident chance +15%.",
            pointsRequired: 130, prereqIds: ["r.log.contracts"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.fuel3", branch: .logistics, tier: 4,
            name: "Cryo Fuel",
            summary: "Warp keystone.",
            pointsRequired: 150, prereqIds: ["r.log.fuel2"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.log.refit", branch: .logistics, tier: 4,
            name: "Modular Refit",
            summary: "Module refunds 60% parts on remove.",
            pointsRequired: 140, prereqIds: ["r.log.docking"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.warpfuel", branch: .logistics, tier: 5,
            name: "Antimatter Tanking",
            summary: "Warp keystone.",
            pointsRequired: 210, prereqIds: ["r.log.fuel3"], labTierRequired: 2, warpCoreKey: true))
        list.append(ResearchSpec(id: "r.log.market", branch: .logistics, tier: 3,
            name: "Market Charts",
            summary: "Trader visits +1 per cycle.",
            pointsRequired: 85, prereqIds: ["r.log.bulk"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.export", branch: .logistics, tier: 4,
            name: "Export Permits",
            summary: "Sell parts at +30%.",
            pointsRequired: 125, prereqIds: ["r.log.market"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.scout", branch: .logistics, tier: 3,
            name: "Scout Drones",
            summary: "Get 1 anomaly hint per 10 days.",
            pointsRequired: 90, prereqIds: ["r.log.docking"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.fleet", branch: .logistics, tier: 4,
            name: "Auxiliary Fleet",
            summary: "+1 trader / 7 days.",
            pointsRequired: 145, prereqIds: ["r.log.export"], labTierRequired: 2, warpCoreKey: false))
        list.append(ResearchSpec(id: "r.log.failover", branch: .logistics, tier: 3,
            name: "Failover Routing",
            summary: "Resource shortfall delay +1 tick.",
            pointsRequired: 95, prereqIds: ["r.log.scheduler"], labTierRequired: 2, warpCoreKey: false))

        return list
    }

    static func research(_ id: String) -> ResearchSpec? {
        return research.first(where: { $0.id == id })
    }

    /// the 8 keystone research project ids that unlock warp core completion
    static let warpKeystoneIds: [String] = [
        "r.eng.power3", "r.eng.containment",
        "r.astro.warp1", "r.astro.warp4",
        "r.bio.warpflora",
        "r.med.cryo",
        "r.log.fuel3", "r.log.warpfuel"
    ]

    // MARK: Anomalies (40)

    static let anomalies: [AnomalyEntry] = [
        AnomalyEntry(id: "a.01", title: "Tessellated Light",
                     text: "On Day 8, observation lens caught a regular tessellation of light banding across the gas giant's dark side. No transmission, no echo. The pattern repeats every 19 hours.",
                     revealHint: "Observation deck, late shift."),
        AnomalyEntry(id: "a.02", title: "Ledger of Names",
                     text: "Crewman Aoki found her own birth city listed in a 'ledger of names' our comms array transcribed from background noise.",
                     revealHint: "Trader incident, decline payment."),
        AnomalyEntry(id: "a.03", title: "Cold Helix",
                     text: "A near-frozen helical thread coiled inside a fuel filter. Botany dispute on whether it's alive.",
                     revealHint: "Hydroponics filter incident."),
        AnomalyEntry(id: "a.04", title: "Bell on the Hull",
                     text: "A sound like a slow bell every 4 hours, only heard inside the airlock. Engineering blames pressure cycling. No one believes them.",
                     revealHint: "Airlock-related incident."),
        AnomalyEntry(id: "a.05", title: "False Sunrise",
                     text: "For 11 seconds, the station's east horizon lit as if dawn — but we orbit a brown dwarf. No telemetry record.",
                     revealHint: "Observation deck pick."),
        AnomalyEntry(id: "a.06", title: "Ghost Bunk",
                     text: "Bunk 4 in Habitat 2 records weight on the mattress every Thursday night, even when assigned crew is on rotation elsewhere.",
                     revealHint: "Social incident, sleep check."),
        AnomalyEntry(id: "a.07", title: "Drifter's Recipe",
                     text: "Cook discovered a recipe etched on the underside of a galley tray. Pre-dates this station's keel-laying by a year.",
                     revealHint: "Galley incident."),
        AnomalyEntry(id: "a.08", title: "Echo of the Captain",
                     text: "Voice authentication accepted the captain's command when she was asleep. The voice on the recording is not hers.",
                     revealHint: "Command deck event."),
        AnomalyEntry(id: "a.09", title: "Counted Stars",
                     text: "Researcher Ostrov counted 1,419 stars in window 9. Next morning, 1,420. The crew has stopped asking.",
                     revealHint: "Observation, repeated."),
        AnomalyEntry(id: "a.10", title: "Soft Hum",
                     text: "Every researcher who falls asleep in Lab 1 reports the same hum: B-flat, 18 cycles per second.",
                     revealHint: "Lab fatigue incident."),
        AnomalyEntry(id: "a.11", title: "Twin Reflection",
                     text: "Engineer Petriv saw his reflection turn before he did, twice in three days.",
                     revealHint: "Engineering social event."),
        AnomalyEntry(id: "a.12", title: "Distant Door",
                     text: "Door logs show one open/close on Habitat 3 every 41 hours. There is no door at that section.",
                     revealHint: "Maintenance event."),
        AnomalyEntry(id: "a.13", title: "Patient Zero",
                     text: "The first medical case logged on station bears a date 14 days before the station was crewed.",
                     revealHint: "Med Bay long-rest."),
        AnomalyEntry(id: "a.14", title: "Smile in the Code",
                     text: "A diagnostic terminal displays a brief curve in the load graph that looks like a smile.",
                     revealHint: "Diagnostics research."),
        AnomalyEntry(id: "a.15", title: "Salt on the Hull",
                     text: "EVA crew brought back saltwater residue. The nearest ocean is 11 light years away.",
                     revealHint: "EVA incident."),
        AnomalyEntry(id: "a.16", title: "Field Note",
                     text: "A field note was left in the science greenhouse, signed by a botanist who is not yet on the manifest.",
                     revealHint: "Greenhouse incident."),
        AnomalyEntry(id: "a.17", title: "Drift Signal",
                     text: "A repeating 7-tone signal from outside any known catalog. It speeds up by 0.04% every day.",
                     revealHint: "Comms event."),
        AnomalyEntry(id: "a.18", title: "Empty Suit",
                     text: "EVA suit 4 returned to dock empty. The harness was buckled from the inside.",
                     revealHint: "Airlock incident."),
        AnomalyEntry(id: "a.19", title: "Vellum",
                     text: "A folded slip of vellum found in the air filter. Names of all current crew, written in clean ink, with future dates beside each.",
                     revealHint: "Life support incident."),
        AnomalyEntry(id: "a.20", title: "Long Silence",
                     text: "For 22 minutes on Day 70, every speaker on station fell silent — even the alarms.",
                     revealHint: "Stabilization phase."),
        AnomalyEntry(id: "a.21", title: "Mirror Plant",
                     text: "A tomato vine in the greenhouse grew downward and produced fruit pointing inward.",
                     revealHint: "Botany incident."),
        AnomalyEntry(id: "a.22", title: "Snow on Hydro",
                     text: "Snow accumulated on the inside of Hydroponics tank 2. Internal temperature normal.",
                     revealHint: "Hydroponics late-day."),
        AnomalyEntry(id: "a.23", title: "Wax Seal",
                     text: "A wax seal arrived with a freighter, addressed to the captain. The wax is older than any sealed letter on file.",
                     revealHint: "Trader event."),
        AnomalyEntry(id: "a.24", title: "Drift Choir",
                     text: "Three crew members independently hummed the same melody on the same day. None know its origin.",
                     revealHint: "Recreation event."),
        AnomalyEntry(id: "a.25", title: "Folded Star",
                     text: "Astrophysics modeled a star folded along its own axis. Re-run produced different folds each time.",
                     revealHint: "Astrophysics research."),
        AnomalyEntry(id: "a.26", title: "Shoe at Airlock",
                     text: "A child's shoe was found at airlock 1, dry on top, wet underneath.",
                     revealHint: "External incident."),
        AnomalyEntry(id: "a.27", title: "Soft Window",
                     text: "Observation window 3 displaced 4cm overnight and returned by morning. Logs unbroken.",
                     revealHint: "Observation maintenance."),
        AnomalyEntry(id: "a.28", title: "Counted Coats",
                     text: "Coat rack in Habitat 1 always has one more coat than the manifest.",
                     revealHint: "Habitat social event."),
        AnomalyEntry(id: "a.29", title: "Long Letter",
                     text: "Comms received a 90,000-word letter signed by the station, to the station.",
                     revealHint: "Comms long event."),
        AnomalyEntry(id: "a.30", title: "Slow Frame",
                     text: "Frame 49 of the engineering camera holds the same image for 5 minutes once a day.",
                     revealHint: "Engineering diagnostic."),
        AnomalyEntry(id: "a.31", title: "Cookhouse Smoke",
                     text: "Galley vent smoke draws a calligraphic character we can't translate.",
                     revealHint: "Galley event."),
        AnomalyEntry(id: "a.32", title: "Two-Voiced Call",
                     text: "A radio call came through in two voices speaking the same sentence on a one-second delay.",
                     revealHint: "Comms event."),
        AnomalyEntry(id: "a.33", title: "Wet Footprints",
                     text: "Wet footprints across the dry hangar floor — both feet right.",
                     revealHint: "Maintenance event."),
        AnomalyEntry(id: "a.34", title: "Bottle Letter",
                     text: "A sealed glass bottle bobbed against the docking ring. Inside, a star chart we haven't drawn yet.",
                     revealHint: "External opportunity."),
        AnomalyEntry(id: "a.35", title: "Crew of Ten Thousand",
                     text: "A roster appeared briefly on the manifest terminal: ten thousand crew names, all with our station ID.",
                     revealHint: "Crisis phase."),
        AnomalyEntry(id: "a.36", title: "Drift Visit",
                     text: "A stranger walked the central hub in a flightsuit from 80 years ago, said hello, and never reappeared.",
                     revealHint: "Crisis phase social."),
        AnomalyEntry(id: "a.37", title: "Empty Probe",
                     text: "Our recovered survey probe returned with no instruments — yet it transmitted readings the whole way.",
                     revealHint: "Pre-warp astrophysics."),
        AnomalyEntry(id: "a.38", title: "Star at the Door",
                     text: "An apparent star inside our docking bay, no larger than a candle flame, hovered for a minute.",
                     revealHint: "Pre-warp event."),
        AnomalyEntry(id: "a.39", title: "Drift Map",
                     text: "Long-range maps now show our station at multiple positions simultaneously.",
                     revealHint: "Warp prep."),
        AnomalyEntry(id: "a.40", title: "First Word",
                     text: "On the day the warp core spins up, an unknown voice spoke a single word over the PA. None of the crew said it.",
                     revealHint: "Warp launch."),
    ]

    static func anomaly(_ id: String) -> AnomalyEntry? {
        return anomalies.first(where: { $0.id == id })
    }

    // MARK: Incidents (40+)

    static let incidents: [IncidentSpec] = makeIncidents()

    private static func makeIncidents() -> [IncidentSpec] {
        var list: [IncidentSpec] = []

        // TECHNICAL (10)
        list.append(IncidentSpec(id: "i.tech.leak1", category: .technical,
            title: "Coolant Leak in Power Bay",
            body: "A coolant line in your power bank has begun to drip a fine mist of low-pressure refrigerant. Sealant patches will hold for now, but a deeper retorque takes time and parts.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Sealant Patch",
                    detail: "Quick patch. -8 parts.",
                    costPreview: "-8 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -8],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 4,
                                            resolveText: "The patch holds. Engineering watches it for a few days.")),
                IncidentChoice(label: "Deep Retorque",
                    detail: "Full overnight job. -22 parts, +stress.",
                    costPreview: "-22 Parts +stress",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -22],
                                            stressDelta: 6, moraleDelta: -1, fatigueDelta: 10, skillDelta: 2,
                                            revealAnomalyId: "a.30",
                                            resolveText: "Coolant lines now in better shape than they were on launch day.")),
                IncidentChoice(label: "Ignore",
                    detail: "Risk power loss tomorrow.",
                    costPreview: "Possible -8 Power tomorrow",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.power.rawValue: -8],
                                            stressDelta: 2, moraleDelta: -1, fatigueDelta: 0,
                                            resolveText: "Engineering grumbled. Power dropped overnight."))
            ]))

        list.append(IncidentSpec(id: "i.tech.surge1", category: .technical,
            title: "Power Surge in Conduit C",
            body: "A spike in the C conduit popped two breakers. You can rebalance manually or roll back to backup batteries.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Rebalance",
                    detail: "Skilled engineer needed.",
                    costPreview: "-2 Parts, fatigue",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -2],
                                            stressDelta: 2, moraleDelta: 0, fatigueDelta: 6,
                                            resolveText: "Conduit rebalanced cleanly.")),
                IncidentChoice(label: "Switch to backup",
                    detail: "Burn battery charge.",
                    costPreview: "-10 Power",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.power.rawValue: -10],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Lights dim, but no crew strain.")),
                IncidentChoice(label: "Ride it out",
                    detail: "Hope it normalizes.",
                    costPreview: "Risk damage",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -6, ResourceKind.power.rawValue: -4],
                                            stressDelta: 4, moraleDelta: -2, fatigueDelta: 0,
                                            revealAnomalyId: "a.14",
                                            resolveText: "Two breakers fried. Replacement parts pulled from cargo."))
            ]))

        list.append(IncidentSpec(id: "i.tech.airlock", category: .technical,
            title: "Airlock Seal Wear",
            body: "Routine inspection flagged degradation in an airlock seal. Best to fix before next EVA.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Replace Seal",
                    detail: "-10 parts.",
                    costPreview: "-10 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -10],
                                            stressDelta: 0, moraleDelta: 1, fatigueDelta: 4,
                                            resolveText: "Seal replaced. EVAs back on schedule.")),
                IncidentChoice(label: "Patch + Watch",
                    detail: "Cheap, but risk.",
                    costPreview: "-3 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -3],
                                            stressDelta: 2, moraleDelta: -1, fatigueDelta: 2,
                                            revealAnomalyId: "a.04",
                                            resolveText: "Holds. Crew is asked to be careful.")),
            ]))

        list.append(IncidentSpec(id: "i.tech.fire1", category: .technical,
            title: "Galley Grease Fire",
            body: "A grease fire flares up under the galley range. Foam is on hand.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Foam It",
                    detail: "Standard. -1 medicine.",
                    costPreview: "-1 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -1],
                                            stressDelta: 3, moraleDelta: -1, fatigueDelta: 2,
                                            resolveText: "Fire out, smell lingers for a day.")),
                IncidentChoice(label: "Evacuate Galley",
                    detail: "No risk. Lose dinner.",
                    costPreview: "-3 Food",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.food.rawValue: -3],
                                            stressDelta: 1, moraleDelta: -2, fatigueDelta: 0,
                                            revealAnomalyId: "a.31",
                                            resolveText: "Galley shut. Crew eat protein bars."))
            ]))

        list.append(IncidentSpec(id: "i.tech.hydro1", category: .technical,
            title: "Hydroponics Filter Bloom",
            body: "An algae bloom is choking the recirculation filter.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Scrub Manually",
                    detail: "Fatiguing, no cost.",
                    costPreview: "Fatigue +6",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 1, moraleDelta: 0, fatigueDelta: 6,
                                            revealAnomalyId: "a.03",
                                            resolveText: "Botanist found something odd in the filter.")),
                IncidentChoice(label: "Use Chemicals",
                    detail: "Quick, costs medicine.",
                    costPreview: "-3 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -3],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Bloom dies. Filter clean."))
            ]))

        list.append(IncidentSpec(id: "i.tech.cell", category: .technical,
            title: "Power Cell Drift",
            body: "One bank of cells reads 6% under nominal.",
            needsCrewInvolvement: false, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Recalibrate",
                    detail: "-4 parts.",
                    costPreview: "-4 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -4],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 3,
                                            resolveText: "Drift restored.")),
                IncidentChoice(label: "Live With It",
                    detail: "Tiny loss.",
                    costPreview: "-2 Power",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.power.rawValue: -2],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.10",
                                            resolveText: "Numbers run a bit low all day."))
            ]))

        list.append(IncidentSpec(id: "i.tech.thermal", category: .technical,
            title: "Thermal Excursion",
            body: "Habitat 2 overheated for 18 minutes.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Recalibrate HVAC",
                    detail: "-8 parts.",
                    costPreview: "-8 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -8],
                                            stressDelta: 1, moraleDelta: 0, fatigueDelta: 4,
                                            resolveText: "Stable again.")),
                IncidentChoice(label: "Air Out",
                    detail: "Cycle oxygen.",
                    costPreview: "-4 Oxygen",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.oxygen.rawValue: -4],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            revealAnomalyId: "a.22",
                                            resolveText: "Smell of warm plastic lingers.")),
            ]))

        list.append(IncidentSpec(id: "i.tech.fab", category: .technical,
            title: "Machine Shop Jam",
            body: "The CNC head has jammed mid-cycle.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Clear and Realign",
                    detail: "-6 parts.",
                    costPreview: "-6 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -6],
                                            stressDelta: 1, moraleDelta: 0, fatigueDelta: 5,
                                            resolveText: "Production resumes.")),
                IncidentChoice(label: "Bypass",
                    detail: "-1 morale, faster.",
                    costPreview: "-1 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            revealAnomalyId: "a.11",
                                            resolveText: "Crew works around it."))
            ]))

        list.append(IncidentSpec(id: "i.tech.fuel", category: .technical,
            title: "Fuel Tank Slow Drip",
            body: "Sensor 4 in the fuel tank reads a 0.4% drip.",
            needsCrewInvolvement: true, phaseUnlock: .crisis, choices: [
                IncidentChoice(label: "Reseal",
                    detail: "-12 parts.",
                    costPreview: "-12 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -12],
                                            stressDelta: 2, moraleDelta: 0, fatigueDelta: 7,
                                            resolveText: "Drip stopped.")),
                IncidentChoice(label: "Tighten Schedule",
                    detail: "Lose a little fuel.",
                    costPreview: "-3 Fuel",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.fuel.rawValue: -3],
                                            stressDelta: 1, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.19",
                                            resolveText: "Fuel slowly bleeds away."))
            ]))

        list.append(IncidentSpec(id: "i.tech.warp", category: .technical,
            title: "Warp Coil Pulse",
            body: "The forming warp core pulsed off-schedule.",
            needsCrewInvolvement: true, phaseUnlock: .preWarp, choices: [
                IncidentChoice(label: "Damp Coils",
                    detail: "-1 fuel, -10 parts.",
                    costPreview: "-1 Fuel -10 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.fuel.rawValue: -1,
                                                            ResourceKind.parts.rawValue: -10],
                                            stressDelta: 2, moraleDelta: 0, fatigueDelta: 8,
                                            resolveText: "Pulse smoothed.")),
                IncidentChoice(label: "Reroute Power",
                    detail: "-8 power.",
                    costPreview: "-8 Power",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.power.rawValue: -8],
                                            stressDelta: 1, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.40",
                                            resolveText: "Reroute holds. Coils calmer."))
            ]))

        // MEDICAL (8)
        list.append(IncidentSpec(id: "i.med.fall1", category: .medical,
            title: "EVA Slip",
            body: "An engineer caught a rivet badly mid-EVA. Treatment time depends on how aggressive.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Surgical Care",
                    detail: "-3 meds, fast recovery.",
                    costPreview: "-3 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -3],
                                            stressDelta: 3, moraleDelta: 0, fatigueDelta: 8, skillDelta: 0,
                                            resolveText: "Stitched up. Crew back in a day.")),
                IncidentChoice(label: "Conservative",
                    detail: "Cheaper. Slower. Risky.",
                    costPreview: "-1 Med, -2 morale, risk",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -1],
                                            stressDelta: 5, moraleDelta: -2, fatigueDelta: 10,
                                            revealAnomalyId: "a.15",
                                            fatalityRiskPct: 5,
                                            resolveText: "Bandages and rest. Walks with a limp."))
            ]))

        list.append(IncidentSpec(id: "i.med.flu", category: .medical,
            title: "Pressure Flu",
            body: "Two crew running fever.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Treat Aggressively",
                    detail: "-4 meds.",
                    costPreview: "-4 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -4],
                                            stressDelta: 0, moraleDelta: 1, fatigueDelta: 0,
                                            resolveText: "Crew back to duty by morning.")),
                IncidentChoice(label: "Quarantine Bunk",
                    detail: "-2 morale, free.",
                    costPreview: "-2 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -2, fatigueDelta: 0,
                                            revealAnomalyId: "a.13",
                                            resolveText: "Sealed off, three days no work."))
            ]))

        list.append(IncidentSpec(id: "i.med.scrub", category: .medical,
            title: "Air Scrubber Contaminant",
            body: "A trace contaminant has crew coughing.",
            needsCrewInvolvement: false, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Replace Filters",
                    detail: "-6 parts.",
                    costPreview: "-6 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -6],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Air clean.")),
                IncidentChoice(label: "Mask Mandate",
                    detail: "-1 morale.",
                    costPreview: "-1 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            revealAnomalyId: "a.20",
                                            resolveText: "Crew dislike masks but cough less."))
            ]))

        list.append(IncidentSpec(id: "i.med.fatigue", category: .medical,
            title: "Sleep Debt Cascade",
            body: "Three crew showing dangerous fatigue.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Mandatory R&R",
                    detail: "Lose a day of work.",
                    costPreview: "-day output",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -6, moraleDelta: 3, fatigueDelta: -25,
                                            revealAnomalyId: "a.06",
                                            resolveText: "Crew slept through.")),
                IncidentChoice(label: "Stim Tablets",
                    detail: "-2 meds.",
                    costPreview: "-2 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -2],
                                            stressDelta: 4, moraleDelta: -1, fatigueDelta: -10,
                                            resolveText: "Crew alert today. Tired tomorrow."))
            ]))

        list.append(IncidentSpec(id: "i.med.injury2", category: .medical,
            title: "Cargo Bay Crush",
            body: "A loose crate clipped a crewman's hand.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Med Bay Surgery",
                    detail: "-4 meds.",
                    costPreview: "-4 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -4],
                                            stressDelta: 3, moraleDelta: 0, fatigueDelta: 8,
                                            resolveText: "Full repair.")),
                IncidentChoice(label: "Wrap and Rest",
                    detail: "-3 morale. Untreated bleeding is dangerous.",
                    costPreview: "-3 Morale, risk",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 5, moraleDelta: -3, fatigueDelta: 10,
                                            revealAnomalyId: "a.33",
                                            fatalityRiskPct: 4,
                                            resolveText: "Mobility limited for a week."))
            ]))

        list.append(IncidentSpec(id: "i.med.psy1", category: .medical,
            title: "Onset Anxiety",
            body: "A crew member is showing severe stress.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Therapy",
                    detail: "Time + 1 med.",
                    costPreview: "-1 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -1],
                                            stressDelta: -10, moraleDelta: 4, fatigueDelta: 0,
                                            resolveText: "Crew feels heard.")),
                IncidentChoice(label: "Reassign Quietly",
                    detail: "-1 morale all crew.",
                    costPreview: "-1 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -4, moraleDelta: -1, fatigueDelta: 0,
                                            revealAnomalyId: "a.32",
                                            resolveText: "Light duty for a week."))
            ]))

        list.append(IncidentSpec(id: "i.med.outbreak", category: .medical,
            title: "Mystery Rash",
            body: "Two greenhouse workers developed a strange rash.",
            needsCrewInvolvement: true, phaseUnlock: .expansion, choices: [
                IncidentChoice(label: "Standard Treatment",
                    detail: "-3 meds.",
                    costPreview: "-3 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -3],
                                            stressDelta: 2, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Rash subsides.")),
                IncidentChoice(label: "Quarantine Greenhouse",
                    detail: "-2 food/day for 3 days.",
                    costPreview: "-6 Food over time",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.food.rawValue: -6],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            revealAnomalyId: "a.21",
                                            resolveText: "Botany found something strange in the soil."))
            ]))

        list.append(IncidentSpec(id: "i.med.epi", category: .medical,
            title: "Crew Epidemic Risk",
            body: "Three crew sneezing all morning.",
            needsCrewInvolvement: false, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Inoculate All",
                    detail: "-6 meds.",
                    costPreview: "-6 Med",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -6],
                                            stressDelta: 0, moraleDelta: 2, fatigueDelta: 0,
                                            resolveText: "Crew safe.")),
                IncidentChoice(label: "Wait and See",
                    detail: "Could go bad.",
                    costPreview: "Risk",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -3],
                                            stressDelta: 4, moraleDelta: -2, fatigueDelta: 6,
                                            revealAnomalyId: "a.35",
                                            resolveText: "Cluster spread, ultimately resolved."))
            ]))

        // SOCIAL (9)
        list.append(IncidentSpec(id: "i.soc.argument1", category: .social,
            title: "Galley Argument",
            body: "Two crew came to blows over a shift swap that wasn't honored.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Captain's Mediation",
                    detail: "Calm, costs a day.",
                    costPreview: "Time",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -2, moraleDelta: 3, fatigueDelta: 0,
                                            resolveText: "Reconciled.")),
                IncidentChoice(label: "Lock Up the Worse Offender",
                    detail: "-3 morale.",
                    costPreview: "-3 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -3, fatigueDelta: 0,
                                            revealAnomalyId: "a.02",
                                            resolveText: "Crew sullen but quiet."))
            ]))

        list.append(IncidentSpec(id: "i.soc.depression", category: .social,
            title: "Lone Wolf Spiral",
            body: "A crewman has stopped speaking to the rest.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Spend an Evening With Them",
                    detail: "Crew morale +3.",
                    costPreview: "Time",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -3, moraleDelta: 3, fatigueDelta: 0,
                                            resolveText: "They open up over recycled tea.")),
                IncidentChoice(label: "Reassign to Solo Duty",
                    detail: "Skill bonus, stress.",
                    costPreview: "-1 morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 3, moraleDelta: -1, fatigueDelta: 0, skillDelta: 1,
                                            revealAnomalyId: "a.28",
                                            resolveText: "They thrive alone."))
            ]))

        list.append(IncidentSpec(id: "i.soc.mutiny1", category: .social,
            title: "Mutiny Whisper",
            body: "Quiet dissent in Habitat 1. The captain catches a whispered name being passed.",
            needsCrewInvolvement: true, phaseUnlock: .crisis, choices: [
                IncidentChoice(label: "Town Hall",
                    detail: "Time, +morale.",
                    costPreview: "Time",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -4, moraleDelta: 6, fatigueDelta: 0,
                                            resolveText: "Whispers stop. Air clears.")),
                IncidentChoice(label: "Quiet Crackdown",
                    detail: "-6 morale.",
                    costPreview: "-6 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 3, moraleDelta: -6, fatigueDelta: 0,
                                            revealAnomalyId: "a.36",
                                            resolveText: "Tension cools, but eyes are colder."))
            ]))

        list.append(IncidentSpec(id: "i.soc.party", category: .social,
            title: "Birthday Request",
            body: "It's Cook Aoki's birthday. Recreation room is reserved.",
            needsCrewInvolvement: false, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Throw a Party",
                    detail: "-2 food, -1 credits.",
                    costPreview: "-2 Food",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.food.rawValue: -2],
                                            stressDelta: -4, moraleDelta: 6, fatigueDelta: 0,
                                            revealAnomalyId: "a.24",
                                            resolveText: "Laughter heard for the first time in days.")),
                IncidentChoice(label: "Polite Note",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "She smiles, briefly."))
            ]))

        list.append(IncidentSpec(id: "i.soc.romance", category: .social,
            title: "Two Become One",
            body: "Two crewmates have begun spending all off-duty time together. The captain notices.",
            needsCrewInvolvement: false, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Let It Be",
                    detail: "+morale.",
                    costPreview: "+morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -2, moraleDelta: 4, fatigueDelta: 0,
                                            resolveText: "Crew morale lifts a notch.")),
                IncidentChoice(label: "Separate Shifts",
                    detail: "-3 morale.",
                    costPreview: "-3 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 3, moraleDelta: -3, fatigueDelta: 0,
                                            revealAnomalyId: "a.16",
                                            resolveText: "Both move quieter, less smiling."))
            ]))

        list.append(IncidentSpec(id: "i.soc.faith", category: .social,
            title: "Sunday Service",
            body: "A few religious crew request use of recreation for a service.",
            needsCrewInvolvement: false, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Grant the Space",
                    detail: "+morale.",
                    costPreview: "+morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -2, moraleDelta: 3, fatigueDelta: 0,
                                            resolveText: "Brief, quiet, and warm.")),
                IncidentChoice(label: "Decline",
                    detail: "-2 morale.",
                    costPreview: "-2 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 1, moraleDelta: -2, fatigueDelta: 0,
                                            revealAnomalyId: "a.08",
                                            resolveText: "They find a corner anyway."))
            ]))

        list.append(IncidentSpec(id: "i.soc.training", category: .social,
            title: "Training Request",
            body: "Two crewmen want to train under your senior engineer.",
            needsCrewInvolvement: false, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Approve",
                    detail: "+1 skill to trainees.",
                    costPreview: "Time",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 1, fatigueDelta: 0, skillDelta: 2,
                                            resolveText: "Junior engineers come away sharper.")),
                IncidentChoice(label: "Postpone",
                    detail: "-2 morale.",
                    costPreview: "-2 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -2, fatigueDelta: 0,
                                            revealAnomalyId: "a.12",
                                            resolveText: "Disappointed crew."))
            ]))

        list.append(IncidentSpec(id: "i.soc.recipe", category: .social,
            title: "A Found Recipe",
            body: "Cook finds an old recipe taped under a tray.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Cook It",
                    detail: "-2 food, +morale.",
                    costPreview: "-2 Food",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.food.rawValue: -2],
                                            stressDelta: -3, moraleDelta: 5, fatigueDelta: 0,
                                            revealAnomalyId: "a.07",
                                            resolveText: "Tastes like a memory the crew doesn't share.")),
                IncidentChoice(label: "File It",
                    detail: "Skip.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Archived without ceremony."))
            ]))

        list.append(IncidentSpec(id: "i.soc.crisismeeting", category: .social,
            title: "Crisis Town Hall",
            body: "Crew want answers about the recent emergencies.",
            needsCrewInvolvement: false, phaseUnlock: .crisis, choices: [
                IncidentChoice(label: "Be Transparent",
                    detail: "+morale, stress drop.",
                    costPreview: "Time",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: -6, moraleDelta: 5, fatigueDelta: 0,
                                            resolveText: "Crew feels heard.")),
                IncidentChoice(label: "Hold the Line",
                    detail: "-3 morale.",
                    costPreview: "-3 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -3, fatigueDelta: 0,
                                            resolveText: "Crew silent and skeptical."))
            ]))

        // EXTERNAL (8)
        list.append(IncidentSpec(id: "i.ext.meteor1", category: .external,
            title: "Micrometeor Cluster",
            body: "Radar caught a small cluster of micrometeors inbound.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Maneuver",
                    detail: "-3 fuel.",
                    costPreview: "-3 Fuel",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.fuel.rawValue: -3],
                                            stressDelta: 2, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Avoided.")),
                IncidentChoice(label: "Hold and Pray",
                    detail: "Risk damage and hull breach.",
                    costPreview: "Risk -parts, hull risk",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: -10],
                                            stressDelta: 4, moraleDelta: -2, fatigueDelta: 4,
                                            revealAnomalyId: "a.26",
                                            fatalityRiskPct: 4,
                                            resolveText: "A few dents. Crew shaken."))
            ]))

        list.append(IncidentSpec(id: "i.ext.signal1", category: .external,
            title: "Drifting Signal",
            body: "A faint signal repeats on an off-band frequency.",
            needsCrewInvolvement: true, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Trace It",
                    detail: "Time, possible reward.",
                    costPreview: "-2 Power",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.power.rawValue: -2,
                                                            ResourceKind.research.rawValue: 4],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.17",
                                            resolveText: "A drift signal. Researchers transcribe a sliver.")),
                IncidentChoice(label: "Ignore",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Signal fades."))
            ]))

        list.append(IncidentSpec(id: "i.ext.delay", category: .external,
            title: "Supply Delay",
            body: "Expected supply run delayed by a week.",
            needsCrewInvolvement: false, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Ration",
                    detail: "-4 morale.",
                    costPreview: "-4 Morale",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.food.rawValue: -5],
                                            stressDelta: 1, moraleDelta: -4, fatigueDelta: 0,
                                            revealAnomalyId: "a.23",
                                            resolveText: "Tight week.")),
                IncidentChoice(label: "Pay Premium",
                    detail: "-200 credits.",
                    costPreview: "-200 Credits",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: -200,
                                                            ResourceKind.food.rawValue: 4],
                                            stressDelta: 0, moraleDelta: 1, fatigueDelta: 0,
                                            resolveText: "Replacement ship arrives sooner."))
            ]))

        list.append(IncidentSpec(id: "i.ext.radiation", category: .external,
            title: "Radiation Spike",
            body: "Background radiation outside the hull spiked for 6 hours. A crewman was outside on EVA.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Lockdown EVA",
                    detail: "Lose research today.",
                    costPreview: "-research",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.research.rawValue: -3],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            resolveText: "Safe, but slow.")),
                IncidentChoice(label: "Push Through",
                    detail: "-2 meds. Radiation can be fatal.",
                    costPreview: "-2 Med, risk",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.medicine.rawValue: -2],
                                            stressDelta: 3, moraleDelta: -2, fatigueDelta: 0,
                                            revealAnomalyId: "a.37",
                                            fatalityRiskPct: 3,
                                            resolveText: "Crew exposed. Treated."))
            ]))

        list.append(IncidentSpec(id: "i.ext.derelict", category: .external,
            title: "Derelict Hauler",
            body: "An old hauler drifts by, hull holed.",
            needsCrewInvolvement: true, phaseUnlock: .expansion, choices: [
                IncidentChoice(label: "Salvage",
                    detail: "-1 fuel, +parts.",
                    costPreview: "-1 Fuel",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.parts.rawValue: 50,
                                                            ResourceKind.fuel.rawValue: -1],
                                            stressDelta: 2, moraleDelta: 1, fatigueDelta: 8,
                                            revealAnomalyId: "a.18",
                                            resolveText: "Pulled a stack of parts.")),
                IncidentChoice(label: "Mark and Move On",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Logged for future reference."))
            ]))

        list.append(IncidentSpec(id: "i.ext.beacon", category: .external,
            title: "Old Beacon",
            body: "A long-forgotten survey beacon transmits coordinates.",
            needsCrewInvolvement: false, phaseUnlock: .expansion, choices: [
                IncidentChoice(label: "Decode",
                    detail: "+5 research.",
                    costPreview: "+5 Research",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.research.rawValue: 5],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.34",
                                            resolveText: "Coordinates point to a charted region — but the star isn't there yet.")),
                IncidentChoice(label: "Erase",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Beacon silenced."))
            ]))

        list.append(IncidentSpec(id: "i.ext.distress", category: .external,
            title: "Distress Call",
            body: "A weak distress call from a passing freighter.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Send Aid",
                    detail: "-2 fuel, +morale.",
                    costPreview: "-2 Fuel",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.fuel.rawValue: -2,
                                                            ResourceKind.credits.rawValue: 150],
                                            stressDelta: 0, moraleDelta: 4, fatigueDelta: 4,
                                            revealAnomalyId: "a.29",
                                            resolveText: "Saved a crew. They paid out of pocket.")),
                IncidentChoice(label: "Decline",
                    detail: "-3 morale.",
                    costPreview: "-3 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 1, moraleDelta: -3, fatigueDelta: 0,
                                            resolveText: "Crew quiet at dinner."))
            ]))

        list.append(IncidentSpec(id: "i.ext.fold", category: .external,
            title: "Folded Star",
            body: "Astrophysics modeled a folded star.",
            needsCrewInvolvement: true, phaseUnlock: .preWarp, choices: [
                IncidentChoice(label: "Run Sims",
                    detail: "-4 power, +research.",
                    costPreview: "-4 Power",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.power.rawValue: -4,
                                                            ResourceKind.research.rawValue: 10],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.25",
                                            resolveText: "A fold map. Data folded back. The team trembles.")),
                IncidentChoice(label: "File",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Filed. Marked for review."))
            ]))

        // OPPORTUNITY (8)
        list.append(IncidentSpec(id: "i.opp.trader1", category: .opportunity,
            title: "Visiting Trader",
            body: "A cargo trader docks with a unique offer.",
            needsCrewInvolvement: false, phaseUnlock: .pioneering, choices: [
                IncidentChoice(label: "Buy Parts",
                    detail: "-200 cr, +60 parts.",
                    costPreview: "-200 Cr +60 Parts",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: -200,
                                                            ResourceKind.parts.rawValue: 60],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Trader leaves smiling.")),
                IncidentChoice(label: "Sell Food",
                    detail: "+250 cr, -10 food.",
                    costPreview: "+250 Cr -10 Food",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: 250,
                                                            ResourceKind.food.rawValue: -10],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            revealAnomalyId: "a.27",
                                            resolveText: "Coffer rises.")),
                IncidentChoice(label: "Decline",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Trader departs."))
            ]))

        list.append(IncidentSpec(id: "i.opp.relic", category: .opportunity,
            title: "Discovered Relic",
            body: "A salvage crew found a sealed glass cylinder with strange engravings.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Study Carefully",
                    detail: "+8 research.",
                    costPreview: "+8 Research",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.research.rawValue: 8],
                                            stressDelta: 0, moraleDelta: 1, fatigueDelta: 0,
                                            revealAnomalyId: "a.34",
                                            resolveText: "Recorded in detail.")),
                IncidentChoice(label: "Sell to Trader",
                    detail: "+400 cr.",
                    costPreview: "+400 Cr",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: 400],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            resolveText: "Scientist disappointed."))
            ]))

        list.append(IncidentSpec(id: "i.opp.recruit", category: .opportunity,
            title: "Wandering Recruit",
            body: "A wanderer asks to join the station crew.",
            needsCrewInvolvement: false, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Accept",
                    detail: "+1 crew, -100 cr.",
                    costPreview: "+1 Crew",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: -100],
                                            stressDelta: 0, moraleDelta: 2, fatigueDelta: 0,
                                            revealAnomalyId: "a.05",
                                            addCrewMember: true,
                                            resolveText: "New face onboard.")),
                IncidentChoice(label: "Decline",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "They leave."))
            ]))

        list.append(IncidentSpec(id: "i.opp.tradeFuel", category: .opportunity,
            title: "Fuel Vendor",
            body: "A passing fuel vendor offers reactor-grade fuel at fair rate.",
            needsCrewInvolvement: false, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Buy Fuel",
                    detail: "-300 cr, +10 fuel.",
                    costPreview: "-300 Cr +10 Fuel",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: -300,
                                                            ResourceKind.fuel.rawValue: 10],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Tanks topped up.")),
                IncidentChoice(label: "Pass",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Vendor leaves."))
            ]))

        list.append(IncidentSpec(id: "i.opp.distressFriend", category: .opportunity,
            title: "Old Friend Hails",
            body: "A friend on a nearby station offers a knowledge exchange.",
            needsCrewInvolvement: true, phaseUnlock: .expansion, choices: [
                IncidentChoice(label: "Trade Knowledge",
                    detail: "+12 research.",
                    costPreview: "+12 Research",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.research.rawValue: 12],
                                            stressDelta: 0, moraleDelta: 2, fatigueDelta: 0,
                                            revealAnomalyId: "a.09",
                                            resolveText: "Both stations richer for it.")),
                IncidentChoice(label: "Cold Refusal",
                    detail: "-2 morale.",
                    costPreview: "-2 Morale",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -2, fatigueDelta: 0,
                                            resolveText: "Friend wounded by the silence."))
            ]))

        list.append(IncidentSpec(id: "i.opp.celebrity", category: .opportunity,
            title: "Visiting Reporter",
            body: "A reporter from inner planets asks to interview the captain.",
            needsCrewInvolvement: false, phaseUnlock: .expansion, choices: [
                IncidentChoice(label: "Open House",
                    detail: "+morale, +credits.",
                    costPreview: "+200 Cr",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: 200],
                                            stressDelta: 0, moraleDelta: 3, fatigueDelta: 0,
                                            revealAnomalyId: "a.39",
                                            resolveText: "Press warm and brief.")),
                IncidentChoice(label: "Decline",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: -1, fatigueDelta: 0,
                                            resolveText: "Reporter leaves disappointed."))
            ]))

        list.append(IncidentSpec(id: "i.opp.contract", category: .opportunity,
            title: "Survey Contract",
            body: "Industry offers a one-week survey contract.",
            needsCrewInvolvement: true, phaseUnlock: .stabilization, choices: [
                IncidentChoice(label: "Accept",
                    detail: "-3 fuel, +400 cr.",
                    costPreview: "-3 Fuel +400 Cr",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.fuel.rawValue: -3,
                                                            ResourceKind.credits.rawValue: 400,
                                                            ResourceKind.research.rawValue: 3],
                                            stressDelta: 2, moraleDelta: 0, fatigueDelta: 4,
                                            revealAnomalyId: "a.01",
                                            resolveText: "Crew sweat through the week. Pays out.")),
                IncidentChoice(label: "Decline",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "Industry note declined politely."))
            ]))

        list.append(IncidentSpec(id: "i.opp.warpBoon", category: .opportunity,
            title: "Warp Theorist Drops In",
            body: "A scientist with warp credentials offers a brief consultation.",
            needsCrewInvolvement: true, phaseUnlock: .preWarp, choices: [
                IncidentChoice(label: "Consult",
                    detail: "-500 cr, +20 research.",
                    costPreview: "-500 Cr +20 Research",
                    outcome: IncidentOutcome(resourceDelta: [ResourceKind.credits.rawValue: -500,
                                                            ResourceKind.research.rawValue: 20],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            revealAnomalyId: "a.38",
                                            resolveText: "Theorist scribbles for an afternoon and leaves you stunned.")),
                IncidentChoice(label: "Politely Decline",
                    detail: "Free.",
                    costPreview: "Free",
                    outcome: IncidentOutcome(resourceDelta: [:],
                                            stressDelta: 0, moraleDelta: 0, fatigueDelta: 0,
                                            resolveText: "They leave silently."))
            ]))

        return list
    }

    static func incidents(in phase: CampaignPhase) -> [IncidentSpec] {
        let allowedPhases: [CampaignPhase]
        switch phase {
        case .pioneering:    allowedPhases = [.pioneering]
        case .stabilization: allowedPhases = [.pioneering, .stabilization]
        case .expansion:     allowedPhases = [.pioneering, .stabilization, .expansion]
        case .crisis:        allowedPhases = [.pioneering, .stabilization, .expansion, .crisis]
        case .preWarp:       allowedPhases = [.pioneering, .stabilization, .expansion, .crisis, .preWarp]
        case .warpLaunch:    allowedPhases = CampaignPhase.allCases
        }
        return incidents.filter { allowedPhases.contains($0.phaseUnlock) }
    }

    // MARK: Achievements (30)

    static let achievements: [AchievementSpec] = [
        AchievementSpec(id: "ach.firstHab", title: "First Sleep",
                        detail: "Built your first habitat."),
        AchievementSpec(id: "ach.firstLab", title: "Lab Coats On",
                        detail: "Built your first lab."),
        AchievementSpec(id: "ach.firstAdvLab", title: "Glass and Steel",
                        detail: "Built an Advanced Lab."),
        AchievementSpec(id: "ach.firstResearch", title: "First Paper",
                        detail: "Completed your first research project."),
        AchievementSpec(id: "ach.engBranch", title: "Engineering Mastered",
                        detail: "Completed all Engineering research."),
        AchievementSpec(id: "ach.bioBranch", title: "Biology Mastered",
                        detail: "Completed all Biology research."),
        AchievementSpec(id: "ach.astroBranch", title: "Astrophysics Mastered",
                        detail: "Completed all Astrophysics research."),
        AchievementSpec(id: "ach.medBranch", title: "Medicine Mastered",
                        detail: "Completed all Medicine research."),
        AchievementSpec(id: "ach.logBranch", title: "Logistics Mastered",
                        detail: "Completed all Logistics research."),
        AchievementSpec(id: "ach.thirtyClean", title: "Thirty Clean Days",
                        detail: "No fatalities for 30 days."),
        AchievementSpec(id: "ach.ninetyClean", title: "Ninety Clean Days",
                        detail: "No fatalities for 90 days."),
        AchievementSpec(id: "ach.stationFull", title: "Station Full",
                        detail: "12 crew, all assigned to a duty."),
        AchievementSpec(id: "ach.fiveModules", title: "Foundations",
                        detail: "5 modules placed."),
        AchievementSpec(id: "ach.tenModules", title: "Living Network",
                        detail: "10 modules placed."),
        AchievementSpec(id: "ach.twentyModules", title: "Sprawling Hub",
                        detail: "20 modules placed."),
        AchievementSpec(id: "ach.anomaly5", title: "Anomalist",
                        detail: "Discovered 5 anomalies."),
        AchievementSpec(id: "ach.anomaly20", title: "Lorekeeper",
                        detail: "Discovered 20 anomalies."),
        AchievementSpec(id: "ach.anomalyAll", title: "Orbital Grid Archivist",
                        detail: "Discovered all 40 anomalies."),
        AchievementSpec(id: "ach.maxResearch", title: "Edge of Knowing",
                        detail: "Completed all 80+ research projects."),
        AchievementSpec(id: "ach.fuel100", title: "Fueled",
                        detail: "Held 100 fuel."),
        AchievementSpec(id: "ach.parts5000", title: "Stocked",
                        detail: "Held 5,000 parts."),
        AchievementSpec(id: "ach.cred5k", title: "Banked",
                        detail: "Held 5,000 credits."),
        AchievementSpec(id: "ach.fiveCrisis", title: "Through the Storm",
                        detail: "Survived 5 crisis incidents."),
        AchievementSpec(id: "ach.morale90", title: "Spirits High",
                        detail: "Crew average morale 90+."),
        AchievementSpec(id: "ach.startupWeek", title: "First Week",
                        detail: "Survived day 7."),
        AchievementSpec(id: "ach.midRun", title: "Midway",
                        detail: "Reached day 180."),
        AchievementSpec(id: "ach.preWarp", title: "Approaching the Veil",
                        detail: "Reached the Pre-Warp phase."),
        AchievementSpec(id: "ach.warpStarted", title: "Coil Awakens",
                        detail: "Began Warp Core construction."),
        AchievementSpec(id: "ach.warpComplete", title: "The Drift Crossed",
                        detail: "Completed Warp Core. The station leaves."),
        AchievementSpec(id: "ach.threeTrades", title: "Three Handshakes",
                        detail: "Resolved 3 trader incidents."),
    ]
}
