import 'package:flutter_test/flutter_test.dart';

import 'package:pegadas_na_pista/core/di/injection_container.dart';
import 'package:pegadas_na_pista/main.dart';

void main() {
  testWidgets('App boots to the trail list page', (WidgetTester tester) async {
    await initDependencies();
    await tester.pumpWidget(const PegadasNaPistaApp());
    await tester.pump();

    expect(find.text('Pegadas na Pista'), findsOneWidget);
  });
}
