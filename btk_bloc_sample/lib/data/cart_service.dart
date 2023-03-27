import '../models/cart.dart';

class CartService {
  static List<Cart> cartItems = <Cart>[];

  static final CartService _singleton = CartService._internal();

  factory CartService(){
    return _singleton;
  }

  CartService._internal();

  // sepete ekleme
  static void addToCart(Cart item){
    cartItems.add(item);
  }

  // sepetten çıkarma
  static void removeFromCart(Cart item){
    cartItems.remove(item);
  }

  // sepete ekleme
  static List<Cart> getCart(){
    return cartItems;
  }

}

