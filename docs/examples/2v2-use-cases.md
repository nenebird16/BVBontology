# Beach Volleyball 2v2 Structure Use Cases

## Use Case 1: Maintaining 2v2 Structure with Varying Player Numbers

### Scenario
Coach Mark has 7 players at practice but only one available court. He needs to design a practice that maintains the fundamental 2v2 structure of beach volleyball while ensuring all players get adequate playing time.

### Knowledge Graph Solution
1. **Player Distribution Analysis**:
   ```cypher
   MATCH (cc:CourtCapacity)
   WITH cc, 7 AS player_count, 1 AS available_courts
   WITH cc, player_count, available_courts,
        player_count / available_courts AS players_per_court
   WHERE players_per_court <= cc.maximum_players_per_court
   MATCH (cc)-[contingency:CONTINGENCY_CONFIGURATION]->(contc)
   WHERE contingency.player_count = players_per_court
   RETURN contc.formation AS recommended_formation,
          contc.rotation_pattern AS rotation_strategy,
          contc.specialized_role AS specialized_role
   ```

2. **Drill Selection**:
   ```cypher
   MATCH (d:Drill)
   WHERE d.team_structure = "2v2"
      AND d.allows_specialized_role = true
   MATCH (d)-[:REQUIRES_COURT_CAPACITY]->(cc:CourtCapacity)
   WHERE cc.maximum_players_per_court >= 7
   RETURN d.name, d.description, d.duration, d.intensity
   ORDER BY d.intensity
   ```

3. **Coach Participation Decision**:
   ```cypher
   MATCH (c:Coach {name: 'Mark'})
   WITH c, 7 AS player_count,
        player_count % 2 = 1 AS odd_player_count
   RETURN c.name, c.can_participate, c.playing_level,
          CASE
            WHEN odd_player_count THEN "Consider participating to create even number"
            ELSE "No need to participate for numbers"
          END AS participation_recommendation
   ```

### Implementation
Mark uses the BeachBook app to:
1. Choose a "Three teams of 2 plus specialized role" configuration
2. Select drills that support this configuration and maintain 2v2 structure
3. Decide whether to participate or designate one player for specialized roles
4. Design specialized roles that rotate through all players

### Outcome
- Practice maintains 2v2 as the fundamental unit of play
- All players get playing time through efficient rotations
- The 7th player rotates through specialized roles (server, coach assistant)
- Beach volleyball core game structure is preserved even with odd numbers
- Players experience realistic game scenarios within the 2v2 format

## Use Case 2: Optimizing 4-Player Practice with Gameplay Constraints

### Scenario
Coach Sarah has exactly 4 players for practice and wants to maximize game-specific skill development rather than running traditional drills.

### Knowledge Graph Solution
1. **Identify Optimal Configuration**:
   ```cypher
   MATCH (cc:CourtCapacity)
   MATCH (cc)-[optimal:OPTIMAL_CONFIGURATION]->(oc)
   WHERE optimal.player_count = 4
   RETURN oc.formation, oc.active_time_percentage, 
          oc.coaching_approach, oc.recommended_format
   ```

2. **Find Appropriate Constraints**:
   ```cypher
   MATCH (oc:OptimalConfiguration {player_count: 4})-[:UTILIZES]->(gc:GameplayConstraint)
   RETURN gc.name, gc.description, gc.skill_focus, gc.implementation
   ```

3. **Select Gameplay-Focused Drills**:
   ```cypher
   MATCH (d:Drill)
   WHERE d.team_structure = "2v2"
     AND d.allows_gameplay_focus = true
   MATCH (d)-[:DEVELOPS]->(s:Skill)
   RETURN d.name, d.description, collect(DISTINCT s.name) AS skills_developed
   ```

### Implementation
Sarah uses the BeachBook app to:
1. Create a practice plan focused on pure 2v2 gameplay
2. Implement progressive gameplay constraints to target specific skills
3. Designate specific constraints for different game segments
4. Provide immediate feedback during natural breaks in play

### Outcome
- Players receive a more game-like training environment
- Skill development occurs in realistic contexts
- Coach can observe and provide feedback without disrupting play flow
- Players develop decision-making in game scenarios
- Practice efficiency is maximized with 100% active time for all players

## Use Case 3: Coach Participation for 3-Player Practice

### Scenario
Coach James has only 3 athletes show up for practice and needs to decide how to structure the session while maintaining the 2v2 format.

### Knowledge Graph Solution
1. **Coach Participation Analysis**:
   ```cypher
   MATCH (c:Coach {name: 'James'})
   WITH c, 3 AS player_count
   RETURN c.can_participate, c.playing_level, 
          "Coach participation recommended to create 2v2" AS recommendation
   ```

2. **Appropriate Drill Selection**:
   ```cypher
   MATCH (d:Drill)
   WHERE d.team_structure = "2v2"
     AND d.allows_gameplay_focus = true
     AND d.optimal_player_count = 4
   MATCH (d)-[:DEVELOPS]->(s:Skill)
   RETURN d.name, d.description, collect(DISTINCT s.name) AS skills_developed
   ```

3. **Coach Role Optimization**:
   ```cypher
   MATCH (c:Coach {name: 'James'})-[:PARTICIPATES_AS]->(pp:PracticeParticipant)
   RETURN c.playing_specialization, 
          pp.rotation_expectations,
          "Defensive position with teaching opportunities" AS recommended_role
   ```

### Implementation
James uses the BeachBook app to:
1. Plan to participate as the fourth player to create a proper 2v2 format
2. Select constraint-based gameplay drills suitable for 4 players
3. Position himself in roles that allow for coaching while playing
4. Design gameplay constraints that target areas needing improvement

### Outcome
- Practice maintains the 2v2 structure fundamental to beach volleyball
- Athletes receive real-time feedback from coach during gameplay
- Coach balances playing and coaching responsibilities effectively
- Athletes experience realistic game scenarios
- Skill development occurs in proper game context