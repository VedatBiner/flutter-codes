import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';
import 'package:sqflite_crud_2/screens/add_edit_product.dart';
import '../models/product_model.dart';
import '../services/dbservices.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBService dbService = DBService();

  @override
  void initState() {
    super.initState();
    dbService = DBService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("SQFLITE CRUD"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FormHelper.submitButton("Add Product", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditProductPage(),
                  ),
                );
              },
                  borderRadius: 10,
                  btnColor: Colors.lightBlue,
                  borderColor: Colors.lightBlue),
            ),
            const SizedBox(
              height: 10,
            ),
            _fetchData(),
          ],
        ),
      ),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<ProductModel>>(
      future: dbService.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
        if (products.hasData) {
          return _buildDataTable(products.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildUI(List<ProductModel> products) {
    List<Widget> widgets = <Widget>[];

    widgets.add(
      Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditProductPage(),
              ),
            );
          },
          child: Container(
            height: 40.0,
            width: 100,
            color: Colors.blueAccent,
            child: const Center(
              child: Text(
                "Add Product",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(products)],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget _buildDataTable(List<ProductModel> model) {
    return ListUtils.buildDataTable(
      context,
      ["Product Name", "Price", ""],
      ["productName", "price", ""],
      false,
      0,
      model,
      (ProductModel data) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditProductPage(
              isEditMode: true,
              model: data,
            ),
          ),
        );
      },
      (ProductModel data) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("SQLFLITE CRUD"),
                content: const Text("Do you want to delete this.record?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHelper.submitButton(
                        "Yes",
                        () {
                          dbService.deleteProduct(data).then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          });
                        },
                        width: 100,
                        borderRadius: 5,
                        btnColor: Colors.green,
                        borderColor: Colors.green,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FormHelper.submitButton(
                        "No",
                        () {
                          Navigator.of(context).pop();
                        },
                        width: 100,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                ],
              );
            });
      },
      headingRowColor: Colors.orangeAccent,
      isScrollable: true,
      columnTextFontSize: 15,
      columnTextBold: false,
      columnSpacing: 50,
      onSort: (columnIndex, columnName, asc) {},
    );
    /*
    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            "Product Name",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Price",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model
          .map(
            (data) => DataRow(
          cells: <DataCell>[
            DataCell(
              Text(
                data.productName,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            DataCell(
              Text(
                data.price.toString(),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditProduct(
                              isEditMode: true,
                              model: data,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        FormHelper.showMessage(
                          context,
                          "SQFLITE CRUD",
                          "Do you want to delete this record?",
                          "Yes",
                              () {
                            dbService.deleteProduct(data).then((value) {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            });
                          },
                          buttonText2: "No",
                          isConfirmationDialog: true,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .toList(),
    );

     */
  }
}
