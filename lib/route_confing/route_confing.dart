import 'package:go_router/go_router.dart';
import 'package:starter_template/main.dart';

final router = GoRouter(
  errorBuilder: (context, state) => const MyHomePage(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingScreen(),
    ),
  ],
);
