import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SertifikaGoster extends StatelessWidget {
  final String url;

  const SertifikaGoster({Key? key, required this.url}) : super(key: key);

  void _openUrl() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifika Görüntüleme'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _openUrl,
          child: Image.network(
            url,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null)
                return child;
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Text('Resim yüklenirken bir hata oluştu.');
            },
          ),
        ),
      ),
    );
  }
}
