import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../models/product_model.dart';
import '../services/dbservices.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({Key? key, this.model, this.isEditMode = false})
      : super(key: key);
  final ProductModel? model;
  final bool isEditMode;

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late ProductModel model;
  late DBService dbService;
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    dbService = DBService();
    model = ProductModel(
        productName: 'Deneme',
        categoryId: -1,
        productDesc: 'deneme',
        price: 10,
        productPic: '',
    );
    if (widget.isEditMode) {
      model = widget.model!;
    }
    categories.add({'id': 1, 'name': 'T-Shirts'});
    categories.add({'id': 2, 'name': 'Shirts'});
    categories.add({'id': 3, 'name': 'Jeans'});
    categories.add({'id': 4, 'name': 'Trousers'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(
          widget.isEditMode ? 'Edit Product' : 'Add Product',
        ),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormHelper.submitButton(
              "Save",
              borderRadius: 10,
              btnColor: Colors.green,
              borderColor: Colors.green,
              () {
                if (validateAndSave()) {
                  if (widget.isEditMode) {
                    dbService.updateProduct(model).then((value) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "SQFLITE",
                        "Data Modified Successfully",
                        "OK",
                        () {
                          Navigator.pop(context);
                        },
                      );
                    });
                  } else {
                    dbService.addProduct(model).then((value) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "SQFLITE",
                        "Data Added Successfully",
                        "OK",
                        () {
                          Navigator.pop(context);
                        },
                      );
                    });
                  }
                }
              },
            ),
            FormHelper.submitButton(
              "Cancel",
              borderRadius: 10,
              btnColor: Colors.grey,
              borderColor: Colors.grey,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FormHelper.inputFieldWidgetWithLabel(
              context,
              'productName',
              'Product Name',
              '-',
              (onValidate) {
                if (onValidate.isEmpty) {
                  return '* Required';
                }
                return null;
              },
              (onSaved) {
                model.productName = onSaved.toString().trim();
              },
              initialValue: model.productName,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.text_fields),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    'productPrice',
                    'Product Price',
                    '-',
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return '* Required';
                      }
                      return null;
                    },
                    (onSaved) {
                      model.price = double.parse(onSaved.trim());
                    },
                    initialValue:
                        model.price != null ? model.price.toString() : "",
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.currency_lira),
                    borderRadius: 10,
                    contentPadding: 15,
                    fontSize: 14,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    prefixIconPaddingLeft: 10,
                    isNumeric: true,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FormHelper.dropDownWidgetWithLabel(
                    context,
                    "Product Category",
                    "--Select--",
                    model.categoryId,
                    categories,
                    (onChanged) {
                      model.categoryId = int.parse(onChanged);
                    },
                    (onValidate) {},
                    borderRadius: 10,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    hintFontSize: 14,
                    prefixIcon: const Icon(Icons.category),
                    showPrefixIcon: true,
                    prefixIconPaddingLeft: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 10),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              'productDesc',
              'Product Description',
              '-',
              (onValidate) {
                if (onValidate.isEmpty) {
                  return '* Required';
                }
                return null;
              },
              (onSaved) {
                model.productDesc = onSaved.toString().trim();
              },
              initialValue: model.productDesc ?? '',
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              isMultiline: true,
              multilineRows: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            _picPicker(
              model.productPic ?? "",
              (file) => {
                setState(
                  () {
                    model.productPic = file.path;
                  },
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  _picPicker(
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();
    return Column(
      children: [
        fileName != ""
            ? Image.file(
                File(fileName),
                width: 300,
                height: 300,
              )
            : SizedBox(
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/%C2%BFel_Caf%C3%A9%3F.png/640px-%C2%BFel_Caf%C3%A9%3F.png',
                  width: 350,
                  height: 200,
                  fit: BoxFit.scaleDown,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.image,
                  size: 35,
                ),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.gallery);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.camera,
                  size: 35,
                ),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.camera);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
