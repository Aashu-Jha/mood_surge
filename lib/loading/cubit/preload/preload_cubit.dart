import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/cache.dart';
import 'package:flutter/widgets.dart';
import 'package:mood_surge/gen/assets.gen.dart';

part 'preload_state.dart';

class PreloadCubit extends Cubit<PreloadState> {
  PreloadCubit(this.images, this.audio) : super(const PreloadState.initial());

  final Images images;
  final AudioCache audio;

  /// Load items sequentially allows display of what is being loaded
  Future<void> loadSequentially() async {
    final phases = [
      PreloadPhase(
        'audio',
        () => audio.loadAll([Assets.audio.background, Assets.audio.effect]),
      ),
      PreloadPhase(
        'images',
        () => images.loadAll([
          Assets.images.unicornAnimation.path,
          Assets.images.archer.idle.path,
          Assets.images.archer.run.path,
          Assets.images.archer.walk.path,
          Assets.images.archer.attack1.path,
          Assets.images.archer.shot1.path,
          Assets.images.archer.shot2.path,
        ]),
      ),
    ];

    emit(state.copyWith(totalCount: phases.length));
    for (final phase in phases) {
      emit(state.copyWith(currentLabel: phase.label));
      // Throttle phases to take at least 1/5 seconds
      await Future.wait([
        Future.delayed(Duration.zero, phase.start),
        Future<void>.delayed(const Duration(milliseconds: 200)),
      ]);
      emit(state.copyWith(loadedCount: state.loadedCount + 1));
    }
  }
}

@immutable
class PreloadPhase {
  const PreloadPhase(this.label, this.start);

  final String label;
  final ValueGetter<Future<void>> start;
}
