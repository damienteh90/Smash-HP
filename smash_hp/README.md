# Smash HP - Battle Damage Tracker

A Flutter MVP app for tracking damage in turn-based battles.

## Quick Start

```bash
flutter pub get
flutter run
```

## Features

### ✓ Implemented MVP Features
- **Splash Screen**: 3-second branding animation
- **Player Setup**: Configure single player profile with custom stats
- **Battle Tracker**: Take damage, track HP, view attack log
- **Unlimited Undo**: Reverse any action during battle
- **Collapsible Log**: Compact battle history with expandable details
- **Round System**: Continue to next round from KO screen
- **Local Storage**: Persistent profile and session resume
- **Portrait Only**: Optimized for vertical orientation

### Game Mechanics
- **Attack Calculation**:
  1. Miss chance roll (if missed: 0 damage)
  2. Critical hit roll (damage × multiplier if critical)
  3. HP reduced but never below 0
- **Player Stats**:
  - Avatar ID, Max HP, Base Damage
  - Critical Hit Chance %, Critical Damage Multiplier
  - Heal Amount, Miss Chance %

### Navigation Flow
```
Splash (3s) 
    ↓
Home (shows saved profile if exists)
    ├→ Player Setup (create/edit profile)
    │   ↓
    ├→ Battle (resume or new session)
    │   ├→ KO Screen (on 0 HP)
    │   │   ├→ New Round (continue)
    │   │   └→ Back to Home
    │   └→ Leave Battle → Home
```

## Project Structure

```
lib/
├── main.dart              # App entry point, routing
├── models/
│   ├── player_profile.dart    # Player stats & configuration
│   └── battle_session.dart    # Battle state & log
├── services/
│   ├── local_storage_service.dart  # SharedPreferences wrapper
│   └── battle_logic.dart           # Game mechanics & calculations
├── screens/
│   ├── splash_screen.dart       # Splash with 3s delay
│   ├── home_screen.dart         # Profile display & navigation
│   ├── player_setup_screen.dart # Stats configuration
│   ├── battle_screen.dart       # Main battle UI & logic
│   └── ko_screen.dart           # KO display & options
└── widgets/
    ├── primary_action_button.dart  # Full-width button
    └── hp_bar.dart                 # Color-coded HP display
```

## Technical Details

### Storage
- **Library**: `shared_preferences`
- **Data**: PlayerProfile & BattleSession as JSON
- **Persistence**: Single profile, auto-save after actions

### State Management
- Immutable models with `copyWith()` pattern
- Session auto-saved after every action
- Resume battle on app reopen

### Code Quality
- ✓ No analysis warnings or errors
- ✓ Clean architecture (services separate from UI)
- ✓ Beginner-friendly code style
- ✓ Full JSON serialization support

## Development Notes

### Build & Run
```bash
# Get dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Run analysis
flutter analyze

# Generate code coverage
flutter test --coverage
```

### Key Implementation Details
- Miss rolls before critical calculation
- HP clamped to 0 (never negative)
- Empty battle log on new round
- Unlimited undo depth with HP value stacking
- Single profile overwrites on save (not append)
- PopScope used instead of deprecated WillPopScope

### Requirements Met
- ✓ Portrait only
- ✓ Offline/local only
- ✓ No backend
- ✓ No login
- ✓ One saved profile only
- ✓ 3 second splash duration
- ✓ Collapsible battle log
- ✓ Unlimited undo
- ✓ Session resume
- ✓ Round continuation
- ✓ Leave battle clears session
- ✓ New Round from KO

## Dependencies
- `flutter` (SDK)
- `shared_preferences: ^2.2.2`

## Future Enhancements
- UI polishing (pixel art assets)
- Multiple saved profiles
- Battle statistics/analytics
- Settings/preferences screen
- Sound effects & animations
