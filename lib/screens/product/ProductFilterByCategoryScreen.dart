import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_small_shop/services/CartProvider.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/Category.dart';
import '../../models/Product.dart';
import '../../util/Constants.dart';

class ProductFilterByCategoryScreen extends StatefulWidget {

  final String title;
  final Category category;

  const ProductFilterByCategoryScreen({super.key, required this.title, required this.category});

  @override
  State<ProductFilterByCategoryScreen> createState() => _ProductFilterByCategoryScreenState();
}

class _ProductFilterByCategoryScreenState extends State<ProductFilterByCategoryScreen> {

  // Initialize categories as an empty list
  late List<Product> products = [];

  CartProvider cartProvider = CartProvider();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {

      // final category_id = widget.category.id.toString();

      final category_id = widget.category.id.toString();

      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.PRODUCT_FILTER_BY_CATEGORY_ROUTE + category_id));

      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          products = data.map((product) => Product.fromJson(product)).toList();
        });

      } else {

        throw Exception('Failed to load products ' + Constants.BASE_URL + Constants.PRODUCT_FILTER_BY_CATEGORY_ROUTE + category_id);

      }
    } catch (e) {
      print('Error: $e');
    }

  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: products.isEmpty // Check if genres is empty before accessing its elements
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].name),
              onTap: () {
                // navigateToProductScreen(categories[index]);
                Map carts = {
                  'product_id' : products[index].id,
                  // 'qty' : 3
                };

                print("Product Page Cart Content ${carts}");

                cartProvider.addToCart(carts: carts, context: context);

              },
            );
          },
        ),
      ),
    );
  }
}
