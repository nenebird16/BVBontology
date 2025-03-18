# Activity Entities

This document defines the activity-related entity types in the BeachBook knowledge graph.

## Skill

Technical volleyball capability that can be practiced and developed.

**Properties:**
- `name`: Skill name
- `difficulty`: Complexity level
- `category`: Skill classification (e.g., offensive, defensive)
- `biomechanics`: Physical movement patterns involved
- `visualRequirements`: Visual focus elements needed for execution

**Usage Context:**
Target of practice activities and subject of reflections.

## Drill

Structured practice exercise designed to develop specific skills.

**Properties:**
- `name`: Drill name
- `intensity`: Physical/mental demand level
- `focus_area`: Primary skill target
- `duration`: Typical time requirement
- `equipment_needed`: Required materials
- `description`: Detailed explanation of the drill
- `variations`: Alternative versions of the drill
- `initiation`: How the drill begins (e.g., coach toss, partner feed)
- `team_structure`: Fundamental player grouping (always "2v2" for beach volleyball)
- `optimal_player_count`: Ideal number of players for this drill (typically 4-6)
- `maximum_player_count`: Maximum players per court (never exceeds 8)
- `allows_specialized_role`: Whether drill supports odd-player participation
- `allows_gameplay_focus`: Whether drill is suitable for constraint-based gameplay

**Usage Context:**
Components of practice plans that players execute.

## Practice

Training session involving multiple drills and activities.

**Properties:**
- `date`: When the practice occurred
- `duration`: Total time
- `focus`: Primary development goals
- `effectiveness`: Perceived value
- `location`: Where practice took place
- `weather_conditions`: Environmental factors
- `progression`: Sequence of activities
- `court_count`: Number of courts used
- `players_per_court`: Distribution of players across courts
- `maintains_2v2_structure`: Whether practice preserved fundamental 2v2 format

**Usage Context:**
Container for multiple training activities and reflection context.

## Competition

Match or tournament where skills are applied.

**Properties:**
- `date`: When the competition occurred
- `opponents`: Who was played against
- `outcome`: Result
- `key_moments`: Critical points
- `conditions`: Environmental factors
- `performance_metrics`: Statistical measures

**Usage Context:**
Application context for skills and source of performance data.

## PracticePlan

Structured outline for a training session.

**Properties:**
- `name`: Plan identifier
- `focus`: Primary development goals
- `duration`: Total planned time
- `target_group`: Intended audience
- `progression`: Sequence of activities
- `equipment_needed`: Required materials
- `warm_up`: Initial activities
- `cool_down`: Concluding activities
- `total_players`: Expected number of participants
- `court_count`: Available courts for practice
- `players_per_court`: Planned distribution of players
- `coach_participation`: Whether coach will participate as player

**Usage Context:**
Blueprint for practice sessions, created by coaches and executed by players.

## Framework

Conceptual structure for organizing skills and drills.

**Properties:**
- `name`: Framework name
- `category`: Classification (e.g., visual-motor, tactical)
- `description`: Explanation of the framework
- `research_basis`: Scientific foundations
- `application_areas`: Where the framework applies

**Usage Context:**
Organizational system for relating skills, drills, and concepts.

## Assessment

Formal evaluation session comparing self and coach perspectives.

**Properties:**
- `date`: When assessment occurred
- `skills_evaluated`: Specific skills assessed
- `comparative_focus`: Areas of emphasis
- `growth_plan`: Resulting development strategy
- `follow_up_date`: When to review progress
- `self_assessment_metrics`: Player's evaluation data
- `coach_assessment_metrics`: Coach's evaluation data

**Usage Context:**
Critical touchpoint for aligning player and coach perspectives on development.

## StrategicConcept

High-level tactical or strategic approach.

**Properties:**
- `name`: Concept name
- `category`: Classification (offensive, defensive, transition)
- `description`: Explanation of the concept
- `application_context`: When to use this approach
- `related_skills`: Skills that support this concept

**Usage Context:**
Framework for organizing team patterns and individual decisions.

## CourtCapacity

Defines player distribution and utilization constraints for beach volleyball courts.

**Properties:**
- `optimal_players_per_court`: Recommended number (typically 6)
- `maximum_players_per_court`: Absolute maximum (8)
- `minimum_players_per_court`: Minimum for 2v2 play (4)
- `rationale`: Explanation for these constraints

**Usage Context:**
Guides practice planning and player distribution across available courts.

## GameplayConstraint

Structured limitation applied to gameplay for targeted development.

**Properties:**
- `name`: Constraint identifier
- `description`: How the constraint works
- `skill_focus`: What skills this develops
- `implementation`: How to apply in practice
- `progression`: How to advance difficulty

**Usage Context:**
Applied primarily in 4-player (pure 2v2) contexts to create deliberate practice within gameplay.