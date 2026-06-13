import 'package:flutter/material.dart';
import 'show_repository.dart';
import 'details_screen.dart';
import 'show_discover_database.dart';
import 'show_sync_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Show>> showsFuture;

  @override
  void initState() {
    super.initState();
    //ladowanie seriali
    showsFuture = loadShows();
  }

  //laduje z Hive albo pobiera z API jesli baza pusta
  Future<List<Show>> loadShows() async {
    try {
      await ShowSyncService.loadInitialDataIfNeeded();
    } catch (e) {
      //brak internetu przy pierwszym uruchomieniu - jesli baza ma dane - ignorowanie bledu
      if (ShowDiscoverDatabase.isEmpty()) {
        rethrow;
      }
    }
    return ShowDiscoverDatabase.getShows();
  }

  //funkcja odswiezania
  Future<void> _refreshData() async {
    setState(() {
      showsFuture = ShowSyncService.refreshFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odkrywaj seriale', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      //pociagniecie palcem w dol - odswiezenie
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Show>>(
          future: showsFuture,
          builder: (context, snapshot) {
            //ladowanie - krecace sie kolko
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            //obsluga bledu
            if (snapshot.hasError) {
              return Center(child: Text("Błąd: ${snapshot.error}"));
            }

            final shows = snapshot.data ?? [];
            //wyswietlanie siatki z plakatami
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //dwa plakaty w rzedzie
                childAspectRatio: 0.7, //proporcje
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowDetailsScreen(show: show),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        show.imageUrl.isNotEmpty
                            ? Image.network(
                          show.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  show.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                            : Container(
                          color: Colors.grey[800],
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              show.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}