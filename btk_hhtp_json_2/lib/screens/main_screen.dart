import 'dart:convert';
import 'package:flutter/material.dart';
import '../data.api/category_api.dart';
import '../data.api/product_api.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../widgets/product_list_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State {
  // API 'den veriyi kategoriye çekmek için liste
  List<Category> categories = <Category>[];
  // Categorileri buton olarak kullanmak için liste
  List<Widget> categoryWidgets = <Widget>[];
  // Ürün Listesi oluşturalım
  List<Product> products = <Product>[];

  @override
  void initState() {
    getCategoriesFromApi();
    // ilk açılışta ürünlerin hepsi listelensin
    getProducts();
    super.initState();
  }

  // API 'den kategorileri çekelim
  void getCategoriesFromApi() {
    CategoryApi.getCategories().then((response) {
      setState(() {
        // response json olarak geliyor
        // map formatına çevrilmesi gerekli
        Iterable list = json.decode(response.body);
        // kategorileri listeye çeviriyoruz
        categories =
            list.map((category) => Category.fromJson(category)).toList();
        // Kategori listesini buton haline getirmek
        getCategoryWidgets();
      });
    });
  }

  // buton listesi
  List<Widget> getCategoryWidgets() {
    for (int i = 0; i < categories.length; i++) {
      categoryWidgets.add(getCategoryWidget(categories[i]));
    }
    return categoryWidgets;
  }

  // buton oluşturan widget
  Widget getCategoryWidget(Category category) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Colors.green),
          ),
        ),
      ),
      onPressed: () {
        getProductsByCategoryId(category);
      },
      child: Text(
        category.categoryName!,
        style: const TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text(
          "Alışveriş Sistemi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoryWidgets,
                ),
              ),
              ProductListWidget(products),
            ],
          ),
        ),
      ),
    );
  }

  // Ürünleri kategorilere göre getiren metod
  void getProductsByCategoryId(Category category) {
    ProductApi.getProductsByCategoryId(category.id!).then((response) {
      setState((){
        // JSON formatından listeye çeviriyoruz
        Iterable list = jsonDecode(response.body);
        // her bir ürün için JON dn listeye çeviriyoruz
        products = list.map((product) => Product.fromJson(product)).toList();
      });
    });
  }

  void getProducts() {
    ProductApi.getProducts().then((response) {
      setState((){
        Iterable list = jsonDecode(response.body);
        products = list.map((product) => Product.fromJson(product)).toList();
      });
    });
  }

}






