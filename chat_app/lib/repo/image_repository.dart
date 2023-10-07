import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/image_model.dart';

class ImageRepository {
  Future<List<PixelfordImage>> getNetworkImages() async {
    var endPointUrl = Uri.parse("https://pixelford.com/api2/images");

    /// Bu API sayfası artık yok.
    final response = await http.get(endPointUrl);
    if (response.statusCode == 200) {
      final List<dynamic> decodedList = jsonDecode(response.body) as List;
      final List<PixelfordImage> _imageList = decodedList.map((listItem) {
        return PixelfordImage.fromJson(listItem);
      }).toList();
      print(_imageList[0].urlFullsize);
      return _imageList;
    } else {
      throw Exception("API not successful");
    }
  }
}
