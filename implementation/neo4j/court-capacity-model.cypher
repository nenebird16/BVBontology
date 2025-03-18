// BeachBook Knowledge Graph Schema - 2v2 Structure and Court Capacity Updates
// This file contains the Cypher statements to implement 2v2 structure constraints

// ========== NEW ENTITY TYPES ==========
// Create new node types for court capacity and gameplay constraints

// Court Capacity entity
CREATE (cc:CourtCapacity {
  name: 'Standard Beach Court Capacity',
  optimal_players_per_court: 6,
  maximum_players_per_court: 8,
  minimum_players_per_court: 4,
  rationale: 'Balances active play time with adequate rest intervals'
});

// Create Optimal Configurations
CREATE (oc4:OptimalConfiguration {
  name: 'Pure 2v2 Gameplay',
  player_count: 4,
  formation: 'Standard 2v2 gameplay',
  active_time_percentage: 100,
  rotation_trigger: 'None - continuous play',
  rotation_pattern: 'None needed - ideal for gameplay focus',
  coaching_approach: 'Constraints-based coaching during live play',
  recommended_format: 'Gameplay with targeted constraints and objectives'
});

CREATE (oc6:OptimalConfiguration {
  name: 'Three Team Rotation',
  player_count: 6,
  formation: 'Three teams of 2 rotating (king of the court)',
  active_time_percentage: 67,
  rotation_trigger: 'Point completion',
  rotation_pattern: 'Winning team stays, losing team exits, waiting team enters'
});

CREATE (oc8:OptimalConfiguration {
  name: 'Four Team Rotation',
  player_count: 8,
  formation: 'Four teams of 2 rotating through stations',
  active_time_percentage: 50,
  rotation_trigger: 'Point completion or time interval',
  rotation_pattern: 'Regular clockwise rotation or winner stays'
});

// Create Contingency Configurations for odd numbers
CREATE (cc5:ContingencyConfiguration {
  name: 'Five Player Adaptation',
  player_count: 5,
  formation: 'Two teams of 2 plus single specialized position',
  active_time_percentage: 80,
  specialized_role: 'Server or targeted skill position',
  rotation_pattern: 'Rotate through specialized position'
});

CREATE (cc7:ContingencyConfiguration {
  name: 'Seven Player Adaptation',
  player_count: 7,
  formation: 'Three teams of 2 plus single specialized position',
  active_time_percentage: 57,
  specialized_role: 'Server, coach assistant, or specific skill focus',
  rotation_pattern: 'King of the court with specialized position integration'
});

// Create Gameplay Constraints
CREATE (gc1:GameplayConstraint {
  name: 'Shot Selection Constraint',
  description: 'Players can only use specific shots (e.g., line shots only, cut shots only)',
  skill_focus: 'Attack decision-making',
  implementation: 'Coach calls out allowed shot types before each play'
});

CREATE (gc2:GameplayConstraint {
  name: 'Contact Constraint',
  description: 'Players must use specific contact techniques (e.g., open hand setting only)',
  skill_focus: 'Technical execution',
  implementation: 'Points only count when correct technique is used'
});

CREATE (gc3:GameplayConstraint {
  name: 'Tactical Constraint',
  description: 'Teams must follow specific tactical patterns (e.g., must set to line position)',
  skill_focus: 'Team strategy implementation',
  implementation: 'Points only count when tactical objective is achieved'
});

// Practice Participant role
CREATE (pp:PracticeParticipant {
  name: 'Standard Player Role',
  description: 'Regular participant in practice activities',
  rotation_expectations: 'Follows standard rotation patterns'
});

// Connect Court Capacity to Configurations
MATCH (cc:CourtCapacity {name: 'Standard Beach Court Capacity'})
MATCH (oc:OptimalConfiguration)
CREATE (cc)-[:OPTIMAL_CONFIGURATION {
  player_count: oc.player_count,
  formation: oc.formation,
  active_time_percentage: oc.active_time_percentage,
  rotation_trigger: oc.rotation_trigger,
  rotation_pattern: oc.rotation_pattern
}]->(oc);

MATCH (cc:CourtCapacity {name: 'Standard Beach Court Capacity'})
MATCH (contc:ContingencyConfiguration)
CREATE (cc)-[:CONTINGENCY_CONFIGURATION {
  player_count: contc.player_count,
  formation: contc.formation,
  active_time_percentage: contc.active_time_percentage,
  specialized_role: contc.specialized_role,
  rotation_pattern: contc.rotation_pattern
}]->(contc);

// Connect 4-player configuration to Gameplay Constraints
MATCH (oc:OptimalConfiguration {player_count: 4})
MATCH (gc:GameplayConstraint)
CREATE (oc)-[:UTILIZES]->(gc);

// ========== UPDATE EXISTING DRILLS ==========
// Add team structure and court capacity properties to all drills

MATCH (d:Drill)
SET d.team_structure = "2v2",  // Set the fundamental structure
    d.allows_specialized_role = CASE 
      WHEN d.name IN ['King/Queen of the Court', 'Serve and Pass Focus'] THEN true
      ELSE false
    END,
    d.allows_gameplay_focus = CASE
      WHEN d.intensity IN ['medium', 'high'] AND d.duration >= 15 THEN true
      ELSE false
    END;

// Create court capacity relationships for drills
MATCH (d:Drill)
MATCH (cc:CourtCapacity {name: 'Standard Beach Court Capacity'})
CREATE (d)-[:REQUIRES_COURT_CAPACITY {
  optimal_players: CASE 
    WHEN d.name = 'King/Queen of the Court' THEN 6
    WHEN d.name = 'Constraint-Based 2v2 Play' THEN 4
    ELSE 6
  END,
  maximum_players: 8,
  rotation_efficiency: CASE
    WHEN d.name IN ['King/Queen of the Court', 'Serve and Pass Focus'] THEN "high"
    ELSE "medium"
  END,
  adapts_to_odd_count: CASE
    WHEN d.allows_specialized_role = true THEN true
    ELSE false
  END
}]->(cc);

// ========== COACH PARTICIPATION ==========
// Add participation capabilities to coaches

MATCH (c:Coach)
SET c.can_participate = true,
    c.playing_level = "Advanced",
    c.playing_specialization = "All-around",
    c.participation_availability = "As needed for odd numbers",
    c.participation_constraints = "Limited jumping to preserve energy for coaching";

// Create participation relationships
MATCH (c:Coach)
MATCH (pp:PracticeParticipant)
CREATE (c)-[:PARTICIPATES_AS {
  role: "Fill-in player",
  primary_purpose: "Balance teams for 2v2 structure",
  secondary_purpose: "Demonstrate techniques in game context",
  usage_frequency: "As needed for odd numbers",
  energy_management: "Limited rotations to maintain coaching focus"
}]->(pp);

// Connect coaches to gameplay constraints
MATCH (c:Coach)
MATCH (gc:GameplayConstraint)
CREATE (c)-[:APPLIES_CONSTRAINT {
  context: "4-player gameplay focus",
  progression: "Begin with simple limitations, add complexity",
  feedback_approach: "Immediate during natural breaks",
  success_metrics: "Improvement in unconstrained play"
}]->(gc);

// ========== CREATE EXAMPLE 2v2 FOCUSED DRILL ==========
// Add specific drill optimized for 4-player pure gameplay

CREATE (d:Drill {
  name: "Constraint-Based 2v2 Play",
  description: "Full 2v2 gameplay with rotating technical and tactical constraints",
  focus_area: "Game integration",
  intensity: "match-like",
  duration: 30,
  equipment_needed: "Volleyballs, court boundaries",
  visual_elements: "Game-specific visual cues, decision-making triggers",
  team_structure: "2v2",
  optimal_player_count: 4,
  maximum_player_count: 4,
  allows_specialized_role: false,
  allows_gameplay_focus: true,
  constraint_examples: [
    "Attack only line shots for 5 points, then only angle for 5 points",
    "Block must always take line, defense adjusts",
    "3-contact rule - teams must use all 3 contacts"
  ],
  coaching_integration: "Coach applies constraints, provides feedback during natural breaks, adjusts challenge level"
});

// Connect the new drill to appropriate skills
MATCH (d:Drill {name: "Constraint-Based 2v2 Play"})
MATCH (s:Skill)
WHERE s.name IN ['Passing', 'Setting', 'Jump Serve']
CREATE (d)-[:DEVELOPS {
  primary: true,
  development_phase: 'integration',
  effectiveness_rating: 9
}]->(s);

// Connect the new drill to court capacity
MATCH (d:Drill {name: "Constraint-Based 2v2 Play"})
MATCH (cc:CourtCapacity)
CREATE (d)-[:REQUIRES_COURT_CAPACITY {
  optimal_players: 4,
  maximum_players: 4,
  rotation_efficiency: "perfect",
  adapts_to_odd_count: false
}]->(cc);