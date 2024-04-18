

import 'package:flutter/material.dart';
import 'package:footware_admin/controller/home_controller.dart';
import 'package:footware_admin/pages/add_product_page.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Footware Admin'),
        ),
        body: ctrl.products.isEmpty
            ? const Center(
          child: Text('There are no products' ,style: TextStyle(fontSize: 24),), // Display message when list is empty
        )
            : ListView.builder(
          itemCount: ctrl.products.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ctrl.products[index].image != ""
                  ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  ctrl.products[index].image!
                ),
              )
                  : const CircleAvatar(
                radius: 25,
                child: Icon(Icons.add_a_photo_outlined, size: 30),
              ),
              title: Text(ctrl.products[index].name!),
              subtitle: Text(ctrl.products[index].price.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ctrl.deleteProduct(ctrl.products[index].id!);
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(()=>const AddProductPage());
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
