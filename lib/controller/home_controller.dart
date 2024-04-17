import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:footware_admin/model/product/product.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescriptionCtrl = TextEditingController();
  TextEditingController productImgCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  String category = "general";
  String brand = "un branded";
  bool offer = false;

  List<Product> products = [];

  @override
  void onInit() async {
    productCollection = firestore.collection("products");
    await fetchProducts();
    super.onInit();
  }

  addProduct() {
    if (productNameCtrl.text.isEmpty ||
        productDescriptionCtrl.text.isEmpty ||
        productImgCtrl.text.isEmpty ||
        productPriceCtrl.text.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Stop further execution if validation fails
    }

    double? price = double.tryParse(productPriceCtrl.text);
    if (price == null) {
      // Check if the entered price is a valid double
      Get.snackbar(
        "Invalid Input",
        "Please enter a valid price.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Stop further execution if price is not valid
    }

    try {
      DocumentReference doc = productCollection.doc();
      Product product = Product(
        id: doc.id,
        name: productNameCtrl.text,
        description: productDescriptionCtrl.text,
        category: category,
        price: double.tryParse(productPriceCtrl.text),
        brand: brand,
        image: productImgCtrl.text,
        offer: offer,
      );
      final productJson = product.toJson();
      doc.set(productJson);
      Get.snackbar(
        "Success",
        'Product added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchProducts();
      setValuesDefault();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print(e);
    }
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProducts);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
    }finally{
      update();
    }
  }
  deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      Get.snackbar(
        "Success",
        "Product deleted Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchProducts();
    } catch (e) {
      Get.snackbar(
        "Success",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
    }
  }
  setValuesDefault() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productImgCtrl.clear();
    productPriceCtrl.clear();
    category = "general";
    brand = "un branded";
    offer = false;
    update();
  }
}
