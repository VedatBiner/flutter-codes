import 'package:flutter/material.dart';
import '../screens/product_detail.dart';
import '../screens/product_record.dart';
import '../models/product.dart';
import '../utilities/productdao.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // tüm Ürün listesine erişelim
  Future<List<Product>> showAllProducts() async {
    var liste = await Productdao().getProducts();
    return liste;
  }

  // silme metodu
  Future<void> sil(int id) async {
    await Productdao().deleteRecord(id);
  }

  @override
  void initState() {
    super.initState();
    showAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Listesi"),
      ),
      body: buildAllProducts(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  // Tüm ürünlerin listelendiği ilk sayfa
  FutureBuilder<List<Product>> buildAllProducts() {
    return FutureBuilder<List<Product>>(
      future: showAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var urunlerListesi = snapshot.data;
          return ListView.builder(
            itemCount: urunlerListesi!.length,
            itemBuilder: (context, index) {
              var product = urunlerListesi[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(product: product),
                    ),
                  );
                },
                child: Card(
                  color: Colors.cyan,
                  elevation: 2.0,
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(product.description),
                        Text(product.unitPrice.toStringAsFixed(2)),
                        buildIconButton(product),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // veri gelmediyse boş bir tasarım göstersin
          return const Center(
            child: Text("*** HATA ***"),
          );
        }
      },
    );
  }

  // Ekleme düğmesi
  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductRecord(),
          ),
        );
      },
      tooltip: 'Ürün Ekle',
      child: const Icon(Icons.add),
    );
  }

  // Silme düğmesi
  IconButton buildIconButton(Product product) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
      onPressed: () {
        sil(product.id);
        setState(() {});
      },
    );
  }
}
