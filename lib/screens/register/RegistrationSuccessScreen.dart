import 'package:flutter/material.dart';

import '../HomeScreen.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Registration Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add navigation logic to move to another screen if needed
                // For example,
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home',)));
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home',)));
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}