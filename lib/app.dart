import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/enums/enums.dart';
import 'core/theme/app_theme.dart';
import 'features/components/presentation/component_detail_screen.dart';
import 'features/components/presentation/components_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/maintenance/presentation/maintenance_form_screen.dart';
import 'features/maintenance/presentation/maintenance_history_screen.dart';
import 'features/maintenance/presentation/maintenance_item_detail_screen.dart';
import 'features/maintenance/presentation/maintenance_screen.dart';
import 'features/motorcycle/presentation/motorcycle_edit_screen.dart';
import 'features/motorcycle/presentation/motorcycle_profile_screen.dart';
import 'features/odometer/presentation/odometer_screen.dart';
import 'features/parts/presentation/parts_screen.dart';
import 'features/reminders/presentation/reminders_screen.dart';
import 'features/reports/presentation/reports_screen.dart';
import 'features/settings/domain/app_settings.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/settings/presentation/settings_view_model.dart';
import 'shared/widgets/app_shell.dart';

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
            routes: [
              GoRoute(
                path: 'history',
                builder: (_, __) => const MaintenanceHistoryScreen(),
              ),
              GoRoute(
                path: 'item/:itemId',
                builder: (_, state) => MaintenanceItemDetailScreen(
                  itemId:
                      int.tryParse(state.pathParameters['itemId'] ?? '') ?? 0,
                ),
              ),
              GoRoute(
                path: 'record',
                builder: (_, state) {
                  final actionParam = state.uri.queryParameters['action'];
                  MaintenanceAction? initialAction;
                  if (actionParam != null && actionParam.isNotEmpty) {
                    try {
                      initialAction = MaintenanceAction.fromCode(actionParam);
                    } catch (_) {}
                  }
                  return MaintenanceFormScreen(
                    initialItemId:
                        int.tryParse(state.uri.queryParameters['itemId'] ?? ''),
                    initialAction: initialAction,
                    initialOdometerKm:
                        int.tryParse(state.uri.queryParameters['km'] ?? ''),
                    editRecordId:
                        int.tryParse(state.uri.queryParameters['edit'] ?? ''),
                  );
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/components',
            builder: (_, __) => const ComponentsScreen(),
            routes: [
              GoRoute(
                path: ':slug',
                builder: (_, state) => ComponentDetailScreen(
                  slug: state.pathParameters['slug'] ?? '',
                ),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/reports',
            builder: (_, __) => const ReportsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/odometer',
      builder: (_, __) => const OdometerScreen(),
    ),
    GoRoute(
      path: '/parts',
      builder: (_, __) => const PartsScreen(),
    ),
    GoRoute(
      path: '/reminders',
      builder: (_, __) => const RemindersScreen(),
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

class AdvMonApp extends ConsumerWidget {
  const AdvMonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
    return MaterialApp.router(
      title: 'ADV-MON',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
    );
  }
}
