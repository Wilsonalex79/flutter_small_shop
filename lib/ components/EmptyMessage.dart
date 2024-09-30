import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;

  // Constructor to receive the message as an argument
  const EmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }
}
