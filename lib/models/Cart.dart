import 'Product.dart';

class Cart {

  int id;
  int customer_id;
  int product_id;
  int qty;
  Product product; // Add a reference to the Product class


  Cart({
    required this.id,
    required this.customer_id,
    required this.product_id,
    required this.qty,
    required this.product, // Update the constructor to accept a Product object
  });

  Cart.fromJson(Map<String, dynamic> json):
        id = json['id'],
        customer_id = json['customer_id'],
        product_id = json['product_id'],
        qty = json['qty'],
        product = Product.fromJson(json['product']); // Parse 'product' field using Product.fromJson
}