/// <----- main.dart ----->
///
import 'package:firebase_auth_fs_app/pages/home_page.dart';
import 'package:firebase_auth_fs_app/pages/vb_home.dart';
import 'package:firebase_auth_fs_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_fs_app/firebase_options.dart';

import '../pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var isUserNull = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth İşlemleri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(width: 1),
          ),
        ),
      ),
      home: isUserNull == null ? LoginPage() : const VBHome(),
    );
  }
}
