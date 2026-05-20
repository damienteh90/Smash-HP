# Smash HP MVP Implementation Plan - COMPLETED

## Overview
This document outlines the completed MVP implementation for the Smash HP battle damage tracker Flutter app.

## Architecture & Structure

### Data Models (lib/models/)

#### PlayerProfile (`player_profile.dart`)
- Fields: playerName, avatarId, maxHp, baseDamageReceived, criticalHitChance, criticalDamageMultiplier, healAmount, missChance
- Includes JSON serialization/deserialization
- Supports copyWith for immutable updates

#### BattleSession (`battle_session.dart`)
- Fields: currentHp, maxHp, roundNumber, battleLog, undoStack, isKo, createdAt, updatedAt
- BattleLogEntry for logging attack results
- Factory method for initial session creation
- Immutable with copyWith pattern

### Services (lib/services/)

#### LocalStorageService (`local_storage_service.dart`)
- Uses SharedPreferences for persistence
- Methods:
  - `initialize()` - must be called at app startup
  - `getPlayerProfile()` / `savePlayerProfile()`
  - `getActiveBattleSession()` / `saveActiveBattleSession()` / `clearActiveBattleSession()`
- Thread-safe singleton instance exported as `localStorage`

#### BattleLogic (`battle_logic.dart`)
- Static methods for all game logic:
  - `calculateAttack()` - implements miss/crit calculations
  - `applyAttack()` - applies damage and updates session
  - `undo()` - unlimited undo with HP/log restoration
  - `newRound()` - resets for next round

### Screens (lib/screens/)

#### SplashScreen
- 3-second duration before navigation
- Simple branding display
- Auto-navigates to HomeScreen

#### HomeScreen
- Shows saved player profile card (if exists)
- Two buttons: "Player Setup" and "Start Battle"
- Clears active battle on entry (prevents session resume corruption)
- Prevents back navigation (WillPopScope alternative: PopScope)

#### PlayerSetupScreen
- Single player profile editor with form validation
- Sliders for all stat configuration:
  - Avatar ID (1-10)
  - Max HP (50-300)
  - Base Damage (1-50)
  - Critical Hit Chance (0-100%)
  - Critical Damage Multiplier (1.0x-3.0x)
  - Heal Amount (0-50)
  - Miss Chance (0-100%)
- Saves profile and creates initial BattleSession
- Overwrites single saved profile on save

#### BattleScreen
- Displays player info and current battle state
- HP bar with color coding (green/yellow/red)
- Large "ATTACK ME" button for taking damage
- Undo button (disabled if no undo history)
- New Round button
- Leave Battle button
- Collapsible battle log showing attack history
- Handles KO transitions
- Session auto-saves after each action

#### KoScreen
- Shows KO message with icon
- Two options:
  - "New Round" - increments round, restores HP, clears log
  - "Back to Home" - clears session and returns

### Widgets (lib/widgets/)

#### PrimaryActionButton
- Full-width filled button for primary actions
- Standard appearance

#### HpBar
- Displays current/max HP with visual bar
- Color coding: green (>50%), yellow (25-50%), red (<25%)

## Game Logic Implementation

### Attack Calculation (BattleLogic.calculateAttack)
1. Roll for miss (based on missChance %)
   - If miss: return damage 0, message "Miss!"
2. Roll for critical hit (based on criticalHitChance %)
   - If critical: damage = baseDamage * criticalMultiplier
   - If normal: damage = baseDamage
3. Calculate new HP (never goes below 0)
4. Return: (newHp, logMessage, damage, wasMiss, wasCritical)

### Undo System
- Stores HP values in undoStack before each attack
- Each undo restores previous HP and removes latest log entry
- Unlimited undo depth
- Undo button disabled when stack is empty

### Session Management
- BattleSession saved to storage after every action
- Session restored on app reopen (resume functionality)
- Cleared when leaving battle back to home
- New session created for each PlayerSetupScreen → BattleScreen flow

## Storage Implementation
- **Library**: SharedPreferences
- **Keys**:
  - `player_profile`: Stores single player profile JSON
  - `active_battle_session`: Stores current battle session JSON
- **Initialization**: Called in main() before runApp()
- **Format**: JSON strings with full serialization support

## Navigation Flow
1. Splash (3s) → Home
2. Home + no profile → Player Setup
3. Home + profile exists → Battle (or Player Setup)
4. Player Setup → Battle (new session)
5. Battle → KO (on HP ≤ 0)
6. Battle → Home (Leave Battle)
7. KO → Battle (New Round)
8. KO → Home (Back to Home)

## Build & Run
```bash
cd smash_hp
flutter pub get
flutter run
```

## Dependencies
- flutter (SDK)
- shared_preferences: ^2.2.2

## Features Implemented ✓
- [x] Portrait only orientation
- [x] Offline/local only (no backend)
- [x] No login/authentication
- [x] One saved player profile only
- [x] Splash screen with 3-second duration
- [x] Home screen without stats
- [x] Player setup form
- [x] Battle screen with HP tracking
- [x] Collapsible battle log
- [x] Unlimited undo system
- [x] Session resume on app reopen
- [x] KO screen with new round option
- [x] Leave battle returns to home
- [x] Round count continues
- [x] Clean beginner-friendly code structure
- [x] No extra features (no multiplayer, shop, ads, etc.)
- [x] Logic-first implementation (UI not polished)

## Notes
- UI is functional but not pixel-perfect (as requested)
- All game logic is properly abstracted in BattleLogic service
- Code follows Flutter best practices and clean architecture
- Ready for UI refinement in future phases
