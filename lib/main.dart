import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_small_shop/screens/HomeScreen.dart';
import 'package:flutter_small_shop/services/AuthProvider.dart';
import 'package:flutter_small_shop/services/CartProvider.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  // runApp(MyApp());

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),  // Add CartProvider
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(title: 'Home',),
    );
  }
}

