// BeachBook Practice Plan Generation Queries
// These queries support the automated practice plan creation features

// Generate a practice plan for a specific skill focus
// Useful for: Creating targeted practice sessions for specific skills
MATCH (s:Skill {name: $skillName})
MATCH (d:Drill)-[:DEVELOPS]->(s)
OPTIONAL MATCH (d)-[:REQUIRES]->(e:Equipment)
OPTIONAL MATCH (d)-[:PRECEDES]->(next_drill:Drill)
RETURN d.name AS drill_name,
       d.description AS description,
       d.duration AS duration,
       d.intensity AS intensity,
       d.focus_area AS focus,
       d.visual_elements AS visual_components,
       collect(DISTINCT e.name) AS equipment_needed,
       collect(DISTINCT next_drill.name) AS suggested_next_drills
ORDER BY d.intensity, d.duration;

// Create a progressive practice plan based on visual-motor framework
// Useful for: Building vision-focused practice sessions
MATCH (f:Framework {name: 'Visual-Motor Integration'})
MATCH (d:Drill)-[:ALIGNS_WITH]->(f)
WITH d
ORDER BY d.intensity
WITH collect(d) AS drills
UNWIND drills AS drill
OPTIONAL MATCH (drill)-[:REQUIRES]->(e:Equipment)
OPTIONAL MATCH (drill)-[:DEVELOPS]->(s:Skill)
WITH drill, collect(DISTINCT e.name) AS equipment, collect(DISTINCT s.name) AS skills
RETURN drill.name AS drill_name,
       drill.description AS description,
       drill.duration AS duration,
       drill.intensity AS intensity,
       drill.visual_elements AS visual_focus,
       skills,
       equipment
ORDER BY drill.intensity;

// Generate a personalized practice plan for a specific athlete
// Useful for: Addressing individual skill gaps
MATCH (a:Person:Athlete {name: $athleteName})
MATCH (a)-[assessed:SELF_ASSESSED]->(s:Skill)
WHERE assessed.rating < 7
WITH a, s, assessed ORDER BY assessed.rating LIMIT 3
MATCH (d:Drill)-[:DEVELOPS]->(s)
WHERE NOT EXISTS {
  MATCH (a)-[executed:EXECUTED]->(d)
  WHERE datetime() - executed.timestamp < duration('P14D')
}
WITH a, s, d, assessed
ORDER BY assessed.rating, d.intensity
WITH a, collect({skill: s, drills: collect(DISTINCT d)}) AS skill_drills
UNWIND skill_drills AS skill_drill
WITH a, skill_drill.skill AS skill, skill_drill.drills AS drills
WITH a, skill, drills[0..2] AS selected_drills
UNWIND selected_drills AS drill
OPTIONAL MATCH (drill)-[:REQUIRES]->(e:Equipment)
RETURN skill.name AS focus_skill,
       drill.name AS drill_name,
       drill.description AS description,
       drill.duration AS recommended_duration,
       drill.intensity AS intensity,
       collect(DISTINCT e.name) AS equipment_needed;

// Create a team practice plan based on common skill gaps
// Useful for: Group training sessions
MATCH (tg:TrainingGroup {name: $groupName})
MATCH (a:Person:Athlete)-[:MEMBER_OF]->(tg)
MATCH (a)-[assessed:SELF_ASSESSED]->(s:Skill)
WITH tg, s, avg(assessed.rating) AS avg_rating, count(a) AS athlete_count
WHERE avg_rating < 7 AND athlete_count > 3
WITH tg, s ORDER BY avg_rating LIMIT 3
MATCH (d:Drill)-[:DEVELOPS]->(s)
WITH tg, s, d, count(d) AS drill_count
ORDER BY drill_count DESC
WITH tg, s, collect(d)[0..2] AS top_drills
UNWIND top_drills AS drill
OPTIONAL MATCH (drill)-[:PRECEDES]->(next_drill:Drill)
OPTIONAL MATCH (drill)-[:REQUIRES]->(e:Equipment)
RETURN s.name AS focus_skill,
       drill.name AS drill_name,
       drill.description AS description,
       drill.duration AS duration,
       drill.intensity AS intensity,
       collect(DISTINCT e.name) AS equipment_needed,
       collect(DISTINCT next_drill.name) AS progression_options;

// Generate a practice plan with visual-motor progression
// Useful for: Visual skill development sessions
MATCH (f:Framework {name: 'Visual-Motor Integration'})
MATCH (d:Drill)-[:ALIGNS_WITH]->(f)
WHERE d.visual_elements IS NOT NULL
WITH d
ORDER BY d.intensity
WITH collect(d) AS all_drills
WITH all_drills,
     [drill IN all_drills WHERE drill.intensity = 'low'] AS warm_up_drills,
     [drill IN all_drills WHERE drill.intensity = 'medium'] AS main_drills,
     [drill IN all_drills WHERE drill.intensity = 'high'] AS challenge_drills
WITH warm_up_drills[0..1] AS warm_up,
     main_drills[0..3] AS main_section,
     challenge_drills[0..1] AS challenge
WITH warm_up + main_section + challenge AS practice_sequence
UNWIND practice_sequence AS drill
OPTIONAL MATCH (drill)-[:DEVELOPS]->(s:Skill)
OPTIONAL MATCH (drill)-[:REQUIRES]->(e:Equipment)
RETURN drill.name AS drill_name,
       drill.description AS description,
       drill.duration AS duration,
       drill.intensity AS section,
       drill.visual_elements AS visual_focus,
       collect(DISTINCT s.name) AS skills_developed,
       collect(DISTINCT e.name) AS equipment_needed
ORDER BY CASE drill.intensity 
         WHEN 'low' THEN 1 
         WHEN 'medium' THEN 2 
         WHEN 'high' THEN 3 
         ELSE 4 END;

// Generate a practice plan with specific equipment constraints
// Useful for: Practices with limited equipment
MATCH (e:Equipment)
WHERE e.name IN $availableEquipment
MATCH (d:Drill)-[:REQUIRES]->(e)
WITH d, collect(DISTINCT e.name) AS used_equipment
WHERE ALL(eq IN d.equipment_needed WHERE eq IN used_equipment)
MATCH (d)-[:DEVELOPS]->(s:Skill)
WITH d, collect(DISTINCT s.name) AS skills
RETURN d.name AS drill_name,
       d.description AS description,
       d.duration AS duration,
       d.intensity AS intensity,
       skills,
       d.equipment_needed
ORDER BY d.intensity, d.duration;

// Create a practice plan that builds on previous session
// Useful for: Continuous development
MATCH (a:Person:Athlete {name: $athleteName})
MATCH (a)-[executed:EXECUTED]->(d:Drill)
WHERE datetime() - executed.timestamp < duration('P7D')
WITH a, executed, d
ORDER BY executed.timestamp DESC
LIMIT 5
MATCH (d)-[:DEVELOPS]->(s:Skill)
MATCH (next_drill:Drill)-[:DEVELOPS]->(s)
WHERE NOT (a)-[:EXECUTED]->(next_drill)
   OR ((a)-[prev_exec:EXECUTED]->(next_drill) AND prev_exec.timestamp < executed.timestamp)
WITH DISTINCT next_drill, s, 
     CASE WHEN next_drill.intensity = 'low' THEN 1
          WHEN next_drill.intensity = 'medium' THEN 2
          WHEN next_drill.intensity = 'high' THEN 3
          ELSE 4 END AS intensity_order
ORDER BY intensity_order
WITH collect({drill: next_drill, skill: s}) AS progression_options
UNWIND progression_options AS option
WITH DISTINCT option.drill AS drill, collect(DISTINCT option.skill.name) AS skills
OPTIONAL MATCH (drill)-[:REQUIRES]->(e:Equipment)
RETURN drill.name AS drill_name,
       drill.description AS description,
       drill.duration AS duration,
       drill.intensity AS intensity,
       skills,
       collect(DISTINCT e.name) AS equipment_needed
LIMIT 7;