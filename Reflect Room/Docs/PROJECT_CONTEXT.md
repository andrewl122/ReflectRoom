# Reflect Room — Project Context

## Overview

Reflect Room is an emotionally focused iOS journaling and self-reflection application built using SwiftUI and Core Data.

The app is designed to encourage mindfulness, emotional awareness, and healthy reflection habits through:
- mood tracking
- guided reflection
- journaling
- emotional insights
- streak systems
- prompts and reminders

The app prioritizes emotional UX, calm visual design, and long-term habit formation.

---

# Current Development Priorities

1. Architecture stabilization
2. MoodType consistency across the app
3. Incremental refactoring
4. Performance optimization
5. Media cleanup and storage integrity
6. Improved state management
7. Reusable UI component extraction

---

# Product Philosophy

Reflect Room should feel:
- calm
- emotionally safe
- reflective
- premium
- minimal
- warm and intelligent

The experience should avoid overwhelming the user and instead encourage intentional self-reflection.

---

# Engineering Philosophy

- Refactor incrementally
- Avoid large rewrites
- Preserve working features
- Keep architecture scalable but lightweight
- Prefer maintainable solutions over overengineering
- Reuse components whenever possible
- Prioritize readability and emotional UX consistency

---

# Architecture Direction

The app is gradually transitioning toward:
- lightweight MVVM
- centralized domain models
- reusable services
- improved state management
- better file organization
- scalable analytics handling

The project intentionally avoids heavy enterprise architecture patterns unless necessary.

---

# Important Technical Goals

- Centralize mood handling using MoodType
- Reduce duplicated logic
- Improve delete-side media cleanup
- Keep SwiftUI views modular
- Minimize force unwraps
- Improve analytics performance
- Reduce oversized SwiftUI files

---

# Important Notes For AI Assistance

- Do not rewrite the entire app
- Preserve existing UX flows unless instructed otherwise
- Prefer incremental improvements
- Keep changes localized when possible
- Avoid unnecessary architectural complexity
- Prioritize stability and maintainability
