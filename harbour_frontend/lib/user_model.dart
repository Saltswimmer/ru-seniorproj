class Product {
  final int id;
  final String first_name;
  final String last_name;
  final String user_name;

  const Product({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.user_name,
  });


  factory Product.fromJson(Map json) {
    return Product(
      id: json['id'],
      name: json['first_name'],
      description: json['last_name'],
      price: json['user_name']
    );
  }
}