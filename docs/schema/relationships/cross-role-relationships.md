# Cross-Role Relationships

This document defines the relationships that connect different user roles in the BeachBook knowledge graph.

## REQUESTED_FEEDBACK_FROM (Player→Coach)

A player explicitly asking for input on specific skills or performance.

**Properties:**
- `timestamp`: When the request was made
- `context`: Situation prompting the request
- `specificity`: How targeted the request is
- `urgency`: How time-sensitive the request is

**Example:**
```cypher
MATCH (p:Player {id: 'player123'})
MATCH (c:Coach {id: 'coach456'})
CREATE (p)-[r:REQUESTED_FEEDBACK_FROM {
  timestamp: datetime(),
  context: 'competition preparation',
  specificity: 'serving technique',
  urgency: 'high'
}]->(c)
```

## SHARED_WITH (Player→Coach)

Player explicitly sharing reflection, video, or other content with coach.

**Properties:**
- `timestamp`: When the sharing occurred
- `content_type`: What kind of material was shared
- `permission_duration`: How long access is granted
- `purpose`: Why the content was shared

**Example:**
```cypher
MATCH (p:Player {id: 'player123'})
MATCH (c:Coach {id: 'coach456'})
MATCH (r:Reflection {id: 'reflection789'})
CREATE (p)-[s:SHARED_WITH {
  timestamp: datetime(),
  content_type: 'reflection',
  permission_duration: 'permanent',
  purpose: 'skill development'
}]->(r)
CREATE (r)-[:ACCESSIBLE_TO]->(c)
```

## RESPONDED_TO (Coach→Player)

Coach providing feedback to player request or shared content.

**Properties:**
- `timestamp`: When the response was given
- `response_time`: How long after the request
- `depth`: Level of detail provided
- `actionability`: How implementable the feedback is

**Example:**
```cypher
MATCH (c:Coach {id: 'coach456'})
MATCH (p:Player {id: 'player123'})
MATCH (f:Feedback {id: 'feedback101'})
CREATE (c)-[r:RESPONDED_TO {
  timestamp: datetime(),
  response_time: duration('PT8H'),
  depth: 'detailed',
  actionability: 'high'
}]->(p)
CREATE (c)-[:PROVIDED]->(f)
CREATE (f)-[:REGARDING]->(:Skill {name: 'jump serve'})
```

## RECOMMENDED (Coach→Drill)

Coach suggesting specific practice activities for player.

**Properties:**
- `timestamp`: When recommended
- `priority`: Importance level
- `reasoning`: Why it was suggested
- `customization`: Any player-specific adaptations

**Example:**
```cypher
MATCH (c:Coach {id: 'coach456'})
MATCH (p:Player {id: 'player123'})
MATCH (d:Drill {id: 'drill202'})
CREATE (c)-[r:RECOMMENDED {
  timestamp: datetime(),
  priority: 'high',
  reasoning: 'improve arm swing mechanics',
  customization: 'focus on contact point height'
}]->(d)
CREATE (p)-[:RECEIVED_RECOMMENDATION]->(d)
```

## SELF_ASSESSED (Player→Skill)

Player's evaluation of their own skill execution.

**Properties:**
- `timestamp`: When assessment occurred
- `rating`: Numerical evaluation (1-10)
- `confidence`: Certainty in the assessment
- `context`: Situation of the assessment
- `progress_perception`: Sense of improvement

**Example:**
```cypher
MATCH (p:Player {id: 'player123'})
MATCH (s:Skill {name: 'jump serve'})
CREATE (p)-[sa:SELF_ASSESSED {
  timestamp: datetime(),
  rating: 7,
  confidence: 'medium',
  context: 'post-practice',
  progress_perception: 'improving'
}]->(s)
```

## COACH_ASSESSED (Coach→Skill)

Coach's evaluation of player's skill execution.

**Properties:**
- `timestamp`: When assessment occurred
- `player_id`: Player being assessed
- `rating`: Numerical evaluation (1-10)
- `technical_notes`: Specific observations
- `developmental_stage`: Progress in skill acquisition

**Example:**
```cypher
MATCH (c:Coach {id: 'coach456'})
MATCH (p:Player {id: 'player123'})
MATCH (s:Skill {name: 'jump serve'})
CREATE (c)-[ca:COACH_ASSESSED {
  timestamp: datetime(),
  player_id: 'player123',
  rating: 6,
  technical_notes: 'inconsistent toss height',
  developmental_stage: 'conscious competence'
}]->(s)
CREATE (ca)-[:REGARDING]->(p)
```

## ASSESSMENT_GAP (Player→Coach)

Relationship capturing the difference between self and coach assessment.

**Properties:**
- `skill_id`: Skill being assessed
- `self_rating`: Player's score
- `coach_rating`: Coach's score
- `gap_value`: Numerical difference
- `gap_category`: Overestimation/underestimation/aligned
- `discussion_status`: Whether the gap has been addressed
- `action_plan`: Steps to address the gap

**Example:**
```cypher
MATCH (p:Player {id: 'player123'})
MATCH (c:Coach {id: 'coach456'})
MATCH (s:Skill {name: 'jump serve'})
MATCH (p)-[sa:SELF_ASSESSED]->(s)
MATCH (c)-[ca:COACH_ASSESSED]->(s)
WHERE sa.timestamp > datetime('2022-06-01') AND ca.timestamp > datetime('2022-06-01')
CREATE (p)-[ag:ASSESSMENT_GAP {
  skill_id: s.id,
  self_rating: sa.rating,
  coach_rating: ca.rating,
  gap_value: sa.rating - ca.rating,
  gap_category: CASE WHEN sa.rating > ca.rating THEN 'overestimation' 
                      WHEN sa.rating < ca.rating THEN 'underestimation' 
                      ELSE 'aligned' END,
  discussion_status: 'pending',
  action_plan: 'schedule review session'
}]->(c)
```

This relationship is particularly valuable for identifying development opportunities and calibrating player self-awareness. The `gap_value` and `gap_category` properties help prioritize areas where player perception differs significantly from coach assessment.