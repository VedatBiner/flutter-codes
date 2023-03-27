import 'dart:async';
import '../data/cart_service.dart';
import '../models/cart.dart';

class CartBloc{
  // Çalışma anında bu değer oluşuyor. Daha sonra bu değer değiştirilemiyor.
  // referansın içindeki değer değiştirilebiliyor.
  final cartStreamController = StreamController.broadcast();

  // getter
  Stream get getStream => cartStreamController.stream;

  void addToCart(Cart item){
    CartService.addToCart(item);
    // bu event 'i kullanan yerlerin build operasyonunu sink ile çalıştırıyoruz.
    // sink ile stream uyandırılıyor.
    cartStreamController.sink.add(CartService.getCart());
  }

  void removeFromCart(Cart item){
    CartService.removeFromCart(item);
    cartStreamController.sink.add(CartService.getCart());
  }

  // Tüm sepeti döndürüyor.
  List<Cart> getCart(){
    return CartService.getCart();
  }
}

final cartBloc = CartBloc();

