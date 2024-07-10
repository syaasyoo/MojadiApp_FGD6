class Category {
  final String name, image;
  final int id;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  String toString() {
    return '{id: $id, name: $name, image: $image}';
  }
}
