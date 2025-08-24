import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:mood_surge/game/game.dart';
import 'package:mood_surge/gen/assets.gen.dart';

/// Handles tap interactions for the Archer character.
///
/// When tapped, the archer will play an attack animation and increment
/// the game counter, with sound feedback.
class ArcherInteractionBehavior extends Behavior<Archer>
    with TapCallbacks, HasGameReference<MoodSurge> {
  @override
  bool containsLocalPoint(Vector2 point) {
    return parent.containsLocalPoint(point);
  }

  @override
  void onTapDown(TapDownEvent event) {
    log('🏹 Archer tapped! Shooting arrow...');

    // Play arrow shooting animation and create arrow projectile
    parent.shootArrow();

    // Increment game counter for interaction feedback
    game.counter++;

    // Play sound effect
    game.effectPlayer.play(AssetSource(Assets.audio.effect));
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Optional: Add visual feedback on tap release
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    // Handle tap cancellation if needed
    super.onTapCancel(event);
  }
}
