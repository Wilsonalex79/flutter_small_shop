import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cart Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample JSON response
  final Map<String, dynamic> jsonResponse = {
    "cartItems": [
      {"id": 1, "name": "Product 1", "price": 19.99, "quantity": 2},
      {"id": 2, "name": "Product 2", "price": 29.99, "quantity": 1},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: jsonResponse['cartItems'].length,
        itemBuilder: (context, index) {
          var item = jsonResponse['cartItems'][index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Price: \$${item['price']} | Quantity: ${item['quantity']}'),
            // Add additional UI elements as needed (e.g., image, buttons)
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: \$${calculateTotal(jsonResponse['cartItems'])}'),
              ElevatedButton(
                onPressed: () {
                  // Implement checkout logic
                  // You can navigate to a checkout screen or perform any other actions
                },
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotal(List<dynamic> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }
}
