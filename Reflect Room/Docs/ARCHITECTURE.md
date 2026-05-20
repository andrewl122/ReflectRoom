# Reflect Room — Architecture

# Current Architecture

Reflect Room currently uses:
- SwiftUI
- Core Data
- AVKit
- Combine
- Local file storage for media

The application follows a feature-driven SwiftUI architecture with direct Core Data integration.

---

# Core Systems

## Reflection System
Users can create:
- text reflections
- audio reflections
- video reflections

Entries are stored in Core Data while media files are persisted locally in the Documents directory.

---

# Mood System

The app uses a centralized MoodType system to manage:
- mood display
- analytics
- prompts
- notifications
- charts
- emotional insights

MoodType serves as the primary emotional domain model.

---

# Data Layer

Core Data manages:
- reflections
- timestamps
- moods
- tags
- media references

Media assets are stored separately on disk and referenced by file path.

---

# Analytics System

Reflection analytics currently support:
- streak tracking
- mood trends
- emotional frequency analysis
- weekly comparisons
- insight summaries

Analytics logic is gradually being centralized for scalability and maintainability.

---

# Navigation Structure

Primary app flow:

HomeView
→ CheckInView
→ Reflection Save
→ TimelineView
→ ReflectionDetailView
→ MoodInsightsView

The app currently uses:
- NavigationStack
- sheets
- custom tab navigation

---

# UI System

The app uses:
- AppTheme
- reusable modifiers
- shared backgrounds
- custom tab components
- animated gradients

The visual philosophy focuses on:
- emotional calmness
- readability
- warmth
- minimalism

---

# Current Technical Priorities

- Reduce oversized SwiftUI views
- Improve state management
- Extract reusable components
- Improve data consistency
- Optimize analytics performance
- Improve media cleanup handling

---

# Planned Architecture Improvements

- Lightweight MVVM
- Repository layer
- Improved dependency management
- Better folder organization
- More testable services
- Background save operations
