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

These relationships form the foundation of the beach volleyball training knowledge graph, connecting skills, drills, and conceptual frameworks in a semantically rich structure that supports practice planning and player development.