import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_list_row_widget.dart';

class ProductListWidget extends StatefulWidget{

  List<Product> products = <Product>[]; // ilk açılış için sıfırladık
  ProductListWidget(this.products, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductListWidgetState();
  }
}

class ProductListWidgetState extends State<ProductListWidget>{

  @override
  Widget build(BuildContext context) {
    return buildProductList(context); // context cihaz boyutları alınıyor.
  }
  Widget buildProductList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
          SizedBox(
            height: 500.0,
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                widget.products.length,
                (index){
                  return ProductListRowWidget(widget.products[index]);
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}


