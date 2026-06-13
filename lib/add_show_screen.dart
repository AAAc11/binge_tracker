import 'package:flutter/material.dart';
import 'show_repository.dart';
import 'show_local_database.dart';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';

class AddShowScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  AddShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj serial', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Tytuł")),
            TextField(controller: genreController, decoration: const InputDecoration(labelText: "Gatunek")),
            TextField(controller: summaryController, decoration: const InputDecoration(labelText: "Opis")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newShow = Show(
                  id: -Random().nextInt(1000000) - 1, //ujemne ID - unikalne wzgledem API
                  name: nameController.text,
                  imageUrl: "",
                  summary: summaryController.text,
                  genres: genreController.text,
                  isCustom: true,
                );
                await ShowLocalDatabase.addShow(newShow);

                //Event 3 - rejestrowanie utworzenia wlasnego serialu
                await FirebaseAnalytics.instance.logEvent(
                  name: "custom_show_created",
                  parameters: {
                    "show_name": newShow.name,
                  },
                );

                nameController.clear();
                genreController.clear();
                summaryController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text("Dodano serial"),
                    ),
                  ),
                );
              },
              child: const Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}