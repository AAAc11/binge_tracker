import 'package:flutter/material.dart';
import 'show_repository.dart';
import 'show_api_service.dart';

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
    showsFuture = ShowApiService.fetchShows();
  }

  //funkcja odswiezania
  Future<void> _refreshData() async {
    setState(() {
      showsFuture = ShowApiService.fetchShows();
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
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //zdjecie w tle
                      show.imageUrl.isNotEmpty
                          ? Image.network(show.imageUrl, fit: BoxFit.cover)
                          : const Icon(Icons.movie, size: 50),
                    ],
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