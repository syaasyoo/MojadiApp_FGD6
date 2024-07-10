class Product {
  final String title, description, image;
  final int id, price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  String toString() {
    return '{id: $id, title: $title, description: $description, price: $price, image: $image}';
  }
}
