# Development Guide

## Quick Start

### Setup
```bash
# Install FVM (Flutter Version Management)
dart pub global activate fvm

# Install Flutter version specified in .fvmrc
fvm install

# Get dependencies
fvm flutter pub get

# Generate code
fvm flutter packages pub run build_runner build --delete-conflicting-outputs

# Run tests
fvm flutter test
```

### Development Commands
```bash
# Development environment
fvm flutter run --flavor development -t lib/main_development.dart

# Staging environment  
fvm flutter run --flavor staging -t lib/main_staging.dart

# Production environment
fvm flutter run --flavor production -t lib/main_production.dart

# Hot reload during development
# Press 'r' in terminal or use IDE hot reload
```

## Daily Development Workflow

### 1. Starting Development
```bash
# Pull latest changes
git pull origin main

# Install any new dependencies
fvm flutter pub get

# Regenerate code if needed
fvm flutter packages pub run build_runner build

# Run tests to ensure clean state
fvm flutter test
```

### 2. Feature Development
```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Start development server
fvm flutter run --flavor development -t lib/main_development.dart
```

### 3. Code Quality Checks
```bash
# Run linting
fvm flutter analyze

# Format code
fvm flutter format .

# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage
```

### 4. Committing Changes
```bash
# Stage changes
git add .

# Commit with conventional commit message
git commit -m "feat: add player jump mechanics"

# Push to remote
git push origin feature/your-feature-name
```

## IDE Configuration

### VS Code Settings
Create/update `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "dart.lineLength": 80,
  "dart.closingLabels": true,
  "dart.previewFlutterUiGuides": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "files.associations": {
    "*.arb": "json"
  }
}
```

### VS Code Extensions
Recommended extensions:
- Dart
- Flutter  
- Bloc
- Error Lens
- GitLens
- Thunder Client (for API testing)

### Cursor AI Integration
The project is optimized for Cursor AI development:
- `.cursorrules` file provides comprehensive context
- Use Cursor's AI assistance for code generation following project patterns
- Leverage AI for test generation and debugging

## Development Patterns

### Creating New Features

#### 1. Game Entity
```bash
# Create entity directory
mkdir -p lib/game/entities/new_entity/behaviors

# Create main entity file
touch lib/game/entities/new_entity/new_entity.dart

# Create behaviors directory and files
touch lib/game/entities/new_entity/behaviors/behaviors.dart

# Export in entities.dart
echo "export 'new_entity/new_entity.dart';" >> lib/game/entities/entities.dart
```

#### 2. Game Component  
```bash
# Create component file
touch lib/game/components/new_component.dart

# Export in components.dart
echo "export 'new_component.dart';" >> lib/game/components/components.dart

# Create test file
touch test/game/components/new_component_test.dart
```

#### 3. Feature Module
```bash
# Create feature directory structure
mkdir -p lib/new_feature/{cubit,view}

# Create files
touch lib/new_feature/cubit/new_feature_{cubit,state}.dart
touch lib/new_feature/view/new_feature_{page,view}.dart
touch lib/new_feature/new_feature.dart

# Create tests
mkdir -p test/new_feature/{cubit,view}
touch test/new_feature/cubit/new_feature_cubit_test.dart
```

### Asset Management

#### Adding New Images
```bash
# Add image to assets/images/
cp new_image.png assets/images/

# Regenerate assets
fvm flutter packages pub run build_runner build

# Use in code
Assets.images.newImage.path
```

#### Adding New Audio
```bash
# Add audio to assets/audio/
cp new_sound.mp3 assets/audio/

# Regenerate assets  
fvm flutter packages pub run build_runner build

# Preload in game
await AudioPool.create(Assets.audio.newSound.path);
```

### State Management Patterns

#### Creating a Cubit
```bash
# Create cubit files
touch lib/feature/cubit/feature_cubit.dart
touch lib/feature/cubit/feature_state.dart

# Create test
touch test/feature/cubit/feature_cubit_test.dart
```

Follow the template patterns in `.cursorrules` for implementation.

## Testing Workflow

### Running Tests
```bash
# All tests
fvm flutter test

# Specific test file
fvm flutter test test/game/entities/player_test.dart

# Tests with coverage
fvm flutter test --coverage

# Watch mode (re-run on changes)
fvm flutter test --watch

# Integration tests
fvm flutter drive --target=test_driver/app.dart
```

### Test Categories

#### Unit Tests
- Business logic (cubits, services)
- Utility functions
- Game calculations

#### Widget Tests
- Flutter UI components
- Game overlay widgets
- Navigation

#### Game Tests
- Flame components
- Entity behaviors
- Game mechanics

### Writing Quality Tests

#### Follow AAA Pattern
```dart
test('description', () {
  // Arrange - Set up test data
  final cubit = GameCubit();
  
  // Act - Execute the behavior
  cubit.startGame();
  
  // Assert - Verify the outcome
  expect(cubit.state.status, GameStatus.playing);
});
```

#### Use BlocTest for State Management
```dart
blocTest<GameCubit, GameState>(
  'emits playing state when startGame is called',
  build: () => GameCubit(),
  act: (cubit) => cubit.startGame(),
  expect: () => [
    predicate<GameState>((state) => state.status == GameStatus.playing),
  ],
);
```

## Debugging

### Flutter Inspector
Use Flutter Inspector in your IDE to:
- Inspect widget tree
- Analyze layout issues  
- Monitor performance
- Debug state changes

### Game Debugging
```dart
// Add debug overlays in development
@override
bool debugMode = kDebugMode;

// Log game events
debugPrint('Player position: ${player.position}');

// Visual debugging
add(RectangleComponent()..debugMode = true);
```

### Performance Profiling
```bash
# Profile app performance
fvm flutter run --profile

# Memory profiling
fvm flutter run --profile --dart-define=profile_memory=true

# GPU profiling
fvm flutter run --profile --dart-define=profile_gpu=true
```

## Deployment

### Building for Release

#### Android
```bash
# Build APK
fvm flutter build apk --flavor production -t lib/main_production.dart

# Build AAB (recommended)
fvm flutter build appbundle --flavor production -t lib/main_production.dart
```

#### iOS
```bash
# Build for iOS
fvm flutter build ios --flavor production -t lib/main_production.dart
```

#### Web
```bash
# Build for web
fvm flutter build web -t lib/main_production.dart
```

### Pre-release Checklist
- [ ] All tests pass
- [ ] No linting errors
- [ ] Performance is acceptable
- [ ] Assets are optimized
- [ ] Translations are complete
- [ ] Version numbers updated
- [ ] Change log updated

## Troubleshooting

### Common Issues

#### Build Runner Issues
```bash
# Clean and rebuild
fvm flutter packages pub run build_runner clean
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### Dependencies Issues
```bash
# Clean pub cache
fvm flutter pub deps
fvm flutter pub get

# Reset everything
fvm flutter clean
fvm flutter pub get
```

#### FVM Issues
```bash
# Check FVM status
fvm list

# Reinstall Flutter version
fvm install --force

# Use global Flutter (temporary)
flutter run --flavor development -t lib/main_development.dart
```

#### Game Performance Issues
1. Check for memory leaks in `onRemove()`
2. Profile with Flutter Inspector
3. Optimize asset sizes
4. Reduce update() method complexity
5. Use object pooling for entities

### Getting Help
1. Check existing GitHub issues
2. Review Flutter Flame documentation
3. Check Very Good CLI documentation
4. Create detailed issue with reproduction steps

## Code Quality

### Automated Checks
The project includes automated quality checks:
- Very Good Analysis linting
- Test coverage requirements
- Format validation
- Import organization

### Manual Reviews
Before committing:
1. Review changed files
2. Run full test suite
3. Check performance impact
4. Verify documentation updates
5. Test on target devices

## Continuous Integration

### GitHub Actions
The project uses GitHub Actions for:
- Automated testing on PRs
- Code quality checks
- Build validation
- Coverage reporting

### Pre-commit Hooks
Consider adding pre-commit hooks:
```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install
```

This development guide should help you maintain high code quality and efficient development practices while working on Mood Surge! 🚀
