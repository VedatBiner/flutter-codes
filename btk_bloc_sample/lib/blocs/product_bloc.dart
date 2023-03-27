import 'dart:async';
import '../data/product_service.dart';
import '../models/product.dart';

class ProductBloc {
  final productStreamController = StreamController.broadcast();
  Stream get getStream => productStreamController.stream;
  List<Product> getAll(){
    return ProductService.getAll();
  }
}

// Bu referans ile tüm sistemden erişim sağlanacak.
final productBloc = ProductBloc();

