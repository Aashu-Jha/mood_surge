import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_surge/game/game.dart';
import 'package:mood_surge/gen/assets.gen.dart';
import 'package:mood_surge/welcome/cubit/cubit.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeCubit, WelcomeState>(
      listenWhen: (previous, current) => 
          current.status == WelcomeStatus.navigating,
      listener: (context, state) {
        // Navigate to game with fade transition
        Navigator.of(context).pushReplacement<void, void>(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                const GamePage(),
            transitionsBuilder: 
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      },
      child: Scaffold(
        body: BlocBuilder<WelcomeCubit, WelcomeState>(
          builder: (context, state) {
            return AnimatedOpacity(
              opacity: state.opacity,
              duration: const Duration(milliseconds: 200),
              child: Stack(
                children: [
                  // Full-screen background image
                  Positioned.fill(
                    child: Assets.images.welcomeImg.image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Play button overlay
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _PlayButton(
                        onPressed: () => 
                            context.read<WelcomeCubit>().playPressed(),
                        isPressed: state.status == WelcomeStatus.fading,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  const _PlayButton({
    required this.onPressed,
    required this.isPressed,
  });

  final VoidCallback onPressed;
  final bool isPressed;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isPressed || _isHovered
                ? [
                    const Color(0xFFFF6B35).withValues(alpha: 0.8),
                    const Color(0xFFFF8E3C).withValues(alpha: 0.8),
                  ]
                : [
                    const Color(0xFFFF6B35),
                    const Color(0xFFFF8E3C),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Play',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
