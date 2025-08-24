import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';
import 'package:mood_surge/app/app.dart';
import 'package:mood_surge/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await bootstrap(() => const App());
}
