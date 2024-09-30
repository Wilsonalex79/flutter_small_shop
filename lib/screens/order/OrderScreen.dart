import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {

  final String title;
  const OrderScreen({super.key,required this.title});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("OderScreen"),
      ),
    );
  }
}
