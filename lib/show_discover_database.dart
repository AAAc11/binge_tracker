import 'package:hive_ce/hive.dart';
import 'show_repository.dart';

class ShowDiscoverDatabase {
  static Box get _box => Hive.box("discover");

  static List<Show> getShows() {
    return _box.values.map((item) {
      return Show.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  static Future<void> saveShows(List<Show> shows) async {
    await _box.clear();
    for (final show in shows) {
      await _box.put(show.id, show.toMap());
    }
  }

  static bool isEmpty() {
    return _box.isEmpty;
  }
}