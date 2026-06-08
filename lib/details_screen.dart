import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'show_repository.dart';
import 'show_local_database.dart';

class ShowDetailsScreen extends StatelessWidget {
  final Show show;
  const ShowDetailsScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(show.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(show.imageUrl, fit: BoxFit.cover, height: 300, width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gatunki: ${show.genres}"),
                  Html(data: show.summary),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          show.isFavorite = true;
          await ShowLocalDatabase.addShow(show);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Zapisano do Watchlisty")));
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}