import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../../models/Product.dart';
import '../../util/Constants.dart';


class ProductScreen extends StatefulWidget {

  final String title;

  const ProductScreen({super.key, required this.title});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  // Initialize categories as an empty list
  late List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {

      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.PRODUCT_ROUTE));

      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          products = data.map((product) => Product.fromJson(product)).toList();
        });

      } else {

        throw Exception('Failed to load products ' + Constants.BASE_URL + Constants.PRODUCT_ROUTE);

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
              },
            );
          },
        ),
      ),
    );
  }
}