import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mood_surge/app/app.dart';
import 'package:mood_surge/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await bootstrap(() => const App());
}
