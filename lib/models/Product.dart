class Product {

  int id;
  String name;
  // String? imageUrl;
  String description;
  String price;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price
  });

  Product.fromJson(Map<String, dynamic> json):
      id = json['id'],
      name = json['name'],
      description = json['description'],
      price = json['price'];
}