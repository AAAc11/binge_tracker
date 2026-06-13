import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await Hive.initFlutter();
  await Hive.openBox("shows");
  await Hive.openBox("discover");

  runApp(const BingeTrackerApp());
}

//główny widżet aplikacji
class BingeTrackerApp extends StatelessWidget {
  const BingeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binge Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, //ciemny motyw
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}