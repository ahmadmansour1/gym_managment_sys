import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'admin/admin_app.dart';
import 'core/di/app_container.dart';
import 'presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = AppContainer.bootstrap();
  runApp(
    kIsWeb ? AdminApp(container: container) : GymApp(container: container),
  );
}
