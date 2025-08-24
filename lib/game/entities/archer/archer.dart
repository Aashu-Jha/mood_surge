import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:mood_surge/game/entities/archer/behaviors/behaviors.dart';
import 'package:mood_surge/gen/assets.gen.dart';

/// Animation states available for the Archer
enum ArcherAnimationState { idle, running, walking, attacking }

/// An Archer character entity with sprite animations and behaviors.
class Archer extends PositionedEntity with HasGameReference {
  Archer({required super.position})
    : super(
        anchor: Anchor.center,
        size: Vector2.all(32), // Make it bigger and more visible
        behaviors: [ArcherInteractionBehavior()],
      );

  @visibleForTesting
  Archer.test({required super.position, super.behaviors})
    : super(size: Vector2.all(32));

  late SpriteAnimationComponent _idleAnimation;
  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _walkAnimation;
  late SpriteAnimationComponent _attackAnimation;

  /// The current active animation component
  SpriteAnimationComponent? _currentAnimation;

  ArcherAnimationState _currentState = ArcherAnimationState.idle;

  @visibleForTesting
  SpriteAnimationTicker get animationTicker =>
      _currentAnimation?.animationTicker ?? _idleAnimation.animationTicker!;

  /// Current animation state - accessible by behaviors
  ArcherAnimationState get currentState => _currentState;

  @override
  Future<void> onLoad() async {
    print('🏹 Archer: Starting to load at position $position');

    try {
      // Load only idle animation first to debug
      final idleAnimation = SpriteAnimation.fromFrameData(
        game.images.fromCache(Assets.images.archer.idle.path),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.15,
          textureSize: Vector2.all(128),
          loop: true,
        ),
      );

      // Create only idle animation component for now
      _idleAnimation = SpriteAnimationComponent(
        animation: idleAnimation,
        size: size,
      );

      // Start with idle animation
      await add(_idleAnimation);
      _currentAnimation = _idleAnimation;
      _currentState = ArcherAnimationState.idle;

      print(
        '🏹 Archer: Successfully loaded idle animation at position $position with size $size',
      );
    } catch (e) {
      print('🏹 Archer: Error loading: $e');
      rethrow;
    }
  }

  // @override
  // void update(double dt) {
  //   this.changeAnimationState(ArcherAnimationState.attacking);
  // }

  /// Changes to the specified animation state
  Future<void> changeAnimationState(ArcherAnimationState newState) async {
    if (_currentState == newState) return;

    // Remove current animation
    if (_currentAnimation != null) {
      _currentAnimation!.removeFromParent();
    }

    // Add new animation based on state
    switch (newState) {
      case ArcherAnimationState.idle:
        await add(_idleAnimation);
        _currentAnimation = _idleAnimation;
      case ArcherAnimationState.running:
        await add(_runAnimation);
        _currentAnimation = _runAnimation;
      case ArcherAnimationState.walking:
        await add(_walkAnimation);
        _currentAnimation = _walkAnimation;
      case ArcherAnimationState.attacking:
        await add(_attackAnimation);
        _currentAnimation = _attackAnimation;
    }

    _currentState = newState;
    _currentAnimation?.animationTicker?.reset();
  }

  /// Plays the attack animation and returns to idle when done
  void playAttackAnimation() {
    if (_currentState == ArcherAnimationState.attacking) return;

    changeAnimationState(ArcherAnimationState.attacking);

    // Return to idle after attack animation completes
    Future.delayed(const Duration(milliseconds: 400), () {
      if (_currentState == ArcherAnimationState.attacking) {
        changeAnimationState(ArcherAnimationState.idle);
      }
    });
  }

  /// Returns whether the current animation is playing or not
  bool isAnimationPlaying() =>
      _currentAnimation?.animationTicker?.done() == false;

  /// Returns whether the archer is currently in idle state
  bool isIdle() => _currentState == ArcherAnimationState.idle;
}
