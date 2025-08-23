# Contributing to Mood Surge

Welcome to Mood Surge! This guide will help you contribute effectively to this Flutter Flame game project.

## Development Setup

### Prerequisites
- Flutter SDK (version specified in `.fvmrc`)
- FVM (Flutter Version Management) - recommended
- VS Code or your preferred IDE
- Git

### Initial Setup
1. Clone the repository
2. Install FVM: `dart pub global activate fvm`
3. Install Flutter version: `fvm install`
4. Get dependencies: `fvm flutter pub get`
5. Generate code: `fvm flutter packages pub run build_runner build`
6. Run tests: `fvm flutter test`

### Environment Setup
The project supports multiple environments:
- **Development**: `fvm flutter run --flavor development -t lib/main_development.dart`
- **Staging**: `fvm flutter run --flavor staging -t lib/main_staging.dart`
- **Production**: `fvm flutter run --flavor production -t lib/main_production.dart`

## Development Workflow

### Feature Development
1. Create feature branch: `git checkout -b feature/your-feature-name`
2. Follow the architectural patterns described in `.cursorrules`
3. Write tests for new functionality
4. Ensure all tests pass: `fvm flutter test`
5. Run analysis: `fvm flutter analyze`
6. Commit using conventional commits
7. Push and create pull request

### Code Organization
Follow the established directory structure:
```
lib/
├── app/                    # Flutter app configuration
├── game/                   # Flame game logic
│   ├── components/         # Reusable components
│   ├── cubit/             # State management
│   ├── entities/          # Game entities
│   └── view/              # Game views
├── loading/               # Loading screen
├── title/                 # Title screen
└── gen/                   # Generated code
```

### Adding New Features

#### Adding a Game Entity
1. Create entity directory: `lib/game/entities/your_entity/`
2. Create main entity file: `your_entity.dart`
3. Create behaviors directory if needed: `behaviors/`
4. Export in `lib/game/entities/entities.dart`
5. Add comprehensive tests
6. Update documentation

#### Adding a Game Component
1. Create component in `lib/game/components/`
2. Export in `components.dart` barrel file
3. Follow naming convention: `YourComponent`
4. Add tests in `test/game/components/`
5. Document public APIs

#### Adding State Management
1. Create cubit in appropriate directory
2. Define states with Equatable
3. Use copyWith pattern for immutability
4. Write comprehensive bloc_test tests
5. Handle all state transitions

## Code Standards

### Dart Code Style
- Follow very_good_analysis linting rules
- Use trailing commas for better git diffs
- Maximum line length: 80 characters
- Prefer explicit types over var when it improves readability
- Use meaningful, descriptive names

### Testing Requirements
- Minimum 80% test coverage
- Unit tests for all business logic
- Widget tests for UI components
- Game tests for Flame components
- Use golden tests for visual components when appropriate

### Commit Guidelines
Use conventional commits:
- `feat: add player jump mechanics`
- `fix: resolve audio playback issue`
- `docs: update API documentation`
- `style: format code according to style guide`
- `refactor: restructure entity behaviors`
- `test: add tests for collision detection`
- `chore: update dependencies`

## Game Development Guidelines

### Performance Best Practices
- Minimize allocations in `update()` methods
- Use object pooling for frequently created objects
- Cache expensive calculations
- Profile performance regularly
- Target 60fps on target devices

### Asset Management
- Use generated asset references from `lib/gen/assets.gen.dart`
- Optimize images for different screen densities
- Compress audio files appropriately
- Preload critical assets in `onLoad()`

### Audio Integration
- Use `flame_audio` for game sounds
- Use `audioplayers` for complex audio needs
- Preload audio in game initialization
- Handle audio permissions properly

### Localization
- Add all user-facing strings to .arb files
- Test with different languages
- Support RTL languages when applicable
- Use semantic keys for translations

## Testing

### Running Tests
```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run specific test file
fvm flutter test test/game/entities/player_test.dart

# Run golden tests
fvm flutter test --update-goldens
```

### Writing Tests

#### Unit Tests
```dart
group('PlayerCubit', () {
  late PlayerCubit cubit;
  
  setUp(() {
    cubit = PlayerCubit();
  });
  
  blocTest<PlayerCubit, PlayerState>(
    'emits new position when move is called',
    build: () => cubit,
    act: (cubit) => cubit.move(Vector2(10, 0)),
    expect: () => [isA<PlayerState>()],
  );
});
```

#### Game Tests
```dart
group('Player', () {
  late MoodSurge game;
  
  setUp(() {
    game = MoodSurge(/* required parameters */);
  });
  
  testWithGame<MoodSurge>(
    'Player moves correctly',
    game,
    (game) async {
      final player = Player(position: Vector2.zero());
      await game.ensureAdd(player);
      
      player.move(Vector2(10, 0));
      
      expect(player.position.x, equals(10));
    },
  );
});
```

## Documentation

### Code Documentation
- Document all public APIs
- Use dartdoc comments (`///`)
- Include examples for complex functionality
- Keep documentation up to date with code changes

### Architecture Documentation
- Update `docs/ARCHITECTURE.md` for significant changes
- Document design decisions and trade-offs
- Include diagrams for complex interactions
- Explain integration patterns

## Pull Request Process

### Before Submitting
- [ ] All tests pass
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] No linting errors
- [ ] Performance impact considered
- [ ] Accessibility requirements met

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Performance improvement
- [ ] Refactoring
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] Performance tested

## Screenshots/Videos
(If applicable)

## Breaking Changes
(If any)
```

## Getting Help

### Resources
- [Flutter Flame Documentation](https://docs.flame-engine.org/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Very Good CLI Documentation](https://cli.vgv.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)

### Support Channels
- Create GitHub issues for bugs
- Start discussions for feature requests
- Review existing issues before creating new ones

## Code of Conduct

### Be Respectful
- Use inclusive language
- Be constructive in feedback
- Help others learn and grow
- Celebrate contributions of all sizes

### Quality Standards
- Write clean, readable code
- Test your changes thoroughly
- Document your work
- Follow established patterns

Thank you for contributing to Mood Surge! 🦄🎮
