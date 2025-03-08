/// <----- main.dart ----->
///
library;

import 'package:flutter/material.dart';
import 'package:supabase_db_basics_app/note_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  /// supabase setup
  await Supabase.initialize(
    url:"https://hvissoztcwbxvallnjjg.supabase.co",
    anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2aXNzb3p0Y3dieHZhbGxuampnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAzMTUyMjUsImV4cCI6MjA1NTg5MTIyNX0.p7m8KFjYgFf91yoCjAgzcz-CEYYluS0whs9r77BGLTU",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotePage(),
    );
  }
}
