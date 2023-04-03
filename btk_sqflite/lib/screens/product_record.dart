import 'package:flutter/material.dart';
import '../screens/product_list.dart';
import '../utilities/productdao.dart';

class ProductRecord extends StatefulWidget {
  const ProductRecord({Key? key}) : super(key: key);

  @override
  State<ProductRecord> createState() => _ProductRecordState();
}

class _ProductRecordState extends State<ProductRecord> {

  // text editing controller
  var tfProductName = TextEditingController();
  var tfProductDescription = TextEditingController();
  var tfProductUnitPrice = TextEditingController();

  // Ürün kayıt metodu
  Future<void> kayit(String name, String description, double unitPrice) async {
    await Productdao().insertRecord(name, description, unitPrice);
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
      appBar: AppBar(title: const Text("Ürün Kayıt Sayfası")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNameField(),
              buildDescriptionField(),
              buildUnitPriceField(),
            ],
          ),
        ),
      ),
      floatingActionButton: buildSaveFAB(),
    );
  }

  // Ürün adı giriş alanı
  TextField buildNameField() {
    return TextField(
      controller: tfProductName,
      decoration: const InputDecoration(
        hintText: "Ürün Adı",
      ),
    );
  }

  // Ürün açıklaması giriş alanı
  TextField buildDescriptionField() {
    return TextField(
      controller: tfProductDescription,
      decoration: const InputDecoration(
        hintText: "Ürün Detayı",
      ),
    );
  }

  // Ürün fiyatı giriş alanı
  TextField buildUnitPriceField() {
    return TextField(
      controller: tfProductUnitPrice,
      decoration: const InputDecoration(
        hintText: "Ürün birim fiyatı",
      ),
    );
  }

  // Save Düğmesi
  FloatingActionButton buildSaveFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        kayit(tfProductName.text, tfProductDescription.text,
            double.parse(tfProductUnitPrice.text));
      },
      tooltip: 'Kişi Kayıt',
      icon: const Icon(Icons.save),
      label: const Text("Kaydet"),
    );
  }

}
