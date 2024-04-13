import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_template/main.dart';
import 'package:starter_template/screen/pagination/pagination_bloc.dart';
import 'package:starter_template/screen/pagination/pagination_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirectLimit: 1,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
      routes: [
        GoRoute(
          path: 'setting',
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          path: 'pagination',
          builder: (context, state) {
            const screen = PaginationExample();
            return BlocProvider(
              lazy: true,
              create: (context) => PaginationBloc(),
              child: screen,
            );
          },
        ),
      ],
    ),
  ],
);
