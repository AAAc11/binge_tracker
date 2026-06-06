import 'package:hive_ce/hive.dart';
import 'show_repository.dart';

class ShowLocalDatabase {
  static Box get _box => Hive.box("shows");

  //pobieranie zapisanych seriali
  static List<Show> getShows() {
    return _box.values.map((item) {
      //zamiana z map na show
      return Show.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  //dodawanie serialu do bazy (serduszko/własny)
  static Future<void> addShow(Show show) async {
    await _box.put(show.id, show.toMap());
  }

  //aktualizacja serialu w bazie (odznaczenie serduszka)
  static Future<void> updateShow(Show show) async {
    await _box.put(show.id, show.toMap());
  }

  //usuwanie serialu z bazy po ID
  static Future<void> deleteShow(int id) async {
    await _box.delete(id);
  }
}