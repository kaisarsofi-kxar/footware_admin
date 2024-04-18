import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footware_admin/model/product/product.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescriptionCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  String category = "general";
  String brand = "un branded";
  bool offer = false;
  File? pickedImage;

  bool isLoading = false;

  void setLoading(bool loading) {
    isLoading = loading;
    update(); // Notify listeners about the change.
  }

  showAlertBox() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pick Image From'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                pickImage(ImageSource.camera);
                Get.back(); // This replaces Navigator.pop(context)
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
            ),
            ListTile(
              onTap: () {
                pickImage(ImageSource.gallery);
                Get.back(); // This replaces Navigator.pop(context)
              },
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
            )
          ],
        ),
      ),
      barrierDismissible: true, // Allows tapping outside to dismiss the dialog
    );
  }

  void showCustomSnackbar(
      String title, String message, Color bgColor, Color textColor) {
    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: textColor,
    );
  }

  List<Product> products = [];

  @override
  void onInit() async {
    productCollection = firestore.collection("products");
    await fetchProducts();
    super.onInit();
  }

  addProduct() async {
    if (productNameCtrl.text.isEmpty ||
        productDescriptionCtrl.text.isEmpty ||
        productPriceCtrl.text.isEmpty) {
      showCustomSnackbar("Missing Information", "All fields are required.",
          Colors.red, Colors.white);
      return; // Stop further execution if validation fails
    }

    double? price = double.tryParse(productPriceCtrl.text);
    if (price == null) {
      // Check if the entered price is a valid double
      showCustomSnackbar("Invalid Input", "Please enter a valid price.",
          Colors.red, Colors.white);
      return; // Stop further execution if price is not valid
    }
    setLoading(true);

    try {
      String fileName =
          'products/${productNameCtrl.text}_${DateTime.now().millisecondsSinceEpoch}';
      Reference storageRef =
          FirebaseStorage.instance.ref("ProductImageUrls").child(fileName);
      UploadTask uploadTask = storageRef.putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();

      DocumentReference doc = productCollection.doc();

      Product product = Product(
        id: doc.id,
        name: productNameCtrl.text,
        description: productDescriptionCtrl.text,
        category: category,
        price: double.tryParse(productPriceCtrl.text),
        brand: brand,
        image: url,
        offer: offer,
      );
      final productJson = product.toJson();
      doc.set(productJson);
      showCustomSnackbar(
          "Success", 'Product added successfully', Colors.green, Colors.white);
      fetchProducts();
      setValuesDefault();
    } catch (e) {
      showCustomSnackbar(
        "Error",
        e.toString(),
        Colors.red,
        Colors.white,
      );
      print(e);
    }
    finally{
      setLoading(false);
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
      showCustomSnackbar(
        "Error",
        e.toString(),
        Colors.red,
        Colors.white,
      );
      print(e);
    } finally {
      update();
    }
  }

  deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      showCustomSnackbar("Success", 'Product Deleted successfully',
          Colors.green, Colors.white);
      fetchProducts();
    } catch (e) {
      showCustomSnackbar(
        "Error",
        e.toString(),
        Colors.red,
        Colors.white,
      );
      print(e);
    }
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) {
        return;
      }
      final tempImage = File(photo.path);
      pickedImage = tempImage;
      update();
    } catch (ex) {
      print(ex.toString());
    }
  }

  setValuesDefault() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productPriceCtrl.clear();
    pickedImage = null;
    category = "general";
    brand = "un branded";
    offer = false;
    update();
  }
}
