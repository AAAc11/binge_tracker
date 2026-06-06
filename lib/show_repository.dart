class Show {
  final int id;
  final String name;
  final String imageUrl;
  final String summary; //fabuła
  final String genres;  //gatunek
  bool isFavorite;      //ulubione
  final bool isCustom;  //własny serial

  Show({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.summary,
    required this.genres,
    this.isFavorite = false,
    this.isCustom = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "summary": summary,
      "genres": genres,
      "isFavorite": isFavorite,
      "isCustom": isCustom,
    };
  }

  factory Show.fromMap(Map map) {
    return Show(
      id: map["id"],
      name: map["name"],
      imageUrl: map["imageUrl"],
      summary: map["summary"],
      genres: map["genres"],
      isFavorite: map["isFavorite"] ?? false,
      isCustom: map["isCustom"] ?? false,
    );
  }
}