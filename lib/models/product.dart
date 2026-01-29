class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String? description;
  final Map<String, dynamic>? variants;
  int quantity;

  // User selection fields
  String? selectedColor;
  String? selectedSize;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.description,
    this.variants,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? "",
      description: json['description'],
      variants: json['variants'],
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'variants': variants,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    };
  }
}