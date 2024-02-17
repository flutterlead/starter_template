import 'package:go_router/go_router.dart';
import 'package:starter_template/main.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/pagination',
      builder: (context, state) => const PaginationExample(),
    ),
  ],
);
