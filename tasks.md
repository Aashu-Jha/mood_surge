# Welcome Screen Implementation Tasks

## Overview
Create a new welcome/intro screen that displays the welcome image and provides a "Play" button to start the game, following the existing architecture patterns.

## Task Breakdown

### Phase 1: Feature Module Setup (Replace TitlePage)
- [ ] **Task 1.1**: Replace title feature module with welcome
  - Rename/replace `lib/title/` with `lib/welcome/`
  - Create subdirectories: `cubit/`, `view/`
  - Create main export file `lib/welcome/welcome.dart`

- [ ] **Task 1.2**: Create state management (BLoC/Cubit)
  - Create `lib/welcome/cubit/welcome_state.dart` - Define welcome screen states (initial, fading, navigating)
  - Create `lib/welcome/cubit/welcome_cubit.dart` - Handle welcome screen logic and fade transitions
  - Create barrel export `lib/welcome/cubit/cubit.dart`

### Phase 2: UI Implementation  
- [ ] **Task 2.1**: Create welcome view components
  - Create `lib/welcome/view/welcome_page.dart` - Main page widget with route setup (replace TitlePage)
  - Create `lib/welcome/view/welcome_view.dart` - Core welcome UI implementation
  - Create barrel export `lib/welcome/view/view.dart`

- [ ] **Task 2.2**: Implement welcome screen UI with specifications
  - Display welcome image filling entire screen using `BoxFit.cover`
  - Add custom-styled "Play" button matching reference design
  - Implement fade transitions for screen entrance and button interactions
  - Position button overlay on top of full-screen image
  - Add responsive layout with proper positioning

### Phase 3: Navigation Integration (Replace TitlePage)
- [ ] **Task 3.1**: Update app routing (replace title with welcome)
  - Update LoadingPage navigation to go to WelcomePage instead of TitlePage
  - Remove TitlePage route references
  - Add welcome route configuration
  - Ensure proper fade transition animations between screens

- [ ] **Task 3.2**: Clean up title references
  - Remove unused title module files
  - Update any remaining TitlePage imports
  - Verify all navigation flows work correctly

### Phase 4: Testing & Polish
- [ ] **Task 4.1**: Create tests
  - Unit tests for welcome cubit
  - Widget tests for welcome UI components
  - Integration test for navigation flow

- [ ] **Task 4.2**: Code quality & documentation
  - Run linting and format code
  - Add documentation comments
  - Verify accessibility features

## Implementation Approach

### Architecture Integration
Following the existing project patterns:

1. **State Management**: Use Cubit pattern similar to existing features
   - `WelcomeState` with status enum (initial, navigating)
   - `WelcomeCubit` to handle play button logic and fade transitions

2. **UI Structure**: Follow existing view patterns
   - `WelcomePage` as route-aware widget (replacing TitlePage)
   - `WelcomeView` as core UI implementation
   - BlocProvider/BlocBuilder for state management

3. **Asset Usage**: Utilize generated asset references
   - Access via `Assets.images.welcomeImg.image()`
   - Fill entire screen with `BoxFit.cover`

### Navigation Flow (Updated)
```
App Start → LoadingPage → Welcome Screen → [Play Button] → Game Screen
```
**Note**: Replaces existing TitlePage entirely

### File Structure
```
lib/welcome/
├── cubit/
│   ├── welcome_cubit.dart
│   ├── welcome_state.dart
│   └── cubit.dart (barrel export)
├── view/
│   ├── welcome_page.dart
│   ├── welcome_view.dart
│   └── view.dart (barrel export)
└── welcome.dart (main barrel export)
```

### Key Components

#### WelcomeState
```dart
enum WelcomeStatus { initial, fading, navigating }

class WelcomeState extends Equatable {
  const WelcomeState({
    this.status = WelcomeStatus.initial,
    this.opacity = 1.0,
  });
  final WelcomeStatus status;
  final double opacity;
  // ... copyWith, props
}
```

#### WelcomeView UI Structure
```dart
- Scaffold
  - Body: Stack
    - Positioned.fill: Welcome Image (BoxFit.cover, full screen)
    - Positioned (bottom): AnimatedOpacity
      - Custom Styled Play Button
        - Rounded corners, custom colors
        - "Play" text with custom typography
        - onPressed: cubit.playPressed() with fade transition
```

#### Asset Integration & Styling
- Use generated asset: `Assets.images.welcomeImg.image(fit: BoxFit.cover)`
- Custom button styling: rounded corners, gradient/solid colors, shadows
- Fade transitions: AnimatedOpacity and PageRouteBuilder with fade transitions
- Full screen layout: Stack with Positioned.fill for image overlay

### Technical Considerations

1. **Full Screen Image**: Use Stack with Positioned.fill for true full-screen coverage
2. **Custom Button Styling**: Create custom ButtonStyle with rounded corners, colors, shadows
3. **Fade Transitions**: 
   - AnimatedOpacity for button hover/press effects
   - PageRouteBuilder with FadeTransition for screen navigation
   - Smooth timing curves for professional feel
4. **Performance**: Optimize large welcome image loading and caching
5. **Responsive Design**: Ensure button positioning works on all screen sizes
6. **Accessibility**: Add semantic labels and proper contrast ratios

### Integration Points

1. **App Router**: Add welcome route and update initial route
2. **Game Navigation**: Ensure smooth transition to game screen
3. **Asset System**: Verify generated asset name and usage
4. **Theme Integration**: Use existing app theme for button styling

## Next Steps

1. **Verification**: Confirm generated asset name for welcome image
2. **Approval**: Get approval for this implementation approach  
3. **Implementation**: Execute tasks in order
4. **Testing**: Verify functionality across different screen sizes
5. **Integration**: Ensure smooth flow with existing game logic

## Implementation Specifications ✅

**CONFIRMED REQUIREMENTS:**
1. ✅ **Replace TitlePage entirely** - Welcome screen replaces existing title functionality
2. ✅ **Image Display**: Full screen coverage using `BoxFit.cover`
3. ✅ **Button Styling**: Custom styling to match reference design
4. ✅ **Animations**: Fade transitions for screen and button interactions
5. ✅ **Generated Asset**: `Assets.images.welcomeImg` confirmed in assets.gen.dart

## Ready for Implementation! 🚀

All requirements are clarified and the technical approach is solid. The implementation will:

- **Replace** existing TitlePage with new WelcomeScreen
- **Full-screen image** with custom-styled overlay button
- **Smooth fade transitions** throughout the user experience
- **Follow existing architecture patterns** for maintainable code
- **Comprehensive testing** for reliability

**Approval needed to begin implementation!**
