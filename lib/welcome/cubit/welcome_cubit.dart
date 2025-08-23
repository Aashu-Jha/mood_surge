import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(const WelcomeState());

  Future<void> playPressed() async {
    // Start fading animation
    emit(state.copyWith(status: WelcomeStatus.fading, opacity: 0.7));
    
    // Brief pause for visual feedback
    await Future<void>.delayed(const Duration(milliseconds: 150));
    
    // Set navigating status
    emit(state.copyWith(status: WelcomeStatus.navigating));
  }

  void resetFade() {
    if (state.status != WelcomeStatus.navigating) {
      emit(state.copyWith(status: WelcomeStatus.initial, opacity: 1));
    }
  }
}
