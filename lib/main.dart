import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/app.dart';
import 'package:psycolor/services/credit_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('credits');
  await Hive.openBox('history');
  await Hive.openBox('hue_history');
  await Hive.openBox('mood_history');
  await CreditService(Hive.box('credits')).initialize();

  runApp(
    const ProviderScope(
      child: PsycolorApp(),
    ),
  );
}
