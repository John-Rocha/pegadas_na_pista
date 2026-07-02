import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const PegadasNaPistaApp());
}

class PegadasNaPistaApp extends StatelessWidget {
  const PegadasNaPistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pegadas na Pista',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
