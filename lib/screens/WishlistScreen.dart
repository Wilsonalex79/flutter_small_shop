import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {

  final String title;
  const WishlistScreen({super.key,required this.title});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Wishlist'),
      ),
    );
  }
}
