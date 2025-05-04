class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final List<String> imageUrls;
  final String description;
  final double rating;
  final List<String> sizes;
  final List<String> colors;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrls,
    required this.description,
    required this.rating,
    required this.sizes,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        category: json['category'] as String,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String,
        imageUrls: List<String>.from(json['imageUrls'] as List),
        rating: (json['rating'] as num).toDouble(),
        sizes: List<String>.from(json['sizes'] as List),
        colors: List<String>.from(json['colors'] as List),
      );
}
