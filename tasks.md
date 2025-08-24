# Character Loading Implementation Tasks

## Overview

Load the Archer character into the game widget so it's visible and interactive. Create a new Archer
entity following the project's flame_behaviors architecture pattern, similar to the existing Unicorn
entity.

## Task Breakdown

### Phase 1: Archer Entity Creation

- [ ] **Task 1.1**: Create Archer entity structure
  - Create directory `lib/game/entities/archer/`
  - Create subdirectory `lib/game/entities/archer/behaviors/`
  - Create main entity file `lib/game/entities/archer/archer.dart`

- [ ] **Task 1.2**: Implement base Archer entity
  - Extend `PositionedEntity` with `HasGameReference`
  - Set up proper size, anchor, and position
  - Create constructor with required parameters
  - Add test constructor for testing

- [ ] **Task 1.3**: Implement Archer sprite animation system
  - Load Archer sprite sheets (Idle, Run, Walk, Jump, etc.)
  - Create `SpriteAnimationComponent` for different states
  - Implement animation state management
  - Add methods for playing different animations (idle, run, attack, etc.)

### Phase 2: Archer Behaviors Implementation

- [ ] **Task 2.1**: Create basic interaction behavior
  - Create `lib/game/entities/archer/behaviors/archer_interaction_behavior.dart`
  - Implement `TapCallbacks` for basic character interaction
  - Add sound effects on interaction
  - Handle animation triggers on tap

- [ ] **Task 2.2**: Create animation management behavior
  - Create `lib/game/entities/archer/behaviors/animation_behavior.dart`
  - Manage different animation states (idle, run, attack, hurt, dead)
  - Handle animation transitions and timing
  - Implement animation event callbacks

- [ ] **Task 2.3**: Create movement behavior (optional for initial display)
  - Create `lib/game/entities/archer/behaviors/movement_behavior.dart`
  - Implement basic movement mechanics
  - Handle directional sprite flipping
  - Add keyboard/touch input handling

### Phase 3: Game Integration

- [ ] **Task 3.1**: Update entities barrel export
  - Add Archer export to `lib/game/entities/entities.dart`
  - Ensure proper imports and exports

- [ ] **Task 3.2**: Load Archer in game
  - Update `MoodSurge.onLoad()` to include Archer entity
  - Position Archer appropriately in the game world
  - Ensure proper camera setup for character visibility

- [ ] **Task 3.3**: Asset loading and optimization
  - Preload Archer sprite assets in game initialization
  - Optimize sprite sheet loading for performance
  - Handle asset caching properly

### Phase 4: Character Display and Polish

- [ ] **Task 4.1**: Character positioning and scaling
  - Position Archer character visibly on screen
  - Set appropriate character size and scale
  - Adjust camera zoom/position for optimal viewing

- [ ] **Task 4.2**: Animation integration
  - Set default idle animation
  - Test animation playback
  - Ensure smooth animation loops

- [ ] **Task 4.3**: Basic interaction testing
  - Verify tap interactions work
  - Test animation state changes
  - Confirm sound effects play correctly

### Phase 5: Code Quality and Cleanup

- [ ] **Task 5.1**: Code review and optimization
  - Follow project linting standards
  - Optimize performance for smooth gameplay
  - Add proper documentation comments

- [ ] **Task 5.2**: Error handling and edge cases
  - Handle missing assets gracefully
  - Add proper error logging
  - Ensure robust initialization

## Implementation Approach

### Architecture Integration
Following the existing project patterns:

1. **Entity Pattern**: Use `PositionedEntity` with flame_behaviors like existing Unicorn
2. **Behavior Composition**: Create modular behaviors for different character aspects
3. **Asset Management**: Use generated Assets class for sprite references
4. **Game Loading**: Add to MoodSurge.onLoad() alongside existing components

### File Structure
```
lib/game/entities/archer/
├── behaviors/
│   ├── archer_interaction_behavior.dart
│   ├── animation_behavior.dart
│   ├── movement_behavior.dart (optional)
│   └── behaviors.dart (barrel export)
├── archer.dart
└── archer.dart (main export)
```

### Sprite Assets Available

Using generated asset references:

- `Assets.images.archer.idle` - Idle animation
- `Assets.images.archer.run` - Running animation
- `Assets.images.archer.walk` - Walking animation
- `Assets.images.archer.jump` - Jumping animation
- `Assets.images.archer.attack1` - Attack animation
- `Assets.images.archer.hurt` - Hurt animation
- `Assets.images.archer.dead` - Death animation

### Character Integration Points

#### 1. Game Loading (MoodSurge.onLoad)
```dart

final world = World(
  children: [
    Unicorn(position: size / 2),
    Archer(position: Vector2(size.x / 2 - 50, size.y / 2)), // Add Archer
    CounterComponent(position: (size / 2)
      ..sub(Vector2(0, 16))),
  ],
);
```

#### 2. Archer Entity Structure
```dart
class Archer extends PositionedEntity with HasGameReference {
  Archer({required super.position})
          : super(
    anchor: Anchor.center,
    size: Vector2(32, 32), // Adjust based on sprite size
    behaviors: [
      ArcherInteractionBehavior(),
      AnimationBehavior(),
    ],
  );
}
```

#### 3. Animation System

```dart
// Multiple animations for different states
late SpriteAnimationComponent _idleAnimation;
late SpriteAnimationComponent _runAnimation;
// ... other animations

// Animation state management
enum AnimationState { idle, running, attacking, hurt, dead }

AnimationState currentState = AnimationState.idle;
```

### Technical Considerations

1. **Sprite Sheet Analysis**: Examine Archer sprites to determine:
  - Frame count per animation
  - Sprite dimensions
  - Animation timing requirements

2. **Performance**:
  - Preload critical animations
  - Use appropriate step times for smooth animation
  - Implement efficient sprite switching

3. **Character Scale**:
  - Match existing game scale (camera zoom = 8)
  - Ensure character fits well with existing Unicorn size

4. **Input Handling**:
  - Basic tap interaction initially
  - Extensible for future complex controls

### Success Criteria

✅ **Archer character is visible in game**
✅ **Character displays default idle animation**  
✅ **Basic tap interaction works (animation change)**
✅ **Character is properly positioned and scaled**
✅ **No performance issues or errors**
✅ **Follows existing project architecture patterns**

## Implementation Priority

### Minimum Viable Implementation (Phase 1-3)

Focus on getting the Archer character loaded and visible:

1. Basic Archer entity with idle animation
2. Simple tap interaction behavior
3. Integration into game world

### Enhanced Implementation (Phase 4-5)

Add polish and additional features:

1. Multiple animation states
2. Advanced behaviors
3. Code optimization and cleanup

## Next Steps

1. **Asset Analysis**: Examine Archer sprite sheets to determine exact dimensions and frame counts
2. **Approval**: Get approval for this implementation approach
3. **Implementation**: Execute tasks in priority order
4. **Testing**: Verify character loads and displays correctly
5. **Integration**: Ensure smooth integration with existing game elements

## Ready for Implementation! 🚀

The Archer character loading implementation will:

- **Follow existing patterns** - Uses same architecture as Unicorn entity
- **Modular design** - Behavior composition for extensibility
- **Asset integration** - Proper use of generated asset references
- **Performance focused** - Efficient sprite loading and animation
- **Interactive character** - Basic interaction ready for expansion

**Approval needed to begin implementation!**