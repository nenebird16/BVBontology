// BeachBook Knowledge Graph Schema - Core Components
// This file contains the Cypher statements to create the initial schema

// ========== CONSTRAINTS ==========
// Ensure entity uniqueness

// User Entities
CREATE CONSTRAINT person_athlete_name IF NOT EXISTS FOR (a:Person:Athlete) REQUIRE a.name IS UNIQUE;
CREATE CONSTRAINT person_coach_name IF NOT EXISTS FOR (c:Person:Coach) REQUIRE c.name IS UNIQUE;
CREATE CONSTRAINT training_group_name IF NOT EXISTS FOR (t:TrainingGroup) REQUIRE t.name IS UNIQUE;

// Activity Entities
CREATE CONSTRAINT skill_name IF NOT EXISTS FOR (s:Skill) REQUIRE s.name IS UNIQUE;
CREATE CONSTRAINT drill_name IF NOT EXISTS FOR (d:Drill) REQUIRE d.name IS UNIQUE;
CREATE CONSTRAINT practice_plan_name IF NOT EXISTS FOR (p:PracticePlan) REQUIRE p.name IS UNIQUE;
CREATE CONSTRAINT framework_name IF NOT EXISTS FOR (f:Framework) REQUIRE f.name IS UNIQUE;
CREATE CONSTRAINT strategic_concept_name IF NOT EXISTS FOR (s:StrategicConcept) REQUIRE s.name IS UNIQUE;
CREATE CONSTRAINT equipment_name IF NOT EXISTS FOR (e:Equipment) REQUIRE e.name IS UNIQUE;
CREATE CONSTRAINT feature_name IF NOT EXISTS FOR (f:Feature) REQUIRE f.name IS UNIQUE;

// ========== INDEXES ==========
// Optimize query performance

// Category indexes for filtering
CREATE INDEX skill_category IF NOT EXISTS FOR (s:Skill) ON (s.category);
CREATE INDEX drill_focus IF NOT EXISTS FOR (d:Drill) ON (d.focus_area);
CREATE INDEX framework_category IF NOT EXISTS FOR (f:Framework) ON (f.category);

// Person related indexes
CREATE INDEX person_name IF NOT EXISTS FOR (p:Person) ON (p.name);
CREATE INDEX athlete_skill_level IF NOT EXISTS FOR (a:Person:Athlete) ON (a.skill_level);

// ========== BASE ENTITY TYPES ==========
// Create basic node structure

// Core Knowledge Node - base type for ontological inheritance
CREATE (kn:KnowledgeNode {name: 'KnowledgeNode', description: 'Base node type for ontological inheritance'});

// ========== EXAMPLE DATA ==========
// Create sample nodes and relationships to demonstrate schema

// Create Skill nodes
CREATE (s1:Skill {
  name: 'Passing',
  description: 'Controlled reception of serve or attack to target',
  category: 'Ball Control',
  skillLevel: 'Foundational',
  visualRequirements: 'Ball trajectory tracking, target awareness'
});

CREATE (s2:Skill {
  name: 'Setting',
  description: 'Precise ball delivery to attacker',
  category: 'Ball Control',
  skillLevel: 'Intermediate',
  visualRequirements: 'Partner positioning, ball spin control'
});

CREATE (s3:Skill {
  name: 'Jump Serve',
  description: 'Aggressive overhead serve with jump',
  category: 'Serving',
  skillLevel: 'Advanced',
  visualRequirements: 'Target zone focus, ball toss tracking'
});

// Create Drill nodes
CREATE (d1:Drill {
  name: 'Vision Passing Progression',
  description: 'Partner passing with visual restriction progressions',
  focus_area: 'ball control',
  intensity: 'medium',
  duration: 15,
  equipment_needed: 'Vision limiting goggles, volleyballs',
  visual_elements: 'Peripheral awareness, trajectory prediction',
  targets: 'Consistent platform angle, accurate target placement'
});

CREATE (d2:Drill {
  name: 'Serving Pressure Series',
  description: 'Serving progression with increasing pressure situations',
  focus_area: 'serving',
  intensity: 'high',
  duration: 20,
  equipment_needed: 'Volleyballs, court targets',
  visual_elements: 'Target focus, defensive positioning awareness',
  targets: 'Accuracy, consistency under pressure'
});

// Create Framework nodes
CREATE (f1:Framework {
  name: 'Visual-Motor Integration',
  description: 'Framework connecting visual processing to motor execution',
  category: 'Skill Development',
  research_basis: 'Sports vision training literature, perception-action coupling',
  application_areas: 'All ball control skills, defensive positioning, attack decisions'
});

CREATE (f2:Framework {
  name: 'Constraint-Led Approach',
  description: 'Using environmental, task and performer constraints to shape learning',
  category: 'Instructional Design',
  research_basis: 'Ecological dynamics, skill acquisition research',
  application_areas: 'Drill design, practice planning, skill transfer'
});

// Create Practice Plan nodes
CREATE (p1:PracticePlan {
  name: 'Visual Skills Beginner Plan',
  focus: 'Developing fundamental visual-motor skills',
  duration: 90,
  target_group: 'Beginner athletes',
  progression: 'Simple to complex visual tracking',
  equipment_needed: 'Vision limiting goggles, varied ball types, targets'
});

CREATE (p2:PracticePlan {
  name: 'Defensive Positioning Advanced Plan',
  focus: 'Reading and anticipation for defensive positioning',
  duration: 120,
  target_group: 'Advanced athletes',
  progression: 'Cued to uncued, increasing decision complexity',
  equipment_needed: 'Blocking tools, coach platform, video delay system'
});

// Create StrategicConcept nodes
CREATE (sc1:StrategicConcept {
  name: 'Serve to Set Up Block',
  category: 'Defensive Strategy',
  description: 'Using serve placement to dictate attacker options and optimize block positioning',
  application_context: 'Team defensive strategy, service tactical planning',
  related_skills: 'Jump serve, float serve, block positioning'
});

CREATE (sc2:StrategicConcept {
  name: 'Split-Block Defense',
  category: 'Defensive Strategy',
  description: 'Coordinated blocking and defensive coverage based on attacker tendencies',
  application_context: 'High-level team defense, scouting-based adjustments',
  related_skills: 'Block timing, defensive positioning, reading'
});

// Create Equipment nodes
CREATE (e1:Equipment {
  name: 'Vision Occlusion Goggles',
  description: 'Eyewear that restricts visual input during training',
  usage: 'Visual skill development, forcing peripheral awareness',
  variations: 'Full occlusion, partial occlusion, delayed vision models'
});

CREATE (e2:Equipment {
  name: 'Variable Target System',
  description: 'LED-based targets that can be dynamically activated',
  usage: 'Decision making training, reactive passing drills',
  variations: 'Wall-mounted, floor-positioned, court integration versions'
});

// Create Person:Athlete nodes
CREATE (a1:Person:Athlete {
  name: 'Alex Johnson',
  skill_level: 'Advanced',
  position: 'Blocker',
  visual_strengths: 'Ball tracking, opponent reading',
  visual_development_areas: 'Peripheral awareness during transition',
  learning_preferences: 'Visual demonstration, deliberate practice'
});

CREATE (a2:Person:Athlete {
  name: 'Sam Rivera',
  skill_level: 'Intermediate',
  position: 'Defender',
  visual_strengths: 'Defensive positioning, attack reading',
  visual_development_areas: 'Trajectory prediction at high speeds',
  learning_preferences: 'Progressive challenge, conceptual understanding'
});

// Create Person:Coach nodes
CREATE (c1:Person:Coach {
  name: 'Sarah Smith',
  specialties: 'Defensive training, visual skill development',
  certification_level: 'Advanced',
  philosophy: 'Progressive challenge, visual-motor integration',
  playing_level: 'Advanced'
});

// Create Training Group nodes
CREATE (tg1:TrainingGroup {
  name: 'Advanced Competition Team',
  focus: 'Pre-competition refinement',
  skill_level: 'Advanced',
  practice_frequency: 'Daily',
  size: 12,
  age_range: '22-28'
});

CREATE (tg2:TrainingGroup {
  name: 'Youth Development Program',
  focus: 'Fundamental skill development with visual emphasis',
  skill_level: 'Beginner to Intermediate',
  practice_frequency: 'Three times weekly',
  size: 24,
  age_range: '14-18'
});

// Create Application Feature nodes
CREATE (feat1:Feature {
  name: 'Practice Plan Generator',
  description: 'AI-assisted practice plan creation based on skill gaps',
  dependencies: 'Drill database, skill assessment data',
  user_roles: 'Coach, Trainer',
  technical_requirements: 'Neo4j knowledge graph integration'
});

CREATE (feat2:Feature {
  name: 'Visual Skill Development Tracker',
  description: 'Tool to monitor progress in visual-motor integration skills',
  dependencies: 'Assessment data, framework linkages',
  user_roles: 'Athlete, Coach',
  technical_requirements: 'Time-series data visualization, assessment tools'
});

// Create additional relationships
CREATE (a1)-[:MEMBER_OF]->(tg1);
CREATE (a2)-[:MEMBER_OF]->(tg2);
CREATE (sc1)-[:RELATED_TO {relevance: 8}]->(s3);
CREATE (d1)-[:REQUIRES]->(e1);
CREATE (p1)-[:TARGETS]->(tg2);
CREATE (p2)-[:TARGETS]->(tg1);
CREATE (feat1)-[:IMPLEMENTS]->(f1);
CREATE (f1)-[:INFORMS]->(p1);
CREATE (a1)-[:PRACTICED {
  timestamp: datetime('2022-07-10T15:30:00'),
  duration: 45,
  quality_rating: 7,
  repetitions: 50
}]->(s3);

// Create skill dependency hierarchy
CREATE (s2)-[:REQUIRES {strength: 7}]->(s1);
CREATE (s3)-[:REQUIRES {strength: 8}]->(s2);

// Create framework concept relationships
CREATE (f1)-[:INTEGRATES]->(sc1);
CREATE (f2)-[:INTEGRATES]->(sc2);

// Create app feature dependency relationships
CREATE (feat2)-[:DEPENDS_ON]->(feat1);
CREATE (feat1)-[:UTILIZES]->(p1);
CREATE (feat1)-[:UTILIZES]->(p2);

// Create drill sequence for practice progression
CREATE (d1)-[:PRECEDES {reason: 'skill progression'}]->(d2);
CREATE (p1)-[:INCLUDES {sequence_order: 1}]->(d1);
CREATE (p1)-[:INCLUDES {sequence_order: 2}]->(d2);

// Create assessment relationships
CREATE (a1)-[:SELF_ASSESSED {
  timestamp: datetime('2022-07-15'),
  rating: 7,
  confidence: 'medium',
  context: 'competition preparation'
}]->(s3);

// Create coach assessment relationship
CREATE (c1)-[:COACH_ASSESSED {
  timestamp: datetime('2022-07-16'),
  athlete_id: 'Alex Johnson',
  rating: 6,
  technical_notes: 'Inconsistent toss height',
  developmental_stage: 'conscious competence'
}]->(s3);

// Create relationship between coach and athlete
CREATE (c1)-[:TRAINS]->(a1);
CREATE (c1)-[:TRAINS]->(a2);