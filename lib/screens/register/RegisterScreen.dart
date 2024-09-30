import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/AuthProvider.dart';

import '../register/RegistrationSuccessScreen.dart';

class RegisterScreen extends StatefulWidget {
  final String title;

  const RegisterScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Get Device Info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String _deviceName = '';

  List<dynamic>? _errorText;

  void getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } catch (e) {
      print('Error getting device name: $e');
    }
  }

  @override
  void initState() {
    // Initial Data
    _nameController.text = 'prabhu';
    _emailController.text = "prabhu@gmail.com";
    _passwordController.text = "prabhu1234";

    getDeviceName();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (_errorText != null && _errorText is List<dynamic> && _errorText!.isNotEmpty) {
                    // print(_errorText[0]);
                    return _errorText?[0];
                  }
                  // Add email validation logic if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add password validation logic if needed
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    Map creds = {
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'device_name': _deviceName ?? 'unknown'
                    };

                    // Provider.of<AuthProvider>(context, listen: false)
                    //     .registerUser(creds: creds);

                    final result =
                        await authProvider.registerUser(creds: creds);

                    if (result['success']) {
                      // Registration successful
                      print('User registered successfully: ${result['data']}');

                      Provider.of<AuthProvider>(context, listen: false)
                          .login(creds: creds);

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationSuccessScreen()),
                      );
                    } else {

                      // print(result['success']);
                      // print(result['error']['email'][0]);

                      // Registration failed
                      if (result['error'] is Map<String, dynamic>) {
                        // Handle validation errors
                        final errors = result['error'] as Map<String, dynamic>;

                        setState(() {
                          _errorText = errors
                              .values.first; // Assuming there is only one error
                        });

                      print(_errorText?[0]);

                      } else {
                        // Display other error
                        setState(() {
                          _errorText = result['error'];
                        });
                        print('Registration failed: ${result['error']}');
                      }
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
