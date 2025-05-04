class Place {
  String? id;
  String name;
  String location;
  String category;
  String description;
  String detail;
  double rating;
  List<String> images;

  Place({
    this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.description,
    required this.detail,
    required this.rating,
    required this.images,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    // raw list from JSON (may contain encoded paths or backslashes)
    final rawImages = List<String>.from(json['images'] ?? []);

    // clean them up:
    final cleanImages =
        rawImages.map((s) {
          // turn any backslashes into slashes (Windows → Flutter)
          final withSlashes = s.replaceAll(r'\', '/');
          // decode any %20 or %2520 sequences into real spaces
          return Uri.decodeFull(withSlashes);
        }).toList();

    return Place(
      id: json['id'] as String?,
      name: json['name'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      detail: json['detail'] as String,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      images: cleanImages, // use the cleaned list
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'category': category,
      'description': description,
      'detail': detail,
      'rating': rating.toString(),
      'images': images,
    };
  }
}
