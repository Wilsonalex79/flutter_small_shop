import 'package:flutter/material.dart';
import 'package:flutter_small_shop/screens/HomeScreen.dart';
import 'package:flutter_small_shop/screens/profile/EditProfileScreen.dart';
import 'package:flutter_small_shop/screens/profile/ProfileImageUploadScreen.dart';
import 'package:flutter_small_shop/services/AuthProvider.dart';
import 'package:provider/provider.dart';

import '../../util/Constants.dart';

class ProfileScreen extends StatefulWidget {
  final String title;

  const ProfileScreen({super.key, required this.title});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            // Use Consumer to rebuild the widget when authentication state changes.
            child: Consumer<AuthProvider>(
              builder: (context, auth, child) {
                String avatar = auth.user?.avatar ?? '';
                String name = auth.user?.name ?? '';
                String email = auth.user?.email ?? '';
                String photo_path = auth.user?.photo_path ?? '';

                return auth.authenticated
                    ? ProfileWidget(
                        name: name,
                        email: email,
                        imageUrl: photo_path != '' && photo_path != Constants.IMAGE_ERROR_ROUTE ? photo_path : avatar
                      )
                    : Text(
                        'User not authenticated'); // Handle unauthenticated state.
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;

  ProfileWidget({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8, // Adjust width as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(width: 2),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileImageUploadScreen(title: 'Profile')),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            email,
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              // Navigate to edit profile screen

              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(title: 'Profile')),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit),
                SizedBox(width: 5),
                Text('Edit Profile >'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  // Navigate to certificates screen
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description),
                    SizedBox(width: 5),
                    Text('View Certificates >'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to support screen
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.support),
                    SizedBox(width: 5),
                    Text('Support >'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to feedback screen
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.feedback),
                    SizedBox(width: 5),
                    Text('Feedback >'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to rewards screen
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 5),
                    Text('Rewards >'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 120.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.blue,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () {
                  // Add logout functionality
                  Provider.of<AuthProvider>(context, listen: false).logout();

                  Navigator.pop(context);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(title: 'Home')),
                  );
                },
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
