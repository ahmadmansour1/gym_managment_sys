import 'package:flutter/material.dart';

import 'core/di/app_container.dart';
import 'presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = AppContainer.bootstrap();
  runApp(GymApp(container: container));
}
