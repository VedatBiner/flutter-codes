/// <----- model.dart ----->
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class Model extends StatefulWidget {
  const Model({super.key});

  @override
  State<Model> createState() => _ModelState();
}

class _ModelState extends State<Model> {
  late File _image;
  bool selImage = false;
  List result = [];

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rotten Apple Detection"),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Expanded(child: (selImage) ? Image.file(_image) : Container()),
            const SizedBox(height: 30),
            (result.isEmpty)
                ? Container()
                : Text(
                    result[0]['label'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
            InkWell(
              onTap: () {
                chooseFile();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigoAccent,
                ),
                child: const Text(
                  "Pick an Image",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseFile() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selImage = true;
      _image = File(image!.path);
    });
    predictImage(_image);
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  predictImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      result = output!;
    });
    print("result is : $result");
  }
}
