import 'package:flutter/material.dart';
import 'show_local_database.dart';
import 'show_repository.dart';
import 'details_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Show> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favorites = ShowLocalDatabase.getShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoja watchlista', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text("Brak zapisanych seriali"))
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final show = _favorites[index];
          return ListTile(
            title: Text(show.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDetailsScreen(show: show),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await ShowLocalDatabase.deleteShow(show.id);
                _loadFavorites();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(child: Text("Usunięto z Watchlisty")),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}