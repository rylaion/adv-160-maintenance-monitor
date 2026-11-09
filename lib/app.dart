import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/maintenance/presentation/maintenance_screen.dart';
import 'features/motorcycle/presentation/motorcycle_edit_screen.dart';
import 'features/odometer/presentation/odometer_screen.dart';
import 'features/motorcycle/presentation/motorcycle_profile_screen.dart';
import 'shared/widgets/app_shell.dart';
import 'shared/widgets/coming_soon_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/maintenance',
            builder: (_, __) => const MaintenanceScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/components',
            builder: (_, __) =>
                const ComingSoonScreen(title: 'Components', phase: 3),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/reports',
            builder: (_, __) =>
                const ComingSoonScreen(title: 'Reports', phase: 4),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            builder: (_, __) =>
                const ComingSoonScreen(title: 'Settings', phase: 5),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/odometer',
      builder: (_, __) => const OdometerScreen(),
    ),
    GoRoute(
      path: '/motorcycle',
      builder: (_, __) => const MotorcycleProfileScreen(),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (_, __) => const MotorcycleEditScreen(),
        ),
      ],
    ),
  ],
);

class AdvMonApp extends StatelessWidget {
  const AdvMonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ADV-MON',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
