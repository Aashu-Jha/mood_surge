# Mood Surge 🦄

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter Flame 2D game built with [Very Good CLI][very_good_cli_link] architecture patterns, featuring BLoC state management, flame_behaviors entity composition, and comprehensive testing.

## ✨ Features

- 🎮 **Flutter Flame Engine**: High-performance 2D game engine
- 🏗️ **Clean Architecture**: Modular structure with clear separation of concerns
- 🔄 **BLoC State Management**: Predictable state management with bloc pattern
- 🧩 **Entity-Behavior Composition**: Flexible game entity system using flame_behaviors
- 🌍 **Internationalization**: Built-in i18n support with multiple languages
- 🧪 **Comprehensive Testing**: Unit, widget, and game tests with high coverage
- 🚀 **Multiple Environments**: Development, staging, and production builds
- 📱 **Cross-Platform**: Works on iOS, Android, Web, and Desktop

## 🏗️ Project Structure

```
lib/
├── app/                    # Flutter app configuration & routing
├── game/                   # Flame game engine logic
│   ├── components/         # Reusable game components
│   ├── cubit/             # Game state management
│   ├── entities/          # Game entities with behaviors
│   └── view/              # Game view widgets & overlays
├── loading/               # Loading screen module
├── title/                 # Title screen module
├── gen/                   # Generated code (assets, l10n)
└── l10n/                  # Localization files
```

## 🚀 Quick Start

### Automated Setup (Recommended)

```bash
# Run the setup script
./setup_dev.sh

# Start development
source dev_aliases.sh
fd  # Runs development flavor
```

### Manual Setup

1. **Install FVM (Flutter Version Management)**
   ```bash
   dart pub global activate fvm
   ```

2. **Install Flutter version and dependencies**
   ```bash
   fvm install                                           # Install Flutter version from .fvmrc
   fvm flutter pub get                                   # Get dependencies
   fvm flutter packages pub run build_runner build      # Generate code
   ```

3. **Run the app**
   ```bash
   # Development
   fvm flutter run --flavor development -t lib/main_development.dart
   
   # Staging
   fvm flutter run --flavor staging -t lib/main_staging.dart
   
   # Production
   fvm flutter run --flavor production -t lib/main_production.dart
   ```

## 🧪 Testing

```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Generate and view coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

## 📚 Documentation

- **[Architecture Guide](docs/ARCHITECTURE.md)** - Detailed architecture overview
- **[Development Guide](docs/DEVELOPMENT.md)** - Daily development workflow
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute to the project
- **[Cursor AI Rules](.cursorrules)** - AI-assisted development guidelines

## 🎮 Game Development

### Adding New Entities

1. Create entity directory structure:
   ```bash
   mkdir -p lib/game/entities/new_entity/behaviors
   ```

2. Follow the entity template in `.cursorrules`

3. Export in `lib/game/entities/entities.dart`

### Adding New Components

1. Create component in `lib/game/components/`
2. Follow the component template pattern
3. Export in `components.dart` barrel file
4. Add comprehensive tests

### State Management

Use BLoC/Cubit pattern for state management:
- Game state: `GameCubit` for overall game status
- Feature state: Feature-specific cubits
- UI state: Widget-level state for simple UI

## 🌐 Internationalization

### Adding Strings

1. Add to `lib/l10n/arb/app_en.arb`:
   ```arb
   {
     "newString": "Hello World",
     "@newString": {
       "description": "A greeting message"
     }
   }
   ```

2. Use in code:
   ```dart
   // In Flutter widgets
   Text(context.l10n.newString)
   
   // In game components
   Text(game.l10n.newString)
   ```

### Adding New Languages

1. Create new `.arb` file: `app_es.arb`
2. Add translations
3. Update iOS `Info.plist` CFBundleLocalizations

## 🔧 Development Tools

### VS Code Configuration
- **Settings**: Optimized `.vscode/settings.json`
- **Launch Configs**: Pre-configured debug profiles
- **Extensions**: Recommended extension pack

### Useful Commands

```bash
# Development aliases (after running setup_dev.sh)
fd    # Run development
fs    # Run staging  
fp    # Run production
ft    # Run tests
fa    # Run analyzer
ff    # Format code
fg    # Generate code
fc    # Clean and get dependencies
```

### Code Quality

The project enforces high code quality standards:
- **Very Good Analysis**: Comprehensive linting rules
- **Test Coverage**: Minimum 80% coverage required
- **Conventional Commits**: Standardized commit messages
- **Pre-commit Hooks**: Automated quality checks

## 🏭 Build & Deploy

### Development Builds
```bash
fvm flutter run --flavor development -t lib/main_development.dart
```

### Release Builds
```bash
# Android
fvm flutter build appbundle --flavor production -t lib/main_production.dart

# iOS  
fvm flutter build ios --flavor production -t lib/main_production.dart

# Web
fvm flutter build web -t lib/main_production.dart
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Follow the coding standards in `.cursorrules`
4. Write tests for your changes
5. Ensure all tests pass: `fvm flutter test`
6. Submit a pull request

## 📦 Dependencies

### Core Dependencies
- **[flame](https://pub.dev/packages/flame)**: 2D game engine
- **[flame_behaviors](https://pub.dev/packages/flame_behaviors)**: Entity composition system
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**: State management
- **[flame_audio](https://pub.dev/packages/flame_audio)**: Game audio support

### Development Dependencies
- **[very_good_analysis](https://pub.dev/packages/very_good_analysis)**: Linting rules
- **[flame_test](https://pub.dev/packages/flame_test)**: Game testing utilities
- **[bloc_test](https://pub.dev/packages/bloc_test)**: BLoC testing utilities
- **[mocktail](https://pub.dev/packages/mocktail)**: Mocking framework

## 🎯 Performance

- **Target**: 60 FPS on all supported platforms
- **Optimization**: Object pooling for frequently created entities
- **Profiling**: Regular performance monitoring with Flutter DevTools
- **Memory**: Efficient resource management with proper cleanup

## 🐛 Troubleshooting

### Common Issues

**Build Runner Issues**
```bash
fvm flutter packages pub run build_runner clean
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

**FVM Issues**
```bash
fvm list                    # Check FVM status
fvm install --force         # Reinstall Flutter version
```

**Performance Issues**
1. Check for memory leaks in component `onRemove()` methods
2. Profile with Flutter Inspector
3. Optimize asset sizes and loading
4. Review `update()` method complexity

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Very Good CLI](https://cli.vgv.dev/)
- Powered by [Flutter Flame](https://flame-engine.org/)
- State management by [BLoC Library](https://bloclibrary.dev/)

---

**Happy coding! 🦄✨**

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
