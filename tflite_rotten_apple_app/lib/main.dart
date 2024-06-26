/// <----- main.dart ----->
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'model.dart';

List <CameraDescription>? camera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera=await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Model(),
    );
  }
}
