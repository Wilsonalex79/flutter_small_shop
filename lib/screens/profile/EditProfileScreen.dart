import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../../services/AuthProvider.dart';

class EditProfileScreen extends StatefulWidget {
  final String title;

  const EditProfileScreen({Key? key, required this.title}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final storage = FlutterSecureStorage();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late DeviceInfoPlugin deviceInfo;
  String _deviceName = '';

  @override
  void initState() {
    super.initState();
    deviceInfo = DeviceInfoPlugin();
    readToken();
    getDeviceName();
  }

  void readToken() async {
    try {
      dynamic token = await storage.read(key: 'token');

      if (token != null) {
        String tokenString = token as String;

        Provider.of<AuthProvider>(context, listen: false).tryToken(token: tokenString);

        print("read token");
        print(tokenString);
      } else {
        print("Token is null");
      }
    } catch (e) {
      print("Error reading token: $e");
    }
  }

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
      print("Error getting device name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (auth.authenticated) {
              _nameController.text = auth.user?.name ?? '';
              _emailController.text = auth.user?.email ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> profileInfo = {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'device_name': _deviceName ?? 'unknown',
                      };

                      Provider.of<AuthProvider>(context, listen: false).updateProfile(profile_info: profileInfo);
                    },
                    child: Text('Update Profile'),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator(); // Add a loading indicator while authentication is in progress
            }
          },
        ),
      ),
    );
  }
}
