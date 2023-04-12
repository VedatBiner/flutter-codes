import 'package:http/http.dart' as http;

class ProductApi{

  // API deki bütün ürünleri getirecek
  static Future getProducts(){
    return http.get(Uri.parse("http://10.0.2.2:3000/products"));
  }

  // API den kategori id ye göre ürün getirecek metot
  static Future getProductsByCategoryId(int categoryId){
    return http.get(Uri.parse("http://10.0.2.2:3000/products?categoryId=$categoryId"));
  }

}

