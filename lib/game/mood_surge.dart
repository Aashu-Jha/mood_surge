import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:mood_surge/game/game.dart';
import 'package:mood_surge/l10n/l10n.dart';

class MoodSurge extends FlameGame {
  MoodSurge({
    required this.l10n,
    required this.effectPlayer,
    required this.textStyle,
    required Images images,
  }) {
    this.images = images;
  }

  final AppLocalizations l10n;

  final AudioPlayer effectPlayer;

  final TextStyle textStyle;

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF2A48DF);

  @override
  Future<void> onLoad() async {
    log('🎮 Game: Creating game world components...');
    final archer = Archer(position: (size / 2)..sub(Vector2(30, 0)));
    final counter = CounterComponent(position: (size / 2)..sub(Vector2(0, 16)));

    log('🎮 Game: Archer created at ${archer.position}');
    log('🎮 Game: Counter created at ${counter.position}');

    final world = World(
      children: [
        // unicorn,
        archer,
        counter,
      ],
    );

    final camera = CameraComponent(world: world);
    await addAll([world, camera]);

    camera.viewfinder.position = size / 2;
    camera.viewfinder.zoom = 8;

    log('🎮 Game: Game loaded successfully. Screen size: $size');
    log(
      '🎮 Game: Camera position: ${camera.viewfinder.position}, zoom: ${camera.viewfinder.zoom}',
    );
  }
}
