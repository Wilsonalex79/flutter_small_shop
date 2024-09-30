import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/Brand.dart';
import '../../models/Product.dart';
import '../../services/CartProvider.dart';
import '../../util/Constants.dart';

class ProductFilterByBrandScreen extends StatefulWidget {

  final String title;
  final Brand brand;

  const ProductFilterByBrandScreen({super.key, required this.title, required this.brand});

  @override
  State<ProductFilterByBrandScreen> createState() => _ProductFilterByBrandScreenState();
}

class _ProductFilterByBrandScreenState extends State<ProductFilterByBrandScreen> {

  // Initialize categories as an empty list
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {

      // final brand_id = widget.brand.id.toString();

      final brand_id = widget.brand.id.toString();

      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.PRODUCT_FILTER_BY_BRAND_ROUTE + brand_id));

      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          products = data.map((product) => Product.fromJson(product)).toList();
        });

      } else {

        throw Exception('Failed to load products ' + Constants.BASE_URL + Constants.PRODUCT_FILTER_BY_BRAND_ROUTE + brand_id);

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
                  'product_id': products[index].id,
                };

                Provider.of<CartProvider>(context, listen: false).addToCart(carts: carts, context: context);
              },
            );
          },
        ),
      ),
    );
  }
}
