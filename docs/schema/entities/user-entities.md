# User Entities

This document defines the user-related entity types in the BeachBook knowledge graph.

## Player

Individual athlete/user of the platform.

**Properties:**
- `id`: Unique identifier
- `name`: Player's name
- `level`: Skill level (beginner, intermediate, advanced, elite)
- `preferences`: UI and notification preferences
- `position`: Volleyball position specialization
- `learning_style`: Preferred learning approach (visual, verbal, physical, etc.)

**Usage Context:**
Primary user of the system who creates reflections, sets goals, and tracks progress.

## Coach

Instructor or mentor who provides guidance and feedback.

**Properties:**
- `id`: Unique identifier
- `name`: Coach's name
- `specialties`: Areas of coaching expertise
- `philosophy`: Coaching approach and values
- `certification_level`: Professional certifications
- `can_participate`: Whether coach can join as player
- `playing_level`: Coach's playing ability (beginner, intermediate, advanced, elite)
- `playing_specialization`: Coach's preferred position
- `participation_availability`: When coach is willing to participate
- `participation_constraints`: Limitations on coach's playing role

**Usage Context:**
Creates practice plans, provides feedback, and views player-shared content. May participate as player when needed for numbers or demonstration.

## Trainer

Strength and conditioning specialist focused on physical development.

**Properties:**
- `id`: Unique identifier
- `name`: Trainer's name
- `specialties`: Areas of physical training expertise
- `certifications`: Professional qualifications
- `focus_areas`: Primary training methodologies

**Usage Context:**
Designs workouts, monitors physical development, and coordinates with coaches.

## ParentGuardian

Oversight role for youth players.

**Properties:**
- `id`: Unique identifier
- `name`: Parent/guardian's name
- `players_supervised`: Links to supervised players
- `notification_preferences`: Communication settings

**Usage Context:**
Receives updates on player activities and provides permissions for minors.

## Team

Group of players who practice and compete together.

**Properties:**
- `name`: Team name
- `level`: Competitive level
- `focus`: Team's current development priorities
- `season_status`: Current point in competitive season
- `formation`: Team composition and structure

**Usage Context:**
Organizes players and provides context for team-wide insights.

## Administrator

System management role with elevated permissions.

**Properties:**
- `id`: Unique identifier
- `name`: Administrator's name
- `permissions_level`: Access control tier
- `responsibilities`: System areas managed

**Usage Context:**
Manages system settings, user accounts, and content moderation.

## Analyst

Performance evaluation specialist.

**Properties:**
- `id`: Unique identifier
- `name`: Analyst's name
- `specialization`: Analysis focus areas
- `data_access_level`: Scope of accessible data

**Usage Context:**
Performs advanced data analysis and provides performance insights.

## PracticeParticipant

Role that a person takes in a practice session.

**Properties:**
- `role`: How they participate (player, server, observer)
- `rotation_pattern`: How they cycle through activities
- `active_time_percentage`: Portion of practice actively participating
- `focus_elements`: Specific areas to concentrate on

**Usage Context:**
Defines participation pattern for coaches, players, and guests in practice.