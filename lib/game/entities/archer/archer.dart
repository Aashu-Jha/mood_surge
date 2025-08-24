import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:mood_surge/game/entities/archer/behaviors/behaviors.dart';
import 'package:mood_surge/game/entities/arrow/arrow.dart';
import 'package:mood_surge/gen/assets.gen.dart';

/// Animation states available for the Archer
enum ArcherAnimationState {
  idle,
  idle2,
  running,
  walking,
  attacking,
  shot1,
  shot2,
}

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
  late SpriteAnimationComponent _idle2Animation;
  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _walkAnimation;
  late SpriteAnimationComponent _attackAnimation;
  late SpriteAnimationComponent _shot1Animation;
  late SpriteAnimationComponent _shot2Animation;

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
    log('🏹 Archer: Starting to load at position $position');

    try {
      // Load idle animation
      final idleAnimation = SpriteAnimation.fromFrameData(
        game.images.fromCache(Assets.images.archer.idle.path),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.15,
          textureSize: Vector2.all(128),
        ),
      );

      // Load idle2 animation
      final idle2Animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(Assets.images.archer.idle2.path),
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2.all(128),
          loop: false, // Should not loop - plays once and stops
        ),
      );

      // Load shot1 animation
      final shot1Animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(Assets.images.archer.shot1.path),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2.all(128),
          loop: false,
        ),
      );

      // Load shot2 animation
      final shot2Animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(Assets.images.archer.shot2.path),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2.all(128),
          loop: false,
        ),
      );

      // Create animation components
      _idleAnimation = SpriteAnimationComponent(
        animation: idleAnimation,
        size: size,
      );

      _idle2Animation = SpriteAnimationComponent(
        animation: idle2Animation,
        size: size,
      );

      _shot1Animation = SpriteAnimationComponent(
        animation: shot1Animation,
        size: size,
      );

      _shot2Animation = SpriteAnimationComponent(
        animation: shot2Animation,
        size: size,
      );

      // Start with idle animation
      await add(_idleAnimation);
      _currentAnimation = _idleAnimation;
      _currentState = ArcherAnimationState.idle;

      log(
        '🏹 Archer: Successfully loaded animations at '
        'position $position with size $size',
      );
    } catch (e) {
      log('🏹 Archer: Error loading: $e');
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
      case ArcherAnimationState.idle2:
        await add(_idle2Animation);
        _currentAnimation = _idle2Animation;
      case ArcherAnimationState.running:
        await add(_runAnimation);
        _currentAnimation = _runAnimation;
      case ArcherAnimationState.walking:
        await add(_walkAnimation);
        _currentAnimation = _walkAnimation;
      case ArcherAnimationState.attacking:
        await add(_attackAnimation);
        _currentAnimation = _attackAnimation;
      case ArcherAnimationState.shot1:
        await add(_shot1Animation);
        _currentAnimation = _shot1Animation;
      case ArcherAnimationState.shot2:
        await add(_shot2Animation);
        _currentAnimation = _shot2Animation;
    }

    _currentState = newState;
    _currentAnimation?.animationTicker?.reset();
  }

  /// Plays the shot animation and creates an arrow projectile
  Future<void> shootArrow() async {
    if (_currentState == ArcherAnimationState.shot1 ||
        _currentState == ArcherAnimationState.shot2) {
      return;
    }

    // Play shot1 animation
    await changeAnimationState(ArcherAnimationState.shot1);

    // Create arrow projectile after a brief delay
    Future.delayed(const Duration(milliseconds: 200), () {
      // Create arrow at archer's position with slight offset
      final arrowPosition = position.clone()
        ..add(Vector2(16, -2)); // Offset for bow position
      final arrow = Arrow.shootRight(startPosition: arrowPosition);

      // Add arrow to the game world (parent of parent to get to World)
      parent?.add(arrow);

      log('🏹 Arrow shot from position $arrowPosition');
    });

    // Return to idle2 after shot animation completes
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_currentState == ArcherAnimationState.shot1) {
        changeAnimationState(ArcherAnimationState.idle2);
      }
    });
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
