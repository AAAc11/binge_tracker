import 'package:flutter/material.dart';
import 'show_repository.dart';
import 'show_local_database.dart';
import 'show_api_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ShowDetailsScreen extends StatefulWidget {
  final Show show;
  const ShowDetailsScreen({super.key, required this.show});

  @override
  State<ShowDetailsScreen> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {
  late Future<Show> showFuture;

  @override
  void initState() {
    super.initState();

    if (widget.show.isCustom) {
      showFuture = Future.value(widget.show);
    } else {
      showFuture = ShowApiService.fetchShowDetails(widget.show.id);
    }

    //Event 1 - rejestrowanie obejrzenie szczegolow
    FirebaseAnalytics.instance.logEvent(
      name: "show_details_viewed",
      parameters: {
        "show_id": widget.show.id,
        "show_name": widget.show.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.show.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Show>(
        future: showFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final show = snapshot.data ?? widget.show;

          return SingleChildScrollView(
            child: Column(
              children: [
                show.imageUrl.isNotEmpty
                    ? Image.network(
                  show.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.movie, size: 80, color: Colors.white54),
                      ),
                    );
                  },
                )
                    : Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.movie, size: 80, color: Colors.white54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //gatunki
                      const Text(
                        "Gatunki",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        show.genres.isNotEmpty ? show.genres : "Brak informacji",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),

                      //opis
                      const Text(
                        "Opis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        show.summary.replaceAll(RegExp(r'<[^>]*>'), ''),
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final showToSave = widget.show;
          showToSave.isFavorite = true;
          await ShowLocalDatabase.addShow(showToSave);

          //Event 2 - rejestrowanie dodania do listy
          await FirebaseAnalytics.instance.logEvent(
            name: "show_added_to_watchlist",
            parameters: {
              "show_id": showToSave.id,
              "show_name": showToSave.name,
            },
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text("Zapisano do Watchlisty"),
              ),
            ),
          );
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}