import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:demo_prac_getx/model/model.dart';
import 'package:demo_prac_getx/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/app_colors.dart';
import '../utils/pdf_helper.dart';
import '../widgets/widgets.dart';


class ItemController extends GetxController {
  var itemList = <Item>[].obs; // Changed from Invoice to Item
  var cart = <Invoice>[].obs;
  var isLoading = false.obs;
  var isSavingInvoice = false.obs;

  double get total => cart.fold(0, (sum, item) => sum + (item.qty * item.price));

  @override
  void onInit() {
    super.onInit();
    fetchItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RemoteService.checkInvoiceTableStructure();
    });
  }

  // Fetch items from Items table
  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      // final items = await RemoteService.getItems();
      // itemList.assignAll(items);
    } catch (e) {
      print("-----Error on fetchItems() in Controller,,,, ${e.toString()}");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to load items: $e",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveItem(Item item) async {
    await RemoteService.addItem(item);
    fetchItems(); // refresh list from AppSheet
  }


  // Add item to cart (convert Item to Invoice)
  void addToCart(Item item) {
    // Check if item already in cart
    final existingIndex = cart.indexWhere((cartItem) => cartItem.pid == item.itemId);

    if (existingIndex >= 0) {
      // Update quantity if already in cart
      final existingItem = cart[existingIndex];
      cart[existingIndex] = Invoice(
        pid: existingItem.pid,
        productName: existingItem.productName,
        qty: existingItem.qty + 1,
        price: existingItem.price,
        mobile: existingItem.mobile,
        userName: existingItem.userName,
        date: existingItem.date,
      );
    } else {
      // Add new item to cart with default values
      cart.add(Invoice(
        pid: item.itemId,
        productName: item.itemName,
        qty: 1,
        price: item.price,
        mobile: "",
        userName: "",
        date: DateTime.now(),
      ));
      print("-----Error on AddTo Cart() in Controller,,,, e.toString()}");
      showCustomSnackbar(
        title: "Added to Cart",
        message: "${item.itemName} added to cart",
        baseColor: AppColors.darkGreenColor,
        icon: Icons.add_shopping_cart,
      );
    }
  }

  void removeFromCart(String pid) {
    final item = cart.firstWhereOrNull((cartItem) => cartItem.pid == pid);
    cart.removeWhere((item) => item.pid == pid);
    if (item != null) {
      showCustomSnackbar(
        title: "Removed",
        message: "${item.productName} removed from cart",
        baseColor: Colors.red.shade700,
        icon: Icons.delete_outline,
      );
    }
  }

  void clearCart() {
    cart.clear();
  }

  // Add new item to Items table
  Future<void> addNewItem(String name, double price) async {
    final newItem = Item(
      itemId: DateTime.now().millisecondsSinceEpoch.toString(),
      itemName: name,
      price: price,
    );

    try {
      await RemoteService.addItem(newItem);
      itemList.add(newItem);
      showCustomSnackbar(
        title: "Success",
        message: "Item saved to Items table",
        baseColor: AppColors.darkGreenColor,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      print("-----Error on addItems() in Controller,,,, ${e.toString()}");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to save item: $e",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
    }
  }

  // Save invoice to Invoice table
  Future<bool> saveInvoice(List<Invoice> invoices, String userName, String phone) async {
    if (invoices.isEmpty) {
      showCustomSnackbar(
        title: "Error",
        message: "Cart is empty",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
      return false;
    }

    isSavingInvoice.value = true;

    try {
      await RemoteService.addInvoice(invoices);

      showCustomSnackbar(
        title: "Success",
        message: "Invoice saved successfully!",
        baseColor: AppColors.darkGreenColor,
        icon: Icons.check_circle_outline,
      );

      clearCart();
      return true;
    } catch (e) {
      // More specific error messages
      String errorMessage = "Failed to save invoice";

      if (e.toString().contains("400")) {
        errorMessage = "Table schema mismatch. Please check your AppSheet table columns.";
      } else if (e.toString().contains("401")) {
        errorMessage = "Access denied. Please check your API key.";
      } else if (e.toString().contains("404")) {
        errorMessage = "Invoice table not found. Please check your table name.";
      } else if (e.toString().contains("Network error")) {
        errorMessage = "Network connection failed. Please check your internet.";
      }

      showCustomSnackbar(
        title: "Error",
        message: errorMessage,
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );

      print("Save invoice error: $e");
      return false;
    } finally {
      isSavingInvoice.value = false;
    }
  }

  Future<bool> saveInvoiceold(List<Invoice> invoices, String userName, String phone) async {
    isLoading.value = true;
    isSavingInvoice.value = true;
    try {
      // Add userName and phone to all invoice items
      final invoicesWithUser = invoices.map((e) => Invoice(
        pid: e.pid,
        productName: e.productName,
        qty: e.qty,
        price: e.price,
        mobile: phone,
        userName: userName,
        date: DateTime.now(),
      )).toList();

      await RemoteService.addInvoice(invoicesWithUser);
      print("-----Error on saveInvoice() in Controller,,,, {e.toString()}");
      showCustomSnackbar(
        title: "Success",
        message: "Invoice saved successfully!",
        baseColor: AppColors.darkGreenColor,
        icon: Icons.check_circle_outline,
      );
      clearCart();
      return true;
    } catch (e) {
      print("-----Error on saveInvoice() in Controller catch,,,, ${e.toString()}");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to save invoice: $e",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
      return false;
    }finally {
      isSavingInvoice.value = false;
    }
    isLoading.value = false;
  }
}

// class ItemController extends GetxController {
//   var itemList = <Invoice>[].obs;
//   var cart = <Invoice>[].obs;
//   var isLoading = false.obs;
//
//   /// ✅ Total price of cart
//   double get total =>
//       cart.fold(0, (sum, item) => sum + (item.qty * item.price));
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchItems();
//   }
//
//
//
//   /// ✅ Fetch initial items (replace with API/AppSheet)
//   Future<void> fetchItems() async {
//     try {
//       isLoading.value = true;
//       await Future.delayed(Duration(seconds: 1)); // simulate fetch
//       itemList.assignAll(itemList);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// ✅ Add item to cart (increments qty if already exists)
//   void addToCart(Invoice item) {
//     // Check if item already in cart
//     final existingIndex = cart.indexWhere((cartItem) => cartItem.pid == item.pid);
//
//     if (existingIndex >= 0) {
//       // Update quantity if already in cart
//       final existingItem = cart[existingIndex];
//       cart[existingIndex] = Invoice(
//         pid: existingItem.pid,
//         productName: existingItem.productName,
//         qty: existingItem.qty + 1,
//         price: existingItem.price,
//         mobile: existingItem.mobile,
//       );
//     } else {
//       cart.add(item);
//       showCustomSnackbar(
//         title: "Added to Cart",
//         message: "${item.productName} added to cart",
//         baseColor: AppColors.darkGreenColor,
//         icon: Icons.add_shopping_cart,
//       );
//     }
//   }
//
//   /// Remove item from cart
//   void removeFromCart(String pid) {
//     final item = cart.firstWhereOrNull((cartItem) => cartItem.pid == pid);
//     cart.removeWhere((item) => item.pid == pid);
//     if (item != null) {
//       showCustomSnackbar(
//         title: "Removed",
//         message: "${item.productName} removed from cart",
//         baseColor: Colors.red.shade700,
//         icon: Icons.delete_outline,
//       );
//     }
//   }
//
//   /// ✅ Clear cart
//   void clearCart() {
//     cart.clear();
//   }
//
//   /// ✅ Add item manually to the item list
//   void addManualItem(String name, double price) {
//     final newItem = Invoice(
//       pid: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: name,
//       qty: 1,
//       price: price,
//       mobile: "",
//     );
//     itemList.add(newItem);
//   }
//
//   /// ✅ Save invoice to AppSheet / RemoteService & share PDF
//   Future<void> saveInvoice(List<Invoice> invoices) async {
//     isLoading.value = true;
//     try {
//       await RemoteService.addInvoice(invoices);
//       showCustomSnackbar(
//         title: "Success",
//         message: "Invoice saved successfully!",
//         baseColor: AppColors.darkGreenColor,
//         icon: Icons.check_circle_outline,
//       );
//       clearCart();
//     } catch (e) {
//       showCustomSnackbar(
//         title: "Error",
//         message: "Failed to save invoice: $e",
//         baseColor: Colors.red.shade700,
//         icon: Icons.error_outline,
//       );
//     }
//     isLoading.value = false;
//   }
// }
