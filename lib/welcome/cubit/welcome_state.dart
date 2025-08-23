part of 'welcome_cubit.dart';

enum WelcomeStatus {
  initial,
  fading,
  navigating,
}

class WelcomeState extends Equatable {
  const WelcomeState({
    this.status = WelcomeStatus.initial,
    this.opacity = 1.0,
  });

  final WelcomeStatus status;
  final double opacity;

  WelcomeState copyWith({
    WelcomeStatus? status,
    double? opacity,
  }) {
    return WelcomeState(
      status: status ?? this.status,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  List<Object> get props => [status, opacity];
}
