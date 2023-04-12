import 'package:http/http.dart' as http;

// tüm kategorileri listeleyelim
class CategoryApi{
  static Future getCategories(){
    return http.get(Uri.parse("http://10.0.2.2:3000/categories"));
  }
}


