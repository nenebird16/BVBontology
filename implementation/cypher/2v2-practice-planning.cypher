// BeachBook Practice Plan Generation Queries with 2v2 Structure Enforcement
// These queries enforce the fundamental 2v2 structure of beach volleyball

// Generate a practice plan that enforces 2v2 structure with optimal court utilization
// Useful for: Creating practice plans that respect beach volleyball format
MATCH (tg:TrainingGroup {name: $groupName})
MATCH (a:Athlete)-[:MEMBER_OF]->(tg)
WITH count(a) AS player_count
MATCH (cc:CourtCapacity)
WITH player_count, cc,
     ceil(player_count / $available_courts) AS players_per_court
WHERE players_per_court <= cc.maximum_players_per_court
OPTIONAL MATCH (cc)-[optimal:OPTIMAL_CONFIGURATION]->(oc)
WHERE optimal.player_count = CASE
  WHEN players_per_court <= 4 THEN 4
  WHEN players_per_court <= 6 THEN 6
  ELSE 8
END
OPTIONAL MATCH (cc)-[contingency:CONTINGENCY_CONFIGURATION]->(contc)
WHERE contingency.player_count = players_per_court AND players_per_court IN [5, 7]
WITH player_count, players_per_court, 
     CASE WHEN optimal IS NOT NULL 
          THEN {config: oc, type: 'optimal'} 
          ELSE {config: contc, type: 'contingency'} 
     END AS configuration,
     $available_courts AS court_count

// Find appropriate drills based on configuration
MATCH (d:Drill)
WHERE d.team_structure = "2v2"  // Enforce 2v2 structure
AND CASE 
    WHEN configuration.type = 'optimal' AND configuration.config.player_count = 4
    THEN d.allows_gameplay_focus = true  // For 4 players, prioritize gameplay-focused drills
    ELSE true
END
AND CASE
    WHEN configuration.type = 'contingency' 
    THEN d.allows_specialized_role = true  // For odd numbers, require drills that support specialized roles
    ELSE true
END

// Get skills developed by each drill
MATCH (d)-[:DEVELOPS]->(s:Skill)
WITH d, configuration, collect(DISTINCT s.name) AS skills_developed, 
     player_count, players_per_court, court_count

// Calculate score for each drill based on configuration match
WITH d, configuration, skills_developed, 
     player_count, players_per_court, court_count,
     CASE 
       WHEN configuration.type = 'optimal' AND configuration.config.player_count = 4 AND d.allows_gameplay_focus = true
       THEN 3  // Highest priority for 4-player gameplay focus
       WHEN configuration.type = 'optimal' 
       THEN 2  // High priority for other optimal configurations
       WHEN configuration.type = 'contingency' AND d.allows_specialized_role = true
       THEN 1  // Medium priority for contingency configurations
       ELSE 0  // Lowest priority for non-matching drills
     END AS configuration_score

RETURN d.name AS drill_name,
       d.description AS description,
       d.duration AS duration,
       d.intensity AS intensity,
       d.visual_elements AS visual_components,
       skills_developed,
       player_count AS total_players,
       court_count AS available_courts,
       players_per_court AS players_per_court,
       CASE configuration.type
         WHEN 'optimal' THEN configuration.config.formation
         ELSE configuration.config.formation
       END AS recommended_formation,
       CASE configuration.type
         WHEN 'optimal' THEN configuration.config.rotation_pattern
         ELSE configuration.config.rotation_pattern
       END AS rotation_pattern,
       CASE 
         WHEN configuration.type = 'contingency' 
         THEN configuration.config.specialized_role
         ELSE null
       END AS specialized_role_needed,
       CASE 
         WHEN configuration.config.player_count = 4 
         THEN "Focus on gameplay with constraints rather than drill rotations"
         ELSE "Standard drill implementation with appropriate rotations"
       END AS implementation_notes
ORDER BY configuration_score DESC, d.intensity;

// Generate a practice plan with coach participation when needed
// Useful for: Handling odd-numbered player groups
MATCH (tg:TrainingGroup {name: $groupName})
MATCH (a:Athlete)-[:MEMBER_OF]->(tg)
WITH count(a) AS player_count
MATCH (c:Coach {name: $coachName})
WHERE c.can_participate = true
WITH player_count, c,
     player_count % 2 = 1 AS odd_player_count,
     CASE 
       WHEN player_count = 3 THEN true  // Definitely need coach for 3 players
       WHEN player_count % 2 = 1 THEN true  // Might need coach for other odd numbers
       ELSE false
     END AS coach_should_participate

// If coach participates, adjust effective player count
WITH player_count, c, odd_player_count, coach_should_participate,
     CASE 
       WHEN coach_should_participate THEN player_count + 1
       ELSE player_count
     END AS effective_player_count

MATCH (cc:CourtCapacity)
WITH player_count, effective_player_count, c, odd_player_count, coach_should_participate, cc,
     ceil(effective_player_count / $available_courts) AS players_per_court
WHERE players_per_court <= cc.maximum_players_per_court

// Find appropriate configuration
OPTIONAL MATCH (cc)-[optimal:OPTIMAL_CONFIGURATION]->(oc)
WHERE optimal.player_count = CASE
  WHEN players_per_court <= 4 THEN 4
  WHEN players_per_court <= 6 THEN 6
  ELSE 8
END
WITH player_count, effective_player_count, c, odd_player_count, 
     coach_should_participate, players_per_court,
     oc AS configuration

// Find drills appropriate for the configuration and player count
MATCH (d:Drill)
WHERE d.team_structure = "2v2"  // Always enforce 2v2 structure
AND CASE 
    WHEN players_per_court = 4 THEN d.allows_gameplay_focus = true
    ELSE true
END

// Get skills developed
MATCH (d)-[:DEVELOPS]->(s:Skill)
RETURN d.name AS drill_name,
       d.description AS description,
       d.duration AS duration,
       d.intensity AS intensity,
       collect(DISTINCT s.name) AS skills_developed,
       player_count AS athlete_count,
       effective_player_count AS total_participants,
       coach_should_participate,
       CASE 
         WHEN coach_should_participate AND player_count = 3
         THEN "Coach plays to create full 2v2"
         WHEN coach_should_participate AND odd_player_count
         THEN "Coach participates to maintain even number for 2v2 structure"
         ELSE "Coach does not need to participate"
       END AS coach_role,
       CASE 
         WHEN players_per_court = 4 
         THEN "Focus on gameplay with constraints rather than drill rotations"
         ELSE "Standard drill implementation with appropriate rotations"
       END AS implementation_notes,
       configuration.formation AS recommended_formation,
       configuration.rotation_pattern AS rotation_pattern
ORDER BY CASE WHEN players_per_court = 4 THEN 1 ELSE 0 END DESC, d.intensity;

// Create a 4-player practice plan focused on constraint-based gameplay
// Useful for: Pure 2v2 practice sessions
MATCH (tg:TrainingGroup {name: $groupName})
MATCH (a:Athlete)-[:MEMBER_OF]->(tg)
WITH count(a) AS player_count
WHERE player_count = 4 OR (player_count = 3 AND $coach_participates = true)
MATCH (gc:GameplayConstraint)
MATCH (d:Drill)
WHERE d.team_structure = "2v2" AND d.allows_gameplay_focus = true
WITH gc, d, collect(gc) AS constraints
MATCH (d)-[:DEVELOPS]->(s:Skill)
RETURN d.name AS drill_name,
       d.description AS description,
       "Focus on gameplay with constraints rather than traditional drills" AS implementation_approach,
       collect(DISTINCT s.name) AS skills_developed,
       [constraint IN constraints | constraint.name + ": " + constraint.description] AS recommended_constraints,
       "Alternate between free play and progressively challenging constraints" AS coaching_strategy,
       "Use natural breaks for feedback, avoid stopping play frequently" AS feedback_approach
ORDER BY d.intensity;

// Validate if a drill maintains 2v2 structure and respects court capacity
// Useful for: Checking drill compatibility with beach volleyball format
MATCH (d:Drill {name: $drillName})
OPTIONAL MATCH (d)-[rc:REQUIRES_COURT_CAPACITY]->(cc:CourtCapacity)
RETURN d.name AS drill_name,
       d.team_structure = "2v2" AS maintains_2v2_structure,
       CASE 
         WHEN d.team_structure <> "2v2" THEN "Drill does not maintain 2v2 structure"
         ELSE "Drill maintains proper 2v2 structure"
       END AS structure_validation,
       rc.optimal_players AS optimal_player_count,
       rc.maximum_players AS maximum_player_count,
       rc.adapts_to_odd_count AS supports_odd_numbers,
       CASE
         WHEN rc IS NULL THEN "Missing court capacity requirements"
         WHEN rc.maximum_players > 8 THEN "Exceeds maximum court capacity of 8 players"
         ELSE "Court capacity requirements are valid"
       END AS capacity_validation,
       d.allows_gameplay_focus AS suitable_for_pure_gameplay,
       CASE 
         WHEN d.allows_gameplay_focus = true AND rc.optimal_players = 4
         THEN "Ideal for 4-player constraint-based gameplay"
         ELSE "Standard drill format with rotations"
       END AS usage_recommendation;