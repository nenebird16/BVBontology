# Beach Volleyball Ontology Glossary

This document serves as a comprehensive reference for all important terms and entity definitions used in the Beach Volleyball knowledge graph.

## Core Entity Types

### Person Entities

#### Person:Athlete
An individual who participates in beach volleyball training and competition.
- **Properties**: name, skill_level, position, visual_strengths, visual_development_areas, learning_preferences
- **Relationships**: PRACTICED, EXECUTED, SELF_ASSESSED, MEMBER_OF
- **Query Reference**: Use `(a:Person:Athlete)` in Cypher queries

#### Person:Coach
An individual who provides instruction, feedback, and planning for volleyball development.
- **Properties**: name, specialties, philosophy, certification_level
- **Relationships**: COACH_ASSESSED, RECOMMENDED, CREATED_PLAN
- **Query Reference**: Use `(c:Person:Coach)` in Cypher queries

#### Person:Trainer
Strength and conditioning specialist focused on physical development.
- **Properties**: name, specialties, certifications, focus_areas
- **Query Reference**: Use `(t:Person:Trainer)` in Cypher queries

### Activity Entities

#### Skill
A technical volleyball capability that can be practiced and developed.
- **Properties**: name, difficulty, category, biomechanics, visualRequirements
- **Relationships**: REQUIRES, PRACTICED, ASSESSED
- **Query Reference**: Use `(s:Skill)` in Cypher queries

#### Drill
A structured practice exercise designed to develop specific skills.
- **Properties**: name, intensity, focus_area, duration, equipment_needed, description, variations, initiation
- **Relationships**: DEVELOPS, REQUIRES, ALIGNS_WITH, FOCUSES_ON
- **Query Reference**: Use `(d:Drill)` in Cypher queries

#### PracticePlan
A structured outline for a training session.
- **Properties**: name, focus, duration, target_group, progression, equipment_needed
- **Relationships**: INCLUDES, TARGETS
- **Query Reference**: Use `(p:PracticePlan)` in Cypher queries

#### Framework
A conceptual structure for organizing skills and drills.
- **Properties**: name, category, description, research_basis, application_areas
- **Relationships**: INTEGRATES, INFORMS, ALIGNS_WITH
- **Query Reference**: Use `(f:Framework)` in Cypher queries

### Organizational Entities

#### TrainingGroup
A collection of athletes who practice together.
- **Properties**: name, focus, skill_level, practice_frequency, size, age_range
- **Relationships**: MEMBER_OF, TARGETS
- **Query Reference**: Use `(tg:TrainingGroup)` in Cypher queries

#### StrategicConcept
High-level tactical or strategic approach.
- **Properties**: name, category, description, application_context, related_skills
- **Relationships**: RELATED_TO, INTEGRATES
- **Query Reference**: Use `(sc:StrategicConcept)` in Cypher queries

#### Equipment
Physical items used in training.
- **Properties**: name, description, usage, variations
- **Relationships**: REQUIRES
- **Query Reference**: Use `(e:Equipment)` in Cypher queries

## Core Relationships

### Skill Development

#### DEVELOPS (Drill→Skill)
Connects a drill to the skill it is designed to improve.
- **Properties**: primary, development_phase, effectiveness_rating

#### REQUIRES (Skill→Skill)
Indicates prerequisite skills needed before learning more advanced skills.
- **Properties**: strength, transfer_effect

### Training Activities

#### PRACTICED (Person:Athlete→Skill)
Records when an athlete has worked on a particular skill.
- **Properties**: timestamp, duration, quality_rating, repetitions, context, notes

#### EXECUTED (Person:Athlete→Drill)
Records when an athlete has completed a specific drill.
- **Properties**: timestamp, completion_percentage, performance_rating, adaptation_notes, partner

#### INCLUDES (PracticePlan→Drill)
Connects a practice plan to the drills it contains.
- **Properties**: sequence_order, duration, intensity_modification, focus_points

### Assessment

#### SELF_ASSESSED (Person:Athlete→Skill)
Athlete's evaluation of their own skill execution.
- **Properties**: timestamp, rating, confidence, context, progress_perception

#### COACH_ASSESSED (Person:Coach→Skill)
Coach's evaluation of an athlete's skill execution.
- **Properties**: timestamp, athlete_id, rating, technical_notes, developmental_stage

## Visual Motor Integration

#### FOCUSES_ON (Drill→VisualElement)
Connects drills to the visual components they emphasize.
- **Properties**: emphasis, progression, cue_type

#### VisualElement
A specific aspect of visual-motor integration training.
- **Types**: TrajectoryPrediction, PeripheralAwareness, DepthPerception, VisualCueing
- **Query Reference**: Use `(v:VisualElement)` in Cypher queries

## Best Practices

### Entity Labeling
- Use multiple labels for person entities: `Person:Athlete`, `Person:Coach`
- This explicitly models the is-a relationship (an Athlete is-a Person)
- Enables queries by role or generally as people

### Variable Naming in Queries
- Use `a` for athletes: `MATCH (a:Person:Athlete)`
- Use `c` for coaches: `MATCH (c:Person:Coach)`
- Use `s` for skills: `MATCH (s:Skill)`
- Use `d` for drills: `MATCH (d:Drill)`
- Use descriptive names for complex queries

### Relationship Property Formats
- Use ISO 8601 for durations: `PT30M` (30 minutes)
- Use Neo4j datetime objects for timestamps: `datetime('2022-07-15')`
- Use consistent rating scales (1-10) for assessments