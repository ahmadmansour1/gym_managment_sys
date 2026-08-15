import 'package:flutter_test/flutter_test.dart';
import 'package:gym_managment_system/core/di/app_container.dart';
import 'package:gym_managment_system/presentation/app.dart';

void main() {
  testWidgets('app starts', (tester) async {
    await tester.pumpWidget(GymApp(container: AppContainer.bootstrap()));
    await tester.pump();
  });
}
