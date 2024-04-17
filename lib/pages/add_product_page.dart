import 'package:flutter/material.dart';
import 'package:footware_admin/controller/home_controller.dart';
import 'package:footware_admin/widgets/dropdown_btn.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Product'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add New Product",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productNameCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text("Product Name"),
                      hintText: 'Enter Your Product Name'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productDescriptionCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text("Product Description"),
                      hintText: 'Enter Your Product Description'),
                  maxLines: 4,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productImgCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text("Image Url"),
                      hintText: 'Image Url'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productPriceCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text("Product Price"),
                      hintText: 'Price'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        child: DropdownBtn(
                      items: const ['Boots','Shoe','Beach Shoes', 'High heels'],
                      selectedItemText: ctrl.category,
                      onSelected: (selectedValue) {
                        ctrl.category = selectedValue ?? "general";
                        ctrl.update();
                      },
                    )),
                    Flexible(
                        child: DropdownBtn(
                      items:const ["Puma", "Sketchers", "adidas",'Clarks'],
                      selectedItemText: ctrl.brand,
                      onSelected: (selectedValue) {
                       ctrl.brand = selectedValue ?? "un branded";
                       ctrl.update();
                      },
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Offer Product ?',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownBtn(
                  items: ["true", "false"],
                  selectedItemText: ctrl.offer.toString(),
                  onSelected: (selectedValue) {
                   ctrl.offer = bool.tryParse(selectedValue?? "false") ?? false;
                   ctrl.update();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      ctrl.addProduct();

                    },
                    child: Text("Add Product"))
              ],
            ),
          ),
        ),
      );
    });
  }
}
