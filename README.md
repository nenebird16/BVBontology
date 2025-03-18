# BVBontology

Knowledge graph schema and ontology for beach volleyball coaching and athlete development.

## Project Overview

This repository contains the ontology and knowledge graph implementation for beach volleyball coaching and athlete development. It serves as the data foundation for the BeachBook application, integrating:

1. **Core Beach Volleyball Domain**
   - Skills (passing, setting, attacking, etc.)
   - Drills with detailed metadata
   - Training frameworks like Visual-Motor Integration
   - Practice plans with sequences and progressions

2. **Specialized Training Elements**
   - Visual focus elements (ball tracking, peripheral awareness) 
   - Drill initiation types (partner toss, coach on box)
   - Feedback mechanisms
   - Drill categorization and sequencing logic

3. **BeachBook App Integration**
   - Feature nodes connected to volleyball frameworks
   - Feature dependencies and relationships
   - Practice plan generation connections

## Entity Labeling Convention

This project uses multiple labels for person entities:
- `Person:Athlete` for volleyball players
- `Person:Coach` for instructors and trainers
- `Person:Trainer` for physical development specialists
- `Person:ParentGuardian` for youth athlete oversight

This approach explicitly models the is-a relationship (an Athlete is-a Person) and enables querying by role or generally as people. For example:

```cypher
// Find all people
MATCH (p:Person) RETURN p

// Find only athletes
MATCH (a:Person:Athlete) RETURN a

// Find coaches who are also athletes (player-coaches)
MATCH (pc:Person:Coach:Athlete) RETURN pc
```

For consistent variable naming in queries:
- Use `(a:Person:Athlete)` for athletes
- Use `(c:Person:Coach)` for coaches
- Use descriptive names for complex queries

## Core Beach Volleyball Principles

This ontology enforces several fundamental principles of beach volleyball training:

1. **2v2 Structure Preservation**: 
   - All drills and activities maintain the fundamental 2v2 team structure of beach volleyball
   - Practice plans accommodate varying athlete numbers while preserving this core format
   - Special handling for odd-numbered groups through specialized roles

2. **Court Capacity Optimization**:
   - Optimal athlete count: 6 athletes per court (three teams of 2)
   - Maximum athlete count: 8 athletes per court (four teams of 2)
   - Special consideration for exactly 4 athletes (pure 2v2 gameplay focus)

3. **Coach Integration**:
   - Coaches can participate as athletes when needed for numbers
   - Coach participation is modeled with specific properties and relationships
   - Special guidance for 3-athlete scenarios where coach participation creates 2v2

4. **Gameplay Constraints**:
   - For 4-athlete (pure 2v2) practice sessions, emphasis on constraint-based coaching
   - Technical, tactical and decision-making constraints applied to gameplay
   - Maintains game flow while creating deliberate practice conditions

## Current Implementation

The knowledge graph emphasizes the visual-motor integration aspects of beach volleyball training while providing a structure that can support AI-assisted practice planning through the BeachBook application.

### Approach Used

1. **Schema Design**: Created a comprehensive ontology based on Notion databases
2. **Data Import**: Built nodes and relationships from Drills & Games, Frameworks, and Practice Plans
3. **Enhanced Modeling**: Added specialized nodes for deeper training context
4. **Relationship Building**: Established meaningful connections between all elements
5. **Verification**: Tested with queries to ensure practical applications work

## Repository Structure

- `/docs`: Conceptual documentation of the ontology
  - `/schema`: Entity and relationship definitions
  - `/examples`: Sample use cases and data models
  - `/glossary.md`: Comprehensive reference for all terms and entities
- `/implementation`: Technical implementation details
  - `/neo4j`: Neo4j-specific schema and queries
  - `/cypher`: Common query patterns
- `/integration`: Application integration points
  - `/api`: API endpoints for BeachBook application
  - `/procedures`: Custom procedures for AI-assisted planning

## Next Steps

To continue developing this knowledge graph:

1. **Data Enrichment**:
   - Import more drills with their complete metadata
   - Add athlete nodes with skill proficiencies
   - Expand training groups with complete team rosters
   - Add weather conditions and court-specific adaptations

2. **Query Development**:
   - Create parameterized queries for practice plan generation
   - Build recommendation queries based on skill gaps
   - Develop drill progression paths based on athlete skill levels
   - Add temporal analysis of skill development

3. **Knowledge Graph Integration**:
   - Connect to BeachBook backend via API endpoints
   - Create procedures for AI agent utilization
   - Add visualization components for coaching dashboards
   - Implement automated data import from Notion

4. **Advanced Features**:
   - Add weighted relationships for more nuanced recommendations
   - Implement temporal awareness for tracking improvement
   - Develop drill recommendation algorithms based on previous practice success
   - Create athlete-specific adaptation models

5. **Maintenance Plan**:
   - Schedule regular updates from Notion databases
   - Create version tracking for ontology changes
   - Implement validation checks for data consistency
   - Develop monitoring for relationship health