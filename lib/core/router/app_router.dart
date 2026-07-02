import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/trail/presentation/pages/trail_list_page.dart';
import '../../features/trail/presentation/pages/trail_record_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'trails',
        builder: (context, state) => const TrailListPage(),
      ),
      GoRoute(
        path: '/trails/record',
        name: 'record-trail',
        builder: (context, state) => const TrailRecordPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
