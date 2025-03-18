# User Entities

This document defines the user-related entity types in the BeachBook knowledge graph.

## Person:Athlete

Individual who participates in beach volleyball training and competition.

**Properties:**
- `id`: Unique identifier
- `name`: Athlete's name
- `level`: Skill level (beginner, intermediate, advanced, elite)
- `preferences`: UI and notification preferences
- `position`: Volleyball position specialization
- `learning_style`: Preferred learning approach (visual, verbal, physical, etc.)

**Usage Context:**
Primary user of the system who creates reflections, sets goals, and tracks progress.

## Person:Coach

Instructor or mentor who provides guidance and feedback.

**Properties:**
- `id`: Unique identifier
- `name`: Coach's name
- `specialties`: Areas of coaching expertise
- `philosophy`: Coaching approach and values
- `certification_level`: Professional certifications
- `can_participate`: Whether coach can join as athlete
- `playing_level`: Coach's playing ability (beginner, intermediate, advanced, elite)
- `playing_specialization`: Coach's preferred position
- `participation_availability`: When coach is willing to participate
- `participation_constraints`: Limitations on coach's playing role

**Usage Context:**
Creates practice plans, provides feedback, and views athlete-shared content. May participate as athlete when needed for numbers or demonstration.

## Person:Trainer

Strength and conditioning specialist focused on physical development.

**Properties:**
- `id`: Unique identifier
- `name`: Trainer's name
- `specialties`: Areas of physical training expertise
- `certifications`: Professional qualifications
- `focus_areas`: Primary training methodologies

**Usage Context:**
Designs workouts, monitors physical development, and coordinates with coaches.

## Person:ParentGuardian

Oversight role for youth athletes.

**Properties:**
- `id`: Unique identifier
- `name`: Parent/guardian's name
- `athletes_supervised`: Links to supervised athletes
- `notification_preferences`: Communication settings

**Usage Context:**
Receives updates on athlete activities and provides permissions for minors.

## Team

Group of athletes who practice and compete together.

**Properties:**
- `name`: Team name
- `level`: Competitive level
- `focus`: Team's current development priorities
- `season_status`: Current point in competitive season
- `formation`: Team composition and structure

**Usage Context:**
Organizes athletes and provides context for team-wide insights.

## Person:Administrator

System management role with elevated permissions.

**Properties:**
- `id`: Unique identifier
- `name`: Administrator's name
- `permissions_level`: Access control tier
- `responsibilities`: System areas managed

**Usage Context:**
Manages system settings, user accounts, and content moderation.

## Person:Analyst

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
- `role`: How they participate (athlete, server, observer)
- `rotation_pattern`: How they cycle through activities
- `active_time_percentage`: Portion of practice actively participating
- `focus_elements`: Specific areas to concentrate on

**Usage Context:**
Defines participation pattern for coaches, athletes, and guests in practice.