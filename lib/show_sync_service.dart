import 'show_api_service.dart';
import 'show_discover_database.dart';
import 'show_repository.dart';

class ShowSyncService {
  //pierwsze ladowanie - jesli baza pusta, pobierz z API
  static Future<void> loadInitialDataIfNeeded() async {
    if (!ShowDiscoverDatabase.isEmpty()) {
      return;
    }
    final shows = await ShowApiService.fetchShows();
    await ShowDiscoverDatabase.saveShows(shows);
  }

  //manualne odswiezanie - pobranie z API
  static Future<List<Show>> refreshFromApi() async {
    final shows = await ShowApiService.fetchShows();
    await ShowDiscoverDatabase.saveShows(shows);
    return shows;
  }
}