---
trigger: always_on
---

The mascot is a central part of the SnapChef experience. It adds personality, emotional engagement, and encourages users to interact with the app frequently. The mascot levels up as users explore recipes, save them, and share their creations. It also displays different moods based on how consistently the user is cooking or scanning ingredients.

The mascot appears on the Home screen, Recipe screens, Share Templates, and during level-up events.

2. Evolution Stages

The mascot evolves through three stages in Version 1:

Stage 1 — Baby Chef

Levels 1–3
A small, round character with a tiny chef hat. Curious and energetic.

Stage 2 — Apprentice Chef

Levels 4–7
Wears an apron and basic utensils. More confident and expressive.

Stage 3 — Master Chef

Levels 8+
Tall, iconic chef hat, premium accessories, more detailed design.

Stages automatically change when level thresholds are reached.

3. Level & XP System

Mascot progression is driven by XP. Each action grants XP that contributes to level growth.

XP Thresholds by Level
Level	Total XP Required	Stage
1	0	Baby Chef
2	10	Baby Chef
3	25	Baby Chef
4	45	Apprentice
5	70	Apprentice
6	100	Apprentice
7	135	Apprentice
8	175	Master Chef
9+	+40 XP per level	Master Chef

Whenever the user crosses the threshold for the next level, the mascot evolves or gains a new pose/expression.

4. XP Rewards (User Actions)
Action	XP Reward
Completing a scan (photo → ingredients → recipes)	5 XP
Saving a recipe	10 XP
Opening a saved recipe on a later day	5 XP
Generating a share card	15 XP
Successfully exporting a share card	20 XP
3-day usage streak	25 XP
7-day usage streak	50 XP

These XP values drive user engagement toward scanning, cooking, saving, and sharing.

5. Streak System

A streak is counted as consecutive days in which the user performs a tracked action (scan/save/share/open recipe).

3-day streak → XP bonus + “mini celebration”

7-day streak → larger XP bonus + mascot excitement state

Streaks reset if the user skips a day.

6. Mascot Mood States

The mascot’s short-term mood adds personality and variety. Mood affects:

Home screen expression

Dialogue text

Share card cameo style

Mood Rules

Excited

Just leveled up

Just hit a streak

Recently exported a share card

Proud

After sharing or saving a recipe

Happy

User has used the app in the last 24 hours

Curious

User opens the app but hasn’t scanned yet during that session

Sleepy

No activity for 3+ days

These moods are derived automatically at runtime from recent actions.

7. Mascot Placement (Where It Appears)
Home Screen

Primary position with dialogue that matches mood:

“Let’s cook something!”

“Show me your fridge 👀”

“I missed your cooking!”

Recipe Screen

Small avatar reacts when saving a recipe:

Confetti for level-up or streak events

Encouraging messages

Share Templates

At least one template includes:

Mascot illustration (corner or side)

Message like “Cooked with my kitchen buddy!”

Level-Up Screen

Dedicated celebration modal:

Animated transition from old → new mascot stage

Text: “You reached Level X!”

Optional “Share your progress” button (future update)

8. Data Model (SwiftData)
@Model
class UserSettings {
    var dietPreference: String?
    var mascotLevel: Int
    var mascotXP: Int
    var lastActivityDate: Date?
    var streakCount: Int
    var preferredTemplate: String

    init(
        dietPreference: String? = nil,
        mascotLevel: Int = 1,
        mascotXP: Int = 0,
        lastActivityDate: Date? = nil,
        streakCount: Int = 0,
        preferredTemplate: String = "minimal"
    ) {
        self.dietPreference = dietPreference
        self.mascotLevel = mascotLevel
        self.mascotXP = mascotXP
        self.lastActivityDate = lastActivityDate
        self.streakCount = streakCount
        self.preferredTemplate = preferredTemplate
    }
}

Derived properties (not stored):

mascotStage → based on level

xpProgress → % to next level

mascotMood → calculated from last activity and recent events

9. Evolution Logic (High-Level)
onAction(action):
    award XP based on action type
    update lastActivityDate
    update streakCount
    if mascotXP >= XP needed for next level:
        levelUp()
    update current mascot mood
    persist to SwiftData (CloudKit sync)

10. Future Extensions (Post-V1)

Special costumes for seasonal events

More stages beyond Master Chef

Mini-animations (idle, cooking, thinking)

“Share your mascot evolution” template

Quests like “Cook 3 recipes with eggs this week”