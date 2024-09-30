import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_small_shop/screens/profile/ProfileScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../services/AuthProvider.dart';
import '../HomeScreen.dart';

class ProfileImageUploadScreen extends StatefulWidget {

  final String title;

  const ProfileImageUploadScreen({super.key, required this.title});

  @override
  ProfileImageUploadScreenState createState() => ProfileImageUploadScreenState();
}

class ProfileImageUploadScreenState extends State<ProfileImageUploadScreen> {
  File? imageFile;

  // Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to upload the selected image
  Future<void> _uploadImage(BuildContext context) async {
    if (imageFile != null) {
      // Access the AuthProvider provider
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Call the uploadProfilePicture method
      await authProvider.uploadProfilePicture(image: imageFile!);

      // Optionally, you can handle UI updates or show a message
      // based on the success or failure of the image upload.

      // Show a Snackbar on success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image successfully updated.'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(title: 'Profile',)));

    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageFile == null
                ? Text('No image selected.')
                : Image.file(imageFile!, height: 150,),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadImage(context),
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
