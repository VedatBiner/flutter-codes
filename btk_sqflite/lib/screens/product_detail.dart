import 'package:btk_sqflite/screens/product_list.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utilities/productdao.dart';

class ProductDetail extends StatefulWidget {
  Product product;
  ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // text editing controller
  var tfProductName = TextEditingController();
  var tfProductDescription = TextEditingController();
  var tfProductUnitPrice = TextEditingController();

  // açılışta çalışacak metod
  @override
  void initState() {
    super.initState();
    var product = widget.product;
    tfProductName.text = product.name;
    tfProductDescription.text = product.description;
    tfProductUnitPrice.text = product.unitPrice.toString();
  }

  // Ürün güncelleme metodu
  Future<void> guncelle(
      int id, String name, String description, double unitPrice) async {
    await Productdao().updateRecord(id, name, description, unitPrice);
    // kayıt sonrası ana sayfaya geçiş
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ürün Detay Sayfası")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfProductName,
                decoration: const InputDecoration(
                  hintText: "Kişi Adı",
                ),
              ),
              TextField(
                controller: tfProductDescription,
                decoration: const InputDecoration(
                  hintText: "Kişi Telefonu",
                ),
              ),
              TextField(
                controller: tfProductUnitPrice,
                decoration: const InputDecoration(
                  hintText: "Kişi Telefonu",
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          guncelle(
            widget.product.id,
            tfProductName.text,
            tfProductDescription.text,
            double.parse(tfProductUnitPrice.text),
          );
        },
        tooltip: 'Kişi Güncelle',
        icon: const Icon(Icons.update),
        label: const Text("Güncelle"),
      ),
    );
  }
}
