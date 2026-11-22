class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String brand;
  final List<dynamic> tags;
  final List<dynamic> images;
  final List<dynamic> reviews;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.rating = 0,
    this.stock = 0,
    this.brand = '',
    this.tags = const [],
    this.images = const [],
    this.reviews = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',
      tags: json['tags'] ?? [],
      images: json['images'] ?? [],
      reviews: json['reviews'] ?? [],
    );
  }
}
