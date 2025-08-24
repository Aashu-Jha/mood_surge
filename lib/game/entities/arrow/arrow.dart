import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:mood_surge/gen/assets.gen.dart';

/// An Arrow projectile entity that flies across the screen.
class Arrow extends PositionedEntity with HasGameReference {
  Arrow({
    required super.position,
    required this.direction,
    this.speed = 300.0,
  }) : super(
         anchor: Anchor.center,
         size: Vector2(16, 4), // Adjust based on arrow sprite size
       );

  /// Creates an arrow shooting to the right
  factory Arrow.shootRight({required Vector2 startPosition}) {
    return Arrow(
      position: startPosition.clone(),
      direction: Vector2(1, 0), // Right direction
    );
  }

  /// Creates an arrow shooting to the left
  factory Arrow.shootLeft({required Vector2 startPosition}) {
    return Arrow(
      position: startPosition.clone(),
      direction: Vector2(-1, 0), // Left direction
    );
  }

  @visibleForTesting
  Arrow.test({
    required super.position,
    required this.direction,
    this.speed = 300.0,
    super.behaviors,
  }) : super(size: Vector2(16, 4));

  /// The direction the arrow is traveling
  final Vector2 direction;

  /// The speed of the arrow in pixels per second
  final double speed;

  late SpriteComponent _arrowSprite;

  @override
  Future<void> onLoad() async {
    try {
      // Load the arrow sprite
      final sprite = Sprite(
        game.images.fromCache(Assets.images.archer.arrow.path),
      );

      _arrowSprite = SpriteComponent(
        sprite: sprite,
        size: size,
      );

      await add(_arrowSprite);

      log('🏹 Arrow: Loaded at position $position');
    } catch (e) {
      log('🏹 Arrow: Error loading: $e');
      rethrow;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the arrow in the specified direction
    position.add(direction * speed * dt);

    // Remove arrow when it goes off screen
    if (position.x > game.size.x + 100 ||
        position.x < -100 ||
        position.y > game.size.y + 100 ||
        position.y < -100) {
      removeFromParent();
    }
  }
}
