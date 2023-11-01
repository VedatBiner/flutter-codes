import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/image_model.dart';

class ImageRepository {
  Future<List<PixelfordImage>> getNetworkImages() async {
    try {
      var endPointUrl = Uri.parse("https://pixelford.com/api2/images");

      /// Bu API sayfası artık yok.
      final response = await http.get(endPointUrl);
      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(response.body) as List;
        final List<PixelfordImage> imageList = decodedList.map((listItem) {
          return PixelfordImage.fromJson(listItem);
        }).toList();
        print(imageList[0].urlFullsize);
        return imageList;
      } else {
        throw Exception("API not successful");
      }
    } on SocketException {
      throw Exception("No internet connection :(");
    } on HttpException {
      throw Exception("Could not retrieve the images! Sorry!");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      print(e);
      throw Exception("Unknown error !!!");
    }
  }
}
