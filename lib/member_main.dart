import 'package:flutter/material.dart';

import 'core/di/app_container.dart';
import 'presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GymApp(container: AppContainer.bootstrap()));
}
