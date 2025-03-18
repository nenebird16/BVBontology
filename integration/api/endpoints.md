# BeachBook API Integration

This document outlines how the BeachBook application can integrate with the beach volleyball ontology via API endpoints.

## API Overview

The BeachBook API provides programmatic access to the beach volleyball knowledge graph, enabling dynamic practice planning, skill assessment, and performance tracking.

## Core Endpoints

### Player Management

#### `GET /api/athletes`
Retrieve all athletes in the system.

**Example Response:**
```json
{
  "athletes": [
    {
      "id": "athlete-123",
      "name": "Alex Johnson",
      "skill_level": "Advanced",
      "position": "Blocker",
      "visual_strengths": "Ball tracking, opponent reading",
      "visual_development_areas": "Peripheral awareness during transition",
      "learning_preferences": "Visual demonstration, deliberate practice"
    },
    {
      "id": "athlete-456",
      "name": "Sam Rivera",
      "skill_level": "Intermediate",
      "position": "Defender",
      "visual_strengths": "Defensive positioning, attack reading",
      "visual_development_areas": "Trajectory prediction at high speeds",
      "learning_preferences": "Progressive challenge, conceptual understanding"
    }
  ]
}
```

#### `GET /api/athletes/{id}`
Retrieve a specific athlete's details.

#### `POST /api/athletes`
Create a new athlete record.

**Example Request:**
```json
{
  "name": "Jordan Smith",
  "skill_level": "Intermediate",
  "position": "All-around",
  "visual_strengths": "Court vision, defensive reading",
  "visual_development_areas": "Setting under pressure",
  "learning_preferences": "Video analysis, incremental challenges"
}
```

#### `PUT /api/athletes/{id}`
Update an athlete's details.

#### `DELETE /api/athletes/{id}`
Remove an athlete.

### Skill Assessment

#### `GET /api/athletes/{id}/skills`
Retrieve all skills assessed for an athlete.

**Example Response:**
```json
{
  "athlete_id": "athlete-123",
  "athlete_name": "Alex Johnson",
  "skills": [
    {
      "skill_name": "Jump Serve",
      "self_assessment": {
        "rating": 7,
        "timestamp": "2022-07-10T15:30:00Z",
        "confidence": "medium",
        "notes": "Improving toss consistency"
      },
      "coach_assessment": {
        "rating": 6,
        "timestamp": "2022-07-11T10:00:00Z",
        "notes": "Inconsistent arm swing path"
      },
      "gap": {
        "value": 1,
        "category": "overestimation",
        "action_plan": "Video analysis of arm swing mechanics"
      }
    },
    {
      "skill_name": "Passing",
      "self_assessment": {
        "rating": 8,
        "timestamp": "2022-07-12T15:30:00Z",
        "confidence": "high",
        "notes": "Good platform control"
      },
      "coach_assessment": {
        "rating": 7,
        "timestamp": "2022-07-13T10:00:00Z",
        "notes": "Inconsistent footwork on move"
      },
      "gap": {
        "value": 1,
        "category": "overestimation",
        "action_plan": "Movement pattern drills"
      }
    }
  ]
}
```

#### `POST /api/athletes/{id}/skills/{skill_name}/assessment`
Record a new skill assessment.

**Example Request:**
```json
{
  "assessor_type": "self",
  "rating": 7,
  "confidence": "medium",
  "context": "post-practice",
  "notes": "Felt improvement in arm swing consistency"
}
```

#### `GET /api/athletes/{id}/assessment-gaps`
Retrieve assessment gaps for an athlete.

### Practice Planning

#### `GET /api/drills`
Retrieve all drills.

**Example Response:**
```json
{
  "drills": [
    {
      "id": "drill-123",
      "name": "Vision Passing Progression",
      "description": "Partner passing with visual restriction progressions",
      "focus_area": "ball control",
      "intensity": "medium",
      "duration": 15,
      "equipment_needed": ["Vision limiting goggles", "volleyballs"],
      "visual_elements": "Peripheral awareness, trajectory prediction",
      "targets": "Consistent platform angle, accurate target placement",
      "skills_developed": ["Passing", "Reading"]
    },
    {
      "id": "drill-456",
      "name": "Serving Pressure Series",
      "description": "Serving progression with increasing pressure situations",
      "focus_area": "serving",
      "intensity": "high",
      "duration": 20,
      "equipment_needed": ["Volleyballs", "court targets"],
      "visual_elements": "Target focus, defensive positioning awareness",
      "targets": "Accuracy, consistency under pressure",
      "skills_developed": ["Jump Serve", "Float Serve", "Pressure Management"]
    }
  ]
}
```

#### `GET /api/practice-plans/generate`
Generate a practice plan based on provided parameters.

**Example Request:**
```json
{
  "athlete_id": "athlete-123",
  "focus_skills": ["Jump Serve", "Passing"],
  "duration": 90,
  "available_equipment": ["Volleyballs", "Cones", "Targets"],
  "visual_focus": true
}
```

**Example Response:**
```json
{
  "practice_plan": {
    "id": "plan-789",
    "duration": 90,
    "focus": "Serve and Pass with Visual Integration",
    "athlete": {
      "id": "athlete-123",
      "name": "Alex Johnson"
    },
    "sections": [
      {
        "name": "Warm-up",
        "duration": 15,
        "drills": [
          {
            "id": "drill-234",
            "name": "Progressive Visual Tracking",
            "duration": 10,
            "intensity": "low",
            "equipment": ["Volleyballs"],
            "visual_focus": "Peripheral awareness"
          },
          {
            "id": "drill-235",
            "name": "Dynamic Movement Patterns",
            "duration": 5,
            "intensity": "low",
            "equipment": ["Cones"],
            "visual_focus": "Spatial awareness"
          }
        ]
      },
      {
        "name": "Skill Development",
        "duration": 45,
        "drills": [
          {
            "id": "drill-123",
            "name": "Vision Passing Progression",
            "duration": 20,
            "intensity": "medium",
            "equipment": ["Volleyballs"],
            "visual_focus": "Trajectory prediction"
          },
          {
            "id": "drill-456",
            "name": "Serving Pressure Series",
            "duration": 25,
            "intensity": "high",
            "equipment": ["Volleyballs", "Targets"],
            "visual_focus": "Target focus"
          }
        ]
      },
      {
        "name": "Integration",
        "duration": 25,
        "drills": [
          {
            "id": "drill-567",
            "name": "Serve and Pass Competition",
            "duration": 25,
            "intensity": "high",
            "equipment": ["Volleyballs", "Targets"],
            "visual_focus": "Multi-task processing"
          }
        ]
      },
      {
        "name": "Cool Down",
        "duration": 5,
        "drills": [
          {
            "id": "drill-890",
            "name": "Visual Imagery Review",
            "duration": 5,
            "intensity": "low",
            "equipment": [],
            "visual_focus": "Mental rehearsal"
          }
        ]
      }
    ]
  }
}
```

#### `POST /api/practice-plans`
Save a practice plan.

#### `GET /api/practice-plans/{id}`
Retrieve a specific practice plan.

### Frameworks and Concepts

#### `GET /api/frameworks`
Retrieve all training frameworks.

**Example Response:**
```json
{
  "frameworks": [
    {
      "id": "framework-123",
      "name": "Visual-Motor Integration",
      "description": "Framework connecting visual processing to motor execution",
      "category": "Skill Development",
      "research_basis": "Sports vision training literature, perception-action coupling",
      "application_areas": "All ball control skills, defensive positioning, attack decisions",
      "strategic_concepts": [
        "Serve to Set Up Block",
        "Split-Block Defense"
      ]
    },
    {
      "id": "framework-456",
      "name": "Constraint-Led Approach",
      "description": "Using environmental, task and performer constraints to shape learning",
      "category": "Instructional Design",
      "research_basis": "Ecological dynamics, skill acquisition research",
      "application_areas": "Drill design, practice planning, skill transfer",
      "strategic_concepts": [
        "Progressive Challenge Design",
        "Environmental Adaptation"
      ]
    }
  ]
}
```

#### `GET /api/strategic-concepts`
Retrieve all strategic concepts.

## Implementation Notes

### Neo4j Integration

The API is backed by the Neo4j knowledge graph using the Cypher query language. Example implementation of the athlete skills endpoint:

```javascript
const express = require('express');
const neo4j = require('neo4j-driver');
const router = express.Router();

// Initialize Neo4j driver
const driver = neo4j.driver(
  'neo4j://localhost:7687',
  neo4j.auth.basic('neo4j', 'password')
);

// Get athlete skills with assessments
router.get('/api/athletes/:id/skills', async (req, res) => {
  const session = driver.session();
  try {
    const result = await session.run(
      `MATCH (a:Athlete {id: $athleteId})
       OPTIONAL MATCH (a)-[self:SELF_ASSESSED]->(s:Skill)
       OPTIONAL MATCH (c:Coach)-[coach:COACH_ASSESSED {athlete_id: $athleteId}]->(s)
       WITH a, s, self, coach
       WHERE self IS NOT NULL OR coach IS NOT NULL
       RETURN a.id AS athlete_id, a.name AS athlete_name,
              s.name AS skill_name,
              self.rating AS self_rating,
              self.timestamp AS self_timestamp,
              self.confidence AS self_confidence,
              self.notes AS self_notes,
              coach.rating AS coach_rating,
              coach.timestamp AS coach_timestamp,
              coach.notes AS coach_notes,
              CASE WHEN self IS NOT NULL AND coach IS NOT NULL
                   THEN self.rating - coach.rating
                   ELSE NULL
              END AS gap_value`,
      { athleteId: req.params.id }
    );
    
    // Process results into structured response
    const athleteData = {
      athlete_id: result.records[0].get('athlete_id'),
      athlete_name: result.records[0].get('athlete_name'),
      skills: []
    };
    
    for (const record of result.records) {
      const skillName = record.get('skill_name');
      
      // Build skill assessment object
      const skillData = {
        skill_name: skillName,
        self_assessment: record.get('self_rating') ? {
          rating: record.get('self_rating').toNumber(),
          timestamp: record.get('self_timestamp'),
          confidence: record.get('self_confidence'),
          notes: record.get('self_notes')
        } : null,
        coach_assessment: record.get('coach_rating') ? {
          rating: record.get('coach_rating').toNumber(),
          timestamp: record.get('coach_timestamp'),
          notes: record.get('coach_notes')
        } : null
      };
      
      // Add gap analysis if both assessments exist
      if (skillData.self_assessment && skillData.coach_assessment) {
        const gapValue = record.get('gap_value').toNumber();
        skillData.gap = {
          value: gapValue,
          category: gapValue > 0 ? 'overestimation' : 
                   gapValue < 0 ? 'underestimation' : 'aligned',
          action_plan: null // Would be populated from a separate query
        };
      }
      
      athleteData.skills.push(skillData);
    }
    
    res.json(athleteData);
  } catch (error) {
    console.error('Error retrieving athlete skills:', error);
    res.status(500).json({ error: 'Failed to retrieve athlete skills' });
  } finally {
    await session.close();
  }
});

module.exports = router;
```

### GraphQL API Alternative

The API can also be implemented using GraphQL for more flexible queries:

```graphql
type Athlete {
  id: ID!
  name: String!
  skill_level: String
  position: String
  visual_strengths: String
  visual_development_areas: String
  learning_preferences: String
  skills: [SkillAssessment]
  practices: [PracticeExecution]
  training_group: TrainingGroup
}

type SkillAssessment {
  skill: Skill!
  self_assessment: Assessment
  coach_assessment: Assessment
  gap: AssessmentGap
}

type Assessment {
  rating: Int!
  timestamp: DateTime!
  confidence: String
  notes: String
}

type AssessmentGap {
  value: Int!
  category: String!
  action_plan: String
}

type Skill {
  id: ID!
  name: String!
  category: String
  difficulty: String
  visual_requirements: String
  prerequisite_skills: [Skill]
  drills: [Drill]
}

type Drill {
  id: ID!
  name: String!
  description: String
  focus_area: String
  intensity: String
  duration: Int
  equipment_needed: [String]
  visual_elements: String
  skills_developed: [Skill]
  frameworks: [Framework]
}

type Framework {
  id: ID!
  name: String!
  description: String
  category: String
  strategic_concepts: [StrategicConcept]
}

type Query {
  athlete(id: ID!): Athlete
  athletes: [Athlete]
  drills(focus_area: String, skill: String): [Drill]
  generatePracticePlan(
    athlete_id: ID, 
    focus_skills: [String],
    duration: Int,
    available_equipment: [String],
    visual_focus: Boolean
  ): PracticePlan
}
```

## Security Considerations

- All API endpoints require authentication
- Athlete data is protected with role-based access control
- Coach users can only access their assigned athletes
- API requests are rate limited to prevent abuse
- All data is encrypted in transit
- Sensitive data is encrypted at rest