# Activity Relationships

This document defines the relationships between activity entities in the BeachBook knowledge graph.

## DEVELOPS (Drill→Skill)

Connects a drill to the skill it is designed to improve.

**Properties:**
- `primary`: Whether this is the main skill target (boolean)
- `development_phase`: Which learning stage this targets (acquisition, refinement, mastery)
- `effectiveness_rating`: How well this drill develops the skill (1-10)

**Example:**
```cypher
MATCH (d:Drill {name: 'Serve Target Practice'})
MATCH (s:Skill {name: 'Jump Serve'})
CREATE (d)-[r:DEVELOPS {
  primary: true,
  development_phase: 'refinement',
  effectiveness_rating: 8
}]->(s)
```

## REQUIRES (Skill→Skill)

Indicates prerequisite skills needed before learning more advanced skills.

**Properties:**
- `strength`: How strongly this prerequisite is needed (1-10)
- `transfer_effect`: How much the prerequisite skill improves learning of the target skill

**Example:**
```cypher
MATCH (s1:Skill {name: 'Jump Serve'})
MATCH (s2:Skill {name: 'Standing Serve'})
CREATE (s1)-[r:REQUIRES {
  strength: 7,
  transfer_effect: 'high'
}]->(s2)
```

## INCLUDES (PracticePlan→Drill)

Connects a practice plan to the drills it contains.

**Properties:**
- `sequence_order`: Position in the practice progression
- `duration`: Time allocated to this drill
- `intensity_modification`: Any adjustments to the standard intensity
- `focus_points`: Specific aspects to emphasize

**Example:**
```cypher
MATCH (p:PracticePlan {name: 'Advanced Serving Session'})
MATCH (d:Drill {name: 'Serve Target Practice'})
CREATE (p)-[r:INCLUDES {
  sequence_order: 3,
  duration: 'PT15M',
  intensity_modification: 'standard',
  focus_points: 'consistent toss, contact point'
}]->(d)
```

## PRACTICED (Player→Skill)

Records when a player has worked on a particular skill.

**Properties:**
- `timestamp`: When the practice occurred
- `duration`: How long they practiced
- `quality_rating`: Self-assessment of practice quality (1-10)
- `repetitions`: Number of attempts
- `context`: Situation of the practice
- `notes`: Observations during practice

**Example:**
```cypher
MATCH (p:Player {id: 'player123'})
MATCH (s:Skill {name: 'Jump Serve'})
CREATE (p)-[r:PRACTICED {
  timestamp: datetime(),
  duration: 'PT30M',
  quality_rating: 7,
  repetitions: 50,
  context: 'post-practice additional work',
  notes: 'focused on arm swing path'
}]->(s)
```

## EXECUTED (Player→Drill)

Records when a player has completed a specific drill.

**Properties:**
- `timestamp`: When the drill was executed
- `completion_percentage`: How much of the drill was completed
- `performance_rating`: Self-assessment of execution quality (1-10)
- `adaptation_notes`: Any modifications made
- `partner`: Who they worked with

**Example:**
```cypher
MATCH (p:Player {id: 'player123'})
MATCH (d:Drill {name: 'Serve Target Practice'})
CREATE (p)-[r:EXECUTED {
  timestamp: datetime(),
  completion_percentage: 100,
  performance_rating: 8,
  adaptation_notes: 'increased distance progressively',
  partner: 'coach456'
}]->(d)
```

## ALIGNS_WITH (Drill→Framework)

Connects drills to the theoretical frameworks they implement.

**Properties:**
- `alignment_strength`: How closely the drill follows the framework (1-10)
- `implementation_notes`: How the framework is applied in this drill

**Example:**
```cypher
MATCH (d:Drill {name: 'Serve Target Practice'})
MATCH (f:Framework {name: 'Visual-Motor Integration'})
CREATE (d)-[r:ALIGNS_WITH {
  alignment_strength: 9,
  implementation_notes: 'incorporates progressive visual tracking challenges'
}]->(f)
```

## RELATED_TO (Skill→StrategicConcept)

Connects skills to the strategic concepts they support.

**Properties:**
- `relevance`: How important this skill is to the concept (1-10)
- `application_context`: When this skill is used within the strategic framework

**Example:**
```cypher
MATCH (s:Skill {name: 'Short Serve'})
MATCH (sc:StrategicConcept {name: 'Serve to Set Up Block'})
CREATE (s)-[r:RELATED_TO {
  relevance: 8,
  application_context: 'forcing tight pass to restrict attack options'
}]->(sc)
```

## EVALUATED (Assessment→Skill)

Connects an assessment session to the skills that were evaluated.

**Properties:**
- `focus_level`: How much attention was given to this skill
- `improvement_since_last`: Noted progress
- `discussion_points`: Key topics covered
- `action_items`: Follow-up tasks

**Example:**
```cypher
MATCH (a:Assessment {id: 'assessment456'})
MATCH (s:Skill {name: 'Jump Serve'})
CREATE (a)-[r:EVALUATED {
  focus_level: 'primary',
  improvement_since_last: 'moderate',
  discussion_points: 'toss consistency, contact point height',
  action_items: 'video review, target practice drill'
}]->(s)
```

## FOCUSES_ON (Drill→VisualElement)

Connects drills to the visual components they emphasize.

**Properties:**
- `emphasis`: How strongly this visual element is featured
- `progression`: How the visual challenge increases
- `cue_type`: Visual cue methodology used

**Example:**
```cypher
MATCH (d:Drill {name: 'Passing Reading Drill'})
MATCH (v:VisualElement {name: 'TrajectoryPrediction'})
CREATE (d)-[r:FOCUSES_ON {
  emphasis: 'high',
  progression: 'varied tempo serves then attacks',
  cue_type: 'early arm position recognition'
}]->(v)
```

## REQUIRES_COURT_CAPACITY (Drill→CourtCapacity)

Defines the player count requirements for a drill per court.

**Properties:**
- `optimal_players`: Ideal number of players (typically 6)
- `maximum_players`: Maximum allowed (never exceeds 8)
- `rotation_efficiency`: How well players cycle through active positions
- `adapts_to_odd_count`: Whether drill can accommodate odd player counts

**Example:**
```cypher
MATCH (d:Drill {name: 'King of the Court'})
MATCH (cc:CourtCapacity)
CREATE (d)-[r:REQUIRES_COURT_CAPACITY {
  optimal_players: 6,
  maximum_players: 8,
  rotation_efficiency: "high",
  adapts_to_odd_count: true
}]->(cc)
```

## PARTICIPATES_AS (Coach→PracticeParticipant)

Defines how a coach participates in practice sessions as a player.

**Properties:**
- `role`: Participation type (regular player, specialized position)
- `primary_purpose`: Main reason for participation
- `secondary_purpose`: Additional benefits
- `usage_frequency`: How often coach participates
- `energy_management`: How coach balances playing and coaching

**Example:**
```cypher
MATCH (c:Coach {id: 'coach456'})
MATCH (pp:PracticeParticipant)
CREATE (c)-[r:PARTICIPATES_AS {
  role: "Fill-in player",
  primary_purpose: "Balance teams for 2v2 structure",
  secondary_purpose: "Demonstrate techniques in game context",
  usage_frequency: "As needed for odd numbers",
  energy_management: "Limited rotations to maintain coaching focus"
}]->(pp)
```

## APPLIES_CONSTRAINT (Coach→GameplayConstraint)

Connects a coach to gameplay constraints they implement during practice.

**Properties:**
- `context`: When to apply this constraint
- `progression`: How to increase difficulty
- `feedback_approach`: How to provide input during constrained play
- `success_metrics`: How to measure effectiveness

**Example:**
```cypher
MATCH (c:Coach {id: 'coach456'})
MATCH (gc:GameplayConstraint {name: 'Shot Selection Constraint'})
CREATE (c)-[r:APPLIES_CONSTRAINT {
  context: "4-player gameplay focus",
  progression: "Begin with simple limitations, add complexity",
  feedback_approach: "Immediate during natural breaks",
  success_metrics: "Shot selection improvement in unconstrained play"
}]->(gc)
```

## OPTIMAL_CONFIGURATION (CourtCapacity→OptimalConfiguration)

Connects court capacity constraints to specific optimal player arrangements.

**Properties:**
- `player_count`: Number of players in this configuration
- `formation`: How players are organized
- `active_time_percentage`: Portion of time players are active
- `rotation_trigger`: What causes player rotation
- `rotation_pattern`: How players cycle through positions

**Example:**
```cypher
MATCH (cc:CourtCapacity)
MATCH (oc:OptimalConfiguration)
CREATE (cc)-[r:OPTIMAL_CONFIGURATION {
  player_count: 6,
  formation: "Three teams of 2 rotating (king of the court)",
  active_time_percentage: 67,
  rotation_trigger: "Point completion",
  rotation_pattern: "Winning team stays, losing team exits, waiting team enters"
}]->(oc)
```

These relationships form the foundation of the beach volleyball training knowledge graph, connecting skills, drills, and conceptual frameworks in a semantically rich structure that supports practice planning and player development.