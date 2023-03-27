import '../models/product.dart';

class ProductService{
  static List<Product> products = <Product>[];

  // singleton - constructor çağırıyor.
  static final ProductService _singleton = ProductService._internal();
  // bu yapı bize Product(this.id, this.name, this.price) constructor 'ı çağırıyor.

  // Arka planda bir instance oluşturuyor. Bu yapıyı bellekte tutuyor.
  factory ProductService(){
    return _singleton;
  }


  ProductService._internal();

  static List<Product> getAll(){
    products.add(Product(1, "Acer Laptop", 6000));
    products.add(Product(2, "Asus Laptop", 7000));
    products.add(Product(3, "HP Laptop", 8000));
    return products;
  }
}

