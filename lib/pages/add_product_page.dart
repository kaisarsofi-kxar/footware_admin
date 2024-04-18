import 'package:flutter/material.dart';
import 'package:footware_admin/controller/home_controller.dart';
import 'package:footware_admin/widgets/dropdown_btn.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      if (ctrl.isLoading) {
        // Show loading indicator when isLoading is true
        return Scaffold(
          appBar: AppBar(title: const Text('Add Product')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }else{
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Add New Product",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productNameCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text("Product Name"),
                      hintText: 'Enter Your Product Name'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productDescriptionCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text("Product Description"),
                      hintText: 'Enter Your Product Description'),
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: ctrl.productPriceCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text("Product Price"),
                      hintText: 'Price'),
                ),
                const SizedBox(
                  height: 10,
                ),

                InkWell(
                  onTap: () {
                    ctrl.showAlertBox();
                  },
                  child: Card(

                    child: ListTile(
                      leading: ctrl.pickedImage != null
                          ? CircleAvatar(
                              radius: 25,
                              backgroundImage: FileImage(ctrl.pickedImage!),
                            )
                          : const CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.add_a_photo_outlined, size: 30),
                            ),
                      title: const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text('Upload Product Image',
                            style: TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        ctrl.showAlertBox();
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 18),

                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                        child: DropdownBtn(
                      items: const [
                        'Boots',
                        'Shoe',
                        'Beach Shoes',
                        'High heels'
                      ],
                      selectedItemText: ctrl.category,
                      onSelected: (selectedValue) {
                        ctrl.category = selectedValue ?? "general";
                        ctrl.update();
                      },
                    )),
                    Flexible(
                        child: DropdownBtn(
                      items: const ["Puma", "Sketchers", "adidas", 'Clarks'],
                      selectedItemText: ctrl.brand,
                      onSelected: (selectedValue) {
                        ctrl.brand = selectedValue ?? "un branded";
                        ctrl.update();
                      },
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Offer Product ?',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownBtn(
                  items: ["true", "false"],
                  selectedItemText: ctrl.offer.toString(),
                  onSelected: (selectedValue) {
                    ctrl.offer =
                        bool.tryParse(selectedValue ?? "false") ?? false;
                    ctrl.update();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      ctrl.addProduct();
                    },
                    child: const Text("Add Product"))
              ],
            ),
          ),
        ),
      );}
    });
  }
}
