import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'app.dart';
import 'core/services/background_worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  await BackgroundWorker.initializeAndSchedule();
  runApp(const ProviderScope(child: AdvMonApp()));
}
