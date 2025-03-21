// BeachBook Athlete Growth Queries
// These queries support the athlete development use cases

// Find skills with the greatest gap between athlete self-assessment and coach assessment
// Useful for: Identifying key growth opportunities and blind spots
MATCH (a:Person:Athlete {name: $athleteName})-[self:SELF_ASSESSED]->(s:Skill),
      (c:Person:Coach)-[coach:COACH_ASSESSED]->(s)<-[:PRACTICED]-(a)
WHERE abs(self.rating - coach.rating) > 2
RETURN s.name, self.rating, coach.rating, 
       abs(self.rating - coach.rating) AS gap,
       CASE WHEN self.rating > coach.rating THEN 'overestimation'
            ELSE 'underestimation' END AS gap_type
ORDER BY gap DESC
LIMIT 5;

// Track how athlete self-assessment accuracy improves over time
// Useful for: Measuring growth in self-awareness
MATCH (a:Person:Athlete {name: $athleteName})-[self:SELF_ASSESSED]->(s:Skill)
MATCH (c:Person:Coach)-[coach:COACH_ASSESSED]->(s)<-[:PRACTICED]-(a)
WHERE self.timestamp < coach.timestamp + duration('P1D')
  AND self.timestamp > coach.timestamp - duration('P1D')
WITH a, s, self.timestamp.year as year, self.timestamp.month as month,
     abs(self.rating - coach.rating) AS accuracy_gap
RETURN year, month, avg(accuracy_gap) AS avg_gap
ORDER BY year, month;

// Find which drills have most improved skills with high assessment gaps
// Useful for: Creating targeted practice plans for growth areas
MATCH (a:Person:Athlete {name: $athleteName})-[gap:ASSESSMENT_GAP]->(c:Person:Coach)
MATCH (s:Skill {name: gap.skill_id})
MATCH (a)-[practiced:PRACTICED]->(s)
MATCH (a)-[executed:EXECUTED]->(d:Drill)
MATCH (d)-[:DEVELOPS]->(s)
WHERE practiced.timestamp > executed.timestamp
  AND practiced.quality_rating > practiced.previous_quality_rating
RETURN d.name, gap.gap_value, 
       practiced.quality_rating - practiced.previous_quality_rating AS improvement,
       executed.timestamp
ORDER BY improvement DESC
LIMIT 5;

// Identify skills that would benefit from visual training focus
// Useful for: Integrating visual-motor training into practice plans
MATCH (a:Person:Athlete {name: $athleteName})-[self:SELF_ASSESSED]->(s:Skill)
WHERE s.visualRequirements IS NOT NULL
  AND self.rating < 7
MATCH (d:Drill)-[:DEVELOPS]->(s)
WHERE d.visual_elements IS NOT NULL
RETURN s.name, s.visualRequirements, self.rating, 
       collect(DISTINCT d.name) AS recommended_drills,
       collect(DISTINCT d.visual_elements) AS visual_focus_areas
ORDER BY self.rating;

// Track visual skill development progress over time
// Useful for: Assessing progress in visual-motor integration
MATCH (a:Person:Athlete {name: $athleteName})-[practiced:PRACTICED]->(s:Skill)
WHERE s.visualRequirements IS NOT NULL
WITH a, s, practiced
ORDER BY practiced.timestamp
WITH a, s, collect(practiced) AS practice_sessions
UNWIND practice_sessions AS session
WITH a, s, session.timestamp AS date, session.quality_rating AS rating
WITH a, s, date, rating
ORDER BY date
WITH a, s, collect({date: date, rating: rating}) AS progression
RETURN s.name, s.visualRequirements,
       progression[0].rating AS initial_rating,
       progression[-1].rating AS current_rating,
       progression[-1].rating - progression[0].rating AS improvement,
       size(progression) AS practice_count
ORDER BY improvement DESC;

// Recommend drills based on skill gaps and visual training needs
// Useful for: Creating personalized practice plans
MATCH (a:Person:Athlete {name: $athleteName})-[self:SELF_ASSESSED]->(s:Skill)
WHERE self.rating < 7
WITH a, s
MATCH (d:Drill)-[:DEVELOPS]->(s)
WHERE NOT (a)-[:EXECUTED]->(d)
  OR (a)-[:EXECUTED]->(d) AND (
    // Not practiced recently (over 30 days)
    (a)-[exec:EXECUTED]->(d) WHERE datetime() - exec.timestamp > duration('P30D')
  )
WITH a, s, d, 
     CASE WHEN s.visualRequirements IS NOT NULL AND d.visual_elements IS NOT NULL 
          THEN true ELSE false END AS visual_alignment
RETURN s.name, s.category, self.rating, 
       d.name, d.description, d.focus_area, d.intensity,
       visual_alignment,
       CASE WHEN visual_alignment = true THEN 'High' ELSE 'Medium' END AS recommendation_strength
ORDER BY recommendation_strength DESC, self.rating;

// Find skill dependencies that may be limiting progress
// Useful for: Addressing foundation gaps
MATCH (target:Skill)<-[:PRACTICED]-(a:Person:Athlete {name: $athleteName})
MATCH path = (target)-[:REQUIRES*]->(prereq:Skill)
MATCH (a)-[self_target:SELF_ASSESSED]->(target)
OPTIONAL MATCH (a)-[self_prereq:SELF_ASSESSED]->(prereq)
WITH target, prereq, self_target, self_prereq,
     length(path) AS dependency_distance
WHERE self_target.rating < 7
  AND (self_prereq IS NULL OR self_prereq.rating < 8)
RETURN target.name AS struggling_skill,
       self_target.rating AS current_rating,
       prereq.name AS prerequisite_skill,
       CASE WHEN self_prereq IS NULL THEN 'Not assessed' 
            ELSE toString(self_prereq.rating) END AS prerequisite_rating,
       dependency_distance
ORDER BY self_target.rating, dependency_distance;