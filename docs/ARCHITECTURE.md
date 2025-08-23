# Mood Surge - Architecture Documentation

## Overview

Mood Surge is a Flutter Flame 2D game built using the Very Good CLI brick architecture. The project follows clean architecture principles with clear separation between Flutter app logic and Flame game logic, utilizing BLoC for state management and flame_behaviors for entity composition.

## Architecture Layers

### 1. App Layer (`lib/app/`)
**Responsibility**: Flutter application configuration, routing, and dependency injection.

- **Purpose**: Manages the Flutter app lifecycle and navigation
- **Components**:
  - `app.dart`: Main application widget configuration
  - `view/`: App-level UI components and routing logic
- **Dependencies**: Flutter framework, routing, themes

### 2. Game Layer (`lib/game/`)
**Responsibility**: All Flame game engine logic, entities, and components.

```
lib/game/
├── components/          # Reusable UI and game components
├── cubit/              # Game-specific state management
├── entities/           # Game entities with behavior composition
│   └── [entity_name]/  # Individual entity with behaviors
├── view/               # Game view widgets and overlays
├── game.dart           # Barrel exports
└── mood_surge.dart     # Main game class
```

#### Components (`lib/game/components/`)
- **Purpose**: Reusable game elements (UI, effects, visual components)
- **Pattern**: Extend `PositionComponent` with `HasGameReference<MoodSurge>`
- **Examples**: `CounterComponent`, HUD elements, particle effects

#### Entities (`lib/game/entities/`)
- **Purpose**: Game objects with complex behavior composition
- **Pattern**: Extend `PositionedEntity` from flame_behaviors
- **Structure**: Each entity gets its own directory with behaviors subfolder
- **Examples**: `Unicorn` entity with movement, animation behaviors

#### Behaviors (`lib/game/entities/[entity]/behaviors/`)
- **Purpose**: Composable behavior components for entities
- **Pattern**: Extend appropriate flame_behaviors classes
- **Benefits**: Reusable, testable, single-responsibility components

### 3. Feature Modules
**Responsibility**: Specific app features with their own state and UI.

Examples:
- `lib/loading/`: Loading screen logic and UI
- `lib/title/`: Title screen with menu interactions

Each feature module follows the same pattern:
```
lib/[feature]/
├── cubit/              # Feature-specific state management
├── view/               # Feature UI components
└── [feature].dart      # Barrel exports
```

### 4. Generated Code (`lib/gen/`)
**Responsibility**: Code generation artifacts (assets, localization).

- **Assets**: Generated asset references from `build_runner`
- **Localization**: Generated translation classes
- **Benefits**: Type-safe asset references, compile-time validation

## State Management Architecture

### BLoC Pattern Implementation
The project uses the BLoC pattern with Cubit for simpler cases:

#### Cubit Structure
```dart
// State class with Equatable for value comparison
class GameState extends Equatable {
  const GameState({required this.status});
  final GameStatus status;
  
  GameState copyWith({GameStatus? status}) {
    return GameState(status: status ?? this.status);
  }
  
  @override
  List<Object> get props => [status];
}

// Cubit with business logic
class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState(status: GameStatus.initial));
  
  void startGame() {
    emit(state.copyWith(status: GameStatus.playing));
  }
}
```

#### State Flow
1. **UI Events** → Cubit methods
2. **Business Logic** → State emission
3. **State Changes** → UI updates via BlocBuilder/BlocListener

### Game-Specific State
- **Game State**: Managed by `GameCubit` for overall game status
- **Entity State**: Local state within entities and behaviors
- **Component State**: UI component state (scores, health, etc.)

## Flame Game Architecture

### Game Class (`MoodSurge`)
Central game class extending `FlameGame`:

```dart
class MoodSurge extends FlameGame {
  // Game dependencies injected via constructor
  final AppLocalizations l10n;
  final AudioPlayer effectPlayer;
  final TextStyle textStyle;
  
  @override
  Future<void> onLoad() async {
    // Game initialization
    final world = World(children: [...]);
    final camera = CameraComponent(world: world);
    await addAll([world, camera]);
  }
}
```

### Component Hierarchy
```
MoodSurge (FlameGame)
├── World
│   ├── Entities (PositionedEntity)
│   │   ├── Behaviors
│   │   └── Child Components
│   └── Components (PositionComponent)
└── CameraComponent
    └── Viewport
```

### Entity-Behavior Composition
Using flame_behaviors for flexible entity composition:

```dart
class Player extends PositionedEntity {
  Player({required super.position})
    : super(
        behaviors: [
          MovementBehavior(),
          AnimationBehavior(),
          CollisionBehavior(),
        ],
      );
}
```

**Benefits**:
- **Modularity**: Behaviors can be mixed and matched
- **Reusability**: Behaviors work across different entities
- **Testability**: Each behavior can be tested independently
- **Maintainability**: Clear separation of concerns

## Data Flow Architecture

### App Startup Flow
1. **main_[environment].dart** → `bootstrap()` → `App()`
2. **App** initializes routing and global dependencies
3. **Feature modules** loaded on-demand
4. **Game initialization** with injected dependencies

### Game Loop Flow
1. **Flame Engine** calls `update(dt)` on all components
2. **Entities** update their behaviors
3. **Behaviors** perform their specific logic
4. **State changes** trigger UI updates via BLoC

### Event Flow
```
User Input → Flutter Widget → BLoC Event → State Change → Game Component Update
```

## Dependency Injection

### Constructor Injection
Dependencies injected through constructors:
- Game receives `l10n`, `effectPlayer`, `textStyle`, `images`
- Components receive necessary services via constructor
- Behaviors access game through `HasGameReference` mixin

### Service Locator Pattern
For shared services across the game:
- Audio services
- Asset management
- Configuration services

## Asset Management Architecture

### Generated Assets
Using `build_runner` for type-safe asset references:

```dart
// Generated code
class Assets {
  static const String images = 'assets/images/';
  static const AssetGenImage player = AssetGenImage('assets/images/player.png');
}

// Usage
final sprite = Sprite(game.images.fromCache(Assets.images.player.path));
```

### Asset Loading Strategy
1. **Critical Assets**: Preloaded in game's `onLoad()`
2. **On-Demand Assets**: Loaded when needed
3. **Asset Caching**: Automatic caching via Flame's asset system

## Testing Architecture

### Test Structure
```
test/
├── app/                # App layer tests
├── game/               # Game layer tests
│   ├── components/     # Component tests
│   ├── entities/       # Entity tests
│   └── cubit/          # Game state tests
├── helpers/            # Test utilities
└── [feature]/          # Feature-specific tests
```

### Testing Patterns

#### Unit Tests
- **BLoC Tests**: Using `bloc_test` package
- **Business Logic**: Pure function testing
- **Utility Functions**: Input/output validation

#### Integration Tests
- **Game Tests**: Using `flame_test` package
- **Component Integration**: Multi-component interactions
- **State Integration**: Cross-module state changes

#### Widget Tests
- **Flutter Widgets**: Using `flutter_test`
- **Game Overlays**: UI component testing
- **Navigation**: Route testing

## Performance Architecture

### Game Performance
- **Object Pooling**: For frequently created/destroyed entities
- **Update Optimization**: Minimal allocations in `update()` methods
- **Asset Caching**: Preloaded and cached sprites/sounds
- **Component Lifecycle**: Proper `onLoad()` and `onRemove()` handling

### Memory Management
- **Resource Cleanup**: Dispose patterns in `onRemove()`
- **Texture Optimization**: Appropriate image sizes and formats
- **Audio Management**: Efficient audio loading and playback

## Localization Architecture

### Generated Localization
Using Flutter's built-in `l10n` system:
- **ARB Files**: Translation source files
- **Generated Classes**: Type-safe translation access
- **Game Integration**: Injected via constructor

### Usage Patterns
```dart
// In Flutter widgets
Text(context.l10n.welcomeMessage)

// In game components  
TextComponent(text: game.l10n.scoreLabel)
```

## Build and Environment Architecture

### Environment Management
Three build environments:
- **Development**: Debug features enabled
- **Staging**: Production-like with debug access
- **Production**: Optimized release build

### Flavor Configuration
Platform-specific configurations:
- Android: Build flavors
- iOS: Build schemes
- Web: Environment variables

## Security Considerations

### Asset Security
- No sensitive data in assets
- Obfuscated configurations for production

### State Security
- No sensitive data in shared preferences
- Secure storage for critical data

## Scalability Considerations

### Code Organization
- **Modular Architecture**: Easy to add new features
- **Barrel Exports**: Clean import management  
- **Clear Boundaries**: Well-defined layer responsibilities

### Performance Scaling
- **Component Pooling**: Handle many entities efficiently
- **Efficient Updates**: Optimized game loop performance
- **Asset Management**: Scalable asset loading strategies

This architecture provides a solid foundation for building a maintainable, testable, and scalable Flutter Flame game while following industry best practices and Very Good CLI patterns.
