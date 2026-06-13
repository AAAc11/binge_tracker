import 'dart:convert';
import 'package:http/http.dart' as http;
import 'show_repository.dart';

class ShowApiService {
  //pobieranie listy seriali z api
  static Future<List<Show>> fetchShows() async {
    final response = await http.get(Uri.parse("https://api.tvmaze.com/shows"));

    if (response.statusCode == 200) {
      //dekodowanie
      final List data = jsonDecode(response.body);

      //zamiana z json na show
      return data.map((json) {
        return Show(
          id: json["id"],
          name: json["name"],
          //sprawdzenie
          imageUrl: json["image"] != null ? json["image"]["medium"] : "",
          summary: json["summary"] ?? "Brak opisu",
          genres: (json["genres"] as List).join(", "),
        );
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych z serweru");
    }
  }
  static Future<Show> fetchShowDetails(int id) async {
    final response = await http.get(Uri.parse("https://api.tvmaze.com/shows/$id"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Show(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image"] != null ? json["image"]["medium"] : "",
        summary: json["summary"] ?? "Brak opisu",
        genres: (json["genres"] as List).join(", "),
      );
    } else {
      throw Exception("Błąd pobierania szczegółów serialu");
    }
  }
}