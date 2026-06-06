import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox("shows");

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
      home: const HomeScreen(),
    );
  }
}

//homescreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binge Tracker'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TEST',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}