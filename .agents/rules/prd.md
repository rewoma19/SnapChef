---
trigger: always_on
---

1. Product Overview

SnapChef is an AI-powered mobile app that transforms a user’s fridge photo into instantly cookable recipes.
Users snap a picture → the app detects ingredients → generates illustrated recipes → and lets users share aesthetic, viral-ready recipe cards.

A friendly mascot accompanies the user, leveling up as they explore recipes and cook more often.

The app solves:

“I don’t know what to cook.”

“I want something quick using what I already have.”

“I want aesthetic content to share.”

2. Core Value Proposition

SnapChef makes cooking effortless, fun, and social:

Snap → Detect → Cook

AI turns random ingredients into real dishes

Recipes include unique illustrated images, not stock photos

Viral share templates for IG/TikTok

A cooking mascot that evolves with usage

Cloud-synced recipes across devices via iCloud

No account needed

3. Target Users
🧑‍🎓 Students

Cheap, fast meals using leftovers.

🏋️ Fitness & Health Users

Want high-protein or low-calorie ideas instantly.

🧑‍🍳 Busy Workers

Don’t want to think about “what to cook tonight?”

♻️ Zero-Waste Users

Want to use everything in their fridge.

4. Personas
1. The Budget Cook

Wants cheap meals, minimal ingredients, clear steps.

2. The Content Creator

Wants aesthetic shareable recipe cards.

3. The Health Tracker

Wants protein-forward or macro-friendly meals.

4. The Casual Home Cook

Wants inspiration with minimal effort.

5. User Stories
Core V1 User Stories

As a user, I want to take a photo of my fridge or ingredients, so the app can detect what I have.

As a user, I want AI-generated recipes based on my ingredients.

As a user, I want my recipe to include a cute illustrated image that makes it feel fun.

As a user, I want a shareable recipe card I can post on IG/TikTok.

As a user, I want to save recipes and access them across devices via iCloud.

As a user, I want a mascot that reacts to my activity (cooking streak, exploring recipes).

Optional V1 Stories (If time permits)

As a user, I want to filter recipes by diet (vegan, halal, high protein).

As a user, I want the mascot to have multiple evolution states.

6. Feature Set (V1)
⭐️ 1. Ingredient Recognition (Photo Scan)

Camera or photo picker input

Image sent to vision API

Returns list of detected ingredients

User can edit list (add/remove items)

⭐️ 2. AI Recipe Generation

LLM receives ingredient list + optional diet preferences

Returns:

Title

Ingredients

Steps

Time

Difficulty

Description (for share card text and illustrated image prompt)

⭐️ 3. Illustrated Recipe Image

Each recipe includes a soft, cozy illustration-style image generated using prompts such as:

“Flat illustrated style, soft colors, minimal line art, a cozy dish of eggs and spinach.”

This becomes the recipe’s hero image and is used in share cards.

⭐️ 4. Viral Share Templates (9:16)

3 initial template types:

Template A – Minimal Classic

Big title

Illustrated dish image

“Ingredients found” section

Time + Difficulty

Template B – Sticky Note

Handwritten styled steps

Mascot peeking from corner

Template C – Before → After

Mini fridge illustration → Recipe illustration

“Turn this → into this” aesthetic

Export:

SwiftUI → UIImage → share sheet

Watermark: “Made with SnapChef”

⭐️ 5. Mascot System (V1)

A cute cooking-themed mascot that:

Starts at Level 1

Levels up based on:

Recipes viewed

Recipes saved

Share cards exported

Mascot appears:

On home screen

On share templates

In empty states (“Let’s cook something!”)

3 evolution stages for V1:

Baby Chef

Apprentice Chef

Master Chef


⭐️ 6. Save Recipes (SwiftData + CloudKit)

All saved recipes sync via iCloud:

Saved recipes

Favorite tags

Generated illustrations

Mascot level

User settings (diet, template style)

No manual login needed.

7. Non-Functional Requirements
Performance

Ingredient detection < 2s

Recipe generation < 3–4s

Illustration generation < 4s (or fallback to templates)

Reliability

Offline mode shows saved recipes

Scan requires connection

Privacy

Photos processed only for detection

Not stored on server

Recipe data stored in user’s iCloud

Scalability

Add more templates, mascots, nutrition features later

8. Data Model (SwiftData)

@Model
class Recipe {
    @Attribute(.unique) var id: UUID
    var name: String
    var ingredients: [String]
    var steps: [String]
    var time: String
    var difficulty: String
    var createdAt: Date
    var imageURL: String?          // illustration
    var templateStyle: String?     // default share style
    var mascotBoost: Int           // xp to reward mascot
}

@Model
class UserSettings {
    var dietPreference: String?
    var mascotLevel: Int
    var preferredTemplate: String
}

@Model
class IngredientScan {
    var date: Date
    var ingredients: [String]
}

9. Core Flows (V1)
Flow 1 — Scan → Recipe

User taps “Scan Fridge”

Takes photo

Vision API returns ingredients

User confirms/edit ingredients

LLM generates recipes

Illustrated image generated

Recipe detail shown

Flow 2 — Save & Sync

User taps “Save Recipe”

Recipe persisted in SwiftData

CloudKit syncs automatically across devices

Flow 3 — Share Template

User opens recipe

Taps “Share Card”

Chooses template style

SwiftUI renders 9:16 artwork

Exports to Photos or share sheet

Mascot appears in at least one template.

Flow 4 — Mascot Level Up

User performs key action (scan, save, share)

Add XP (1–5 points)

Check level thresholds

Animation: Mascot evolves

10. Success Metrics
Engagement

3+ uses per week

3+ share cards per user per month

Retention

Mascot system increases 7-day return rate

Saved recipes sync encourages re-use

Viral Growth

20% of recipes exported as share cards

Watermark visibility on IG/TikTok clips

11. Differentiators
✔ Illustrated Recipes (unique aesthetic)
✔ Viral share templates baked into V1
✔ Mascots that level up as you cook
✔ Fast, on-device feeling (thanks to SwiftUI + CloudKit)
✔ Instant “what can I cook with this?” solving