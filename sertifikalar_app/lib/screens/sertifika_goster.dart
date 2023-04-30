import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SertifikaGoster extends StatefulWidget {
  final String imageUrl;

  const SertifikaGoster({required this.imageUrl});

  @override
  _SertifikaGosterState createState() => _SertifikaGosterState();
}

class _SertifikaGosterState extends State<SertifikaGoster> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    await Future.delayed(const Duration(seconds: 30)); // Wait time (2 seconds)
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifika Goster'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show the progress indicator
            : Image.network(widget.imageUrl), // Load the image
      ),
    );
  }
}
