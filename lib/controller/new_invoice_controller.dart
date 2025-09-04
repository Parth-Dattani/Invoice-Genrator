// new_invoice_controller.dart
import 'package:demo_prac_getx/controller/bash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constant/constant.dart';
import '../model/model.dart';
import '../services/service.dart';
import '../utils/shared_preferences_helper.dart';
import '../widgets/widgets.dart';
import 'controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NewInvoiceController extends GetxController {
  // Form controllers
  final formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final customerMobileController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerAddressController = TextEditingController();
  final invoiceNumberController = TextEditingController();
  final dueDateController = TextEditingController();
  final notesController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var selectedCustomer = Rxn<Map<String, dynamic>>();
  var customers = <Map<String, dynamic>>[].obs;
  var items = <Map<String, dynamic>>[].obs;
  var itemList = <Item>[].obs;
  var invoiceItems = <InvoiceItem>[].obs;
  var selectedDate = DateTime.now().obs;
  var dueDate = DateTime.now().add(Duration(days: 30)).obs;
  var taxRate = 0.0.obs;
  var discountAmount = 0.0.obs;
  var discountType = 'amount'.obs;
  var showCustomerForm = false.obs;
  var customerCount = 0.obs;

  // Calculated values
  var subtotal = 0.0.obs;
  var taxAmount = 0.0.obs;
  var totalAmount = 0.0.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeInvoice();
    loadCustomers();
    fetchItems2();
  }

  @override
  void onClose() {
    customerNameController.dispose();
    customerMobileController.dispose();
    customerEmailController.dispose();
    customerAddressController.dispose();
    invoiceNumberController.dispose();
    dueDateController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void _initializeInvoice() {
    final now = DateTime.now();
    invoiceNumberController.text = 'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
    dueDateController.text = _formatDate(dueDate.value);
    addNewItem();
  }

  Future<void> loadCustomers() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
      print("Company ID: $companyId");

      final customersSnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .collection("customers")
          .get();

      customers.clear();
      for (var doc in customersSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        customers.add(data);
      }

      // Also update customer count
      customerCount.value = customers.length;

      print("Customer---count----${customerCount.value}");
    } catch (e) {
      print("Error loading customers: $e");
      Get.snackbar(
        'Error',
        'Failed to load customers',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchItems2() async {
    try {
      isLoading.value = true;
      final userId = AppConstants.userId;

      print("=== ATTEMPTING TO FETCH ITEMS FOR USER: $userId ===");

      // Try to get items
      List<Item> items = await RemoteService.getItems(userId: userId);

      // If no items found, try alternative methods
      if (items.isEmpty) {
        print("Standard method failed, trying alternative...");
        items = await RemoteService.getItemsAlternative(userId);
      }

      print("Final result: ${items.length} items found");

      // Debug: Print each found item
      for (var item in items) {
        print("Found item: ${item.itemName} (ID: ${item.itemId}) for user: ${item.userId}");
      }

      itemList.assignAll(items);

      if (items.isEmpty) {
        showCustomSnackbar(
          title: "No Items",
          message: "No items found for the current user",
          baseColor: Colors.orange.shade700,
          icon: Icons.info_outline,
        );
      } else {
        showCustomSnackbar(
          title: "Success",
          message: "Found ${items.length} items",
          baseColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      }

    } catch (e) {
      print("Error in fetchItems2(): $e");
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

  Future<void> loadItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
      if (companyId.isEmpty) return;

      final itemsSnapshot = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .collection("items")
          .get();

      items.clear();
      for (var doc in itemsSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        items.add(data);
      }
    } catch (e) {
      print("Error loading items: $e");
    }
  }

  void selectCustomer(Map<String, dynamic>? customer) {
    if (customer == null) {
      selectedCustomer.value = null;
      clearCustomerSelection();
      showCustomerForm.value = false;
      return;
    }

    selectedCustomer.value = customer;
    customerNameController.text = customer['name'] ?? '';
    customerMobileController.text = customer['mobile'] ?? '';
    customerEmailController.text = customer['email'] ?? '';
    customerAddressController.text = customer['address'] ?? '';
    showCustomerForm.value = false;
  }

  void toggleCustomerForm() {
    showCustomerForm.value = !showCustomerForm.value;
    if (showCustomerForm.value) {
      selectedCustomer.value = null;
      clearCustomerSelection();
    }
  }

  void clearCustomerSelection() {
    selectedCustomer.value = null;
    customerNameController.clear();
    customerMobileController.clear();
    customerEmailController.clear();
    customerAddressController.clear();
  }

  void addNewItem() {
    invoiceItems.add(InvoiceItem(
      description: '',
      quantity: 1,
      rate: 0.0,
      itemId: '',
    ));
    _calculateTotals();
  }

  void updateItem(int index, {String? description, int? quantity, double? rate, String? itemId}) {
    if (index < invoiceItems.length) {
      final item = invoiceItems[index];
      invoiceItems[index] = InvoiceItem(
        description: description ?? item.description,
        quantity: quantity ?? item.quantity,
        rate: rate ?? item.rate,
        itemId: itemId ?? item.itemId,
      );
      _calculateTotals();
    }
  }

  void selectRemoteItemForIndex(int index, Item item) {
    if (index < invoiceItems.length) {
      invoiceItems[index] = InvoiceItem(
        description: item.itemName,
        quantity: invoiceItems[index].quantity,
        rate: item.price.toDouble(),
        itemId: item.itemId,
      );
      _calculateTotals();
    }
  }

  void removeItem(int index) {
    if (invoiceItems.length > 1) {
      invoiceItems.removeAt(index);
      _calculateTotals();
    }
  }

  void _calculateTotals() {
    double sub = 0.0;
    for (var item in invoiceItems) {
      sub += item.quantity * item.rate;
    }
    subtotal.value = sub;

    double discountValue = 0.0;
    if (discountType.value == 'percentage') {
      discountValue = subtotal.value * (discountAmount.value / 100);
    } else {
      discountValue = discountAmount.value;
    }

    double afterDiscount = subtotal.value - discountValue;
    taxAmount.value = afterDiscount * (taxRate.value / 100);
    totalAmount.value = afterDiscount + taxAmount.value;
  }

  void updateTaxRate(double rate) {
    taxRate.value = rate;
    _calculateTotals();
  }

  void updateDiscount(double amount, String type) {
    discountAmount.value = amount;
    discountType.value = type;
    _calculateTotals();
  }

  Future<void> selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dueDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != dueDate.value) {
      dueDate.value = picked;
      dueDateController.text = _formatDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Missing method: Save invoice to Firebase
  Future<void> saveInvoice({required bool isDraft}) async {
    try {
      if (!formKey.currentState!.validate()) {
        showCustomSnackbar(
          title: "Validation Error",
          message: "Please fill all required fields",
          baseColor: Colors.orange.shade700,
          icon: Icons.warning,
        );
        return;
      }

      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
      if (companyId.isEmpty) {
        throw Exception("Company ID not found");
      }

      // Prepare invoice data
      Map<String, dynamic> invoiceData = {
        'invoiceNumber': invoiceNumberController.text,
        'customerName': customerNameController.text,
        'customerMobile': customerMobileController.text,
        'customerEmail': customerEmailController.text,
        'customerAddress': customerAddressController.text,
        'issueDate': DateTime.now(),
        'dueDate': dueDate.value,
        'subtotal': subtotal.value,
        'taxRate': taxRate.value,
        'taxAmount': taxAmount.value,
        'discountAmount': discountAmount.value,
        'discountType': discountType.value,
        'totalAmount': totalAmount.value,
        'notes': notesController.text,
        'status': isDraft ? 'draft' : 'issued',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'items': invoiceItems.map((item) => {
          'description': item.description,
          'quantity': item.quantity,
          'rate': item.rate,
          'amount': item.amount,
          'itemId': item.itemId,
        }).toList(),
      };

      // Add customer reference if selected from existing customers
      if (selectedCustomer.value != null) {
        invoiceData['customerId'] = selectedCustomer.value!['id'];
      }

      // Save to Firestore
      final invoiceRef = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .collection("invoices")
          .add(invoiceData);

      showCustomSnackbar(
        title: "Success",
        message: "Invoice ${isDraft ? 'saved as draft' : 'created'} successfully",
        baseColor: Colors.green.shade700,
        icon: Icons.check_circle,
      );

      // Clear form if it's a new invoice (not draft)
      if (!isDraft) {
        clearForm();
      }

      // Navigate back or to invoice list
      Get.back();

    } catch (e) {
      print("Error saving invoice: $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to save invoice: ${e.toString()}",
        baseColor: Colors.red.shade700,
        icon: Icons.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    formKey.currentState?.reset();
    invoiceItems.clear();
    clearCustomerSelection();
    taxRate.value = 0.0;
    discountAmount.value = 0.0;
    discountType.value = 'amount';
    notesController.clear();
    _initializeInvoice();
    _calculateTotals();
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double rate;
  final String itemId;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.rate,
    required this.itemId,
  });

  double get amount => quantity * rate;
}



/// use My Model
// class NewInvoiceController extends GetxController {
//   // Form controllers
//   final formKey = GlobalKey<FormState>();
//   final customerNameController = TextEditingController();
//   final customerMobileController = TextEditingController();
//   final customerEmailController = TextEditingController();
//   final customerAddressController = TextEditingController();
//   final invoiceNumberController = TextEditingController();
//   final dueDateController = TextEditingController();
//   final notesController = TextEditingController();
//
//   // Observable variables
//   var isLoading = false.obs;
//   var selectedCustomer = Rxn<Map<String, dynamic>>();
//   var customers = <Map<String, dynamic>>[].obs;
//   var items = <Map<String, dynamic>>[].obs; // Items from Firestore
//   var itemList = <Item>[].obs; // Items from RemoteService
//   var invoiceItems = <Invoice>[].obs;
//   var selectedDate = DateTime.now().obs;
//   var dueDate = DateTime.now().add(Duration(days: 30)).obs;
//   var taxRate = 0.0.obs;
//   var discountAmount = 0.0.obs;
//   var discountType = 'amount'.obs; // 'amount' or 'percentage'
//   var showCustomerForm = false.obs;
//   var customerCount = 0.obs;
//
//   // Calculated values
//   var subtotal = 0.0.obs;
//   var taxAmount = 0.0.obs;
//   var totalAmount = 0.0.obs;
//
//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Get company ID from dashboard controller or shared preferences
//   String get companyId {
//     try {
//       final dashboardController = Get.find<DashboardController>();
//       return dashboardController.companyId.value;
//     } catch (e) {
//       return '';
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeInvoice();
//     loadCustomers(); // Load customers from Firestore
//     fetchItems2(); // Load items from RemoteService
//   }
//
//   @override
//   void onClose() {
//     customerNameController.dispose();
//     customerMobileController.dispose();
//     customerEmailController.dispose();
//     customerAddressController.dispose();
//     invoiceNumberController.dispose();
//     dueDateController.dispose();
//     notesController.dispose();
//     super.onClose();
//   }
//
//   void _initializeInvoice() {
//     // Generate invoice number
//     final now = DateTime.now();
//     invoiceNumberController.text = 'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
//
//     // Set due date
//     dueDateController.text = _formatDate(dueDate.value);
//
//     // Add initial empty item
//     addNewItem();
//   }
//
//   Future<void> loadCustomers() async {
//     try {
//       isLoading.value = true;
//       final user = _auth.currentUser;
//       if (user == null) return;
//
//       String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
//       print("Company ID: $companyId");
//
//       final customersSnapshot = await _firestore
//           .collection("users")
//           .doc(user.uid)
//           .collection("companies")
//           .doc(companyId)
//           .collection("customers")
//           .get();
//
//       customers.clear();
//       for (var doc in customersSnapshot.docs) {
//         final data = doc.data();
//         data['id'] = doc.id;
//         customers.add(data);
//         print("Added customer: ${data['name']} (ID: ${doc.id})");
//       }
//
//       // Also update customer count
//       customerCount.value = customers.length;
//       print("Customer count: ${customerCount.value}");
//
//     } catch (e) {
//       print("Error loading customers: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to load customers',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchItems2() async {
//     try {
//       isLoading.value = true;
//       final userId = AppConstants.userId;
//
//       print("=== ATTEMPTING TO FETCH ITEMS FOR USER: $userId ===");
//
//       // Try to get items
//       List<Item> items = await RemoteService.getItems(userId: userId);
//
//       // If no items found, try alternative methods
//       if (items.isEmpty) {
//         print("Standard method failed, trying alternative...");
//         items = await RemoteService.getItemsAlternative(userId);
//       }
//
//       print("Final result: ${items.length} items found");
//
//       // Debug: Print each found item
//       for (var item in items) {
//         print("Found item: ${item.itemName} (ID: ${item.itemId}) for user: ${item.userId}");
//       }
//
//       itemList.assignAll(items);
//
//       if (items.isEmpty) {
//         showCustomSnackbar(
//           title: "No Items",
//           message: "No items found for the current user",
//           baseColor: Colors.orange.shade700,
//           icon: Icons.info_outline,
//         );
//       } else {
//         showCustomSnackbar(
//           title: "Success",
//           message: "Found ${items.length} items",
//           baseColor: Colors.green.shade700,
//           icon: Icons.check_circle_outline,
//         );
//       }
//
//     } catch (e) {
//       print("Error in fetchItems2(): $e");
//       showCustomSnackbar(
//         title: "Error",
//         message: "Failed to load items: $e",
//         baseColor: Colors.red.shade700,
//         icon: Icons.error_outline,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> loadItems() async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null || companyId.isEmpty) return;
//
//       final itemsSnapshot = await _firestore
//           .collection("users")
//           .doc(user.uid)
//           .collection("companies")
//           .doc(companyId)
//           .collection("items")
//           .get();
//
//       items.clear();
//       for (var doc in itemsSnapshot.docs) {
//         final data = doc.data();
//         data['id'] = doc.id;
//         items.add(data);
//       }
//     } catch (e) {
//       print("Error loading items: $e");
//     }
//   }
//
//   void selectCustomer(Map<String, dynamic>? customer) {
//     if (customer == null) {
//       selectedCustomer.value = null;
//       clearCustomerSelection();
//       showCustomerForm.value = false;
//       return;
//     }
//
//     selectedCustomer.value = customer;
//     customerNameController.text = customer['name'] ?? '';
//     customerMobileController.text = customer['mobile'] ?? '';
//     customerEmailController.text = customer['email'] ?? '';
//     customerAddressController.text = customer['address'] ?? '';
//     showCustomerForm.value = false;
//   }
//
//   void toggleCustomerForm() {
//     showCustomerForm.value = !showCustomerForm.value;
//     if (showCustomerForm.value) {
//       selectedCustomer.value = null;
//       clearCustomerSelection();
//     }
//   }
//
//   void clearCustomerSelection() {
//     selectedCustomer.value = null;
//     customerNameController.clear();
//     customerMobileController.clear();
//     customerEmailController.clear();
//     customerAddressController.clear();
//   }
//
//   void addNewItem() {
//     invoiceItems.add(Invoice(
//       itemName: '',
//       customerName: '',
//       price: 0.0,
//       qty: 1,
//       mobile: '',
//       invoiceId: '',
//       itemId: '',
//     ));
//     _calculateTotals();
//   }
//
//   void removeItem(int index) {
//     if (invoiceItems.length > 1) {
//       invoiceItems.removeAt(index);
//       _calculateTotals();
//     }
//   }
//
//   void updateItem(int index, {String? description, int? quantity, double? rate, String? itemId}) {
//     if (index < invoiceItems.length) {
//       final item = invoiceItems[index];
//       invoiceItems[index] = Invoice(
//         itemName: description ?? item.itemName,
//         qty: quantity ?? item.qty,
//         price: rate ?? item.price,
//         itemId: itemId ?? item.itemId,
//         customerName: item.customerName,
//         mobile: item.mobile,
//         invoiceId: item.invoiceId,
//       );
//       _calculateTotals();
//     }
//   }
//
//   void selectItemForIndex(int index, Item item) {
//     if (index < invoiceItems.length) {
//       invoiceItems[index] = Invoice(
//         itemName: item.itemName,
//         qty: invoiceItems[index].qty,
//         price: item.price,
//         itemId: item.itemId,
//         customerName: invoiceItems[index].customerName,
//         mobile: invoiceItems[index].mobile,
//         invoiceId: invoiceItems[index].invoiceId,
//       );
//       _calculateTotals();
//     }
//   }
//
//   // Alternative method for selecting items from Firestore
//   void selectFirestoreItemForIndex(int index, Map<String, dynamic> item) {
//     if (index < invoiceItems.length) {
//       invoiceItems[index] = Invoice(
//         itemName: item['itemName'] ?? item['ItemName'] ?? '',
//         qty: invoiceItems[index].qty,
//         price: (item['price'] ?? item['Price'] ?? 0.0).toDouble(),
//         itemId: item['id'] ?? item['itemId'] ?? '',
//         customerName: invoiceItems[index].customerName,
//         mobile: invoiceItems[index].mobile,
//         invoiceId: invoiceItems[index].invoiceId,
//       );
//       _calculateTotals();
//     }
//   }
//
//   void _calculateTotals() {
//     double sub = 0.0;
//     for (var item in invoiceItems) {
//       sub += item.qty * item.price;
//     }
//     subtotal.value = sub;
//
//     // Apply discount
//     double discountValue = 0.0;
//     if (discountType.value == 'percentage') {
//       discountValue = subtotal.value * (discountAmount.value / 100);
//     } else {
//       discountValue = discountAmount.value;
//     }
//
//     double afterDiscount = subtotal.value - discountValue;
//     taxAmount.value = afterDiscount * (taxRate.value / 100);
//     totalAmount.value = afterDiscount + taxAmount.value;
//   }
//
//   void updateTaxRate(double rate) {
//     taxRate.value = rate;
//     _calculateTotals();
//   }
//
//   void updateDiscount(double amount, String type) {
//     discountAmount.value = amount;
//     discountType.value = type;
//     _calculateTotals();
//   }
//
//   Future<void> selectDueDate() async {
//     final picked = await showDatePicker(
//       context: Get.context!,
//       initialDate: dueDate.value,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365)),
//     );
//
//     if (picked != null) {
//       dueDate.value = picked;
//       dueDateController.text = _formatDate(picked);
//     }
//   }
//
//   Future<void> saveInvoice({bool isDraft = false}) async {
//     if (!formKey.currentState!.validate()) return;
//     if (invoiceItems.isEmpty || invoiceItems.every((item) => item.itemName.isEmpty)) {
//       Get.snackbar('Error', 'Please add at least one item');
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       final user = _auth.currentUser;
//       if (user == null) {
//         Get.snackbar('Error', 'User not authenticated');
//         return;
//       }
//
//       // Get company ID
//       String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
//       if (companyId.isEmpty) {
//         Get.snackbar('Error', 'Company not selected');
//         return;
//       }
//
//       // Prepare invoice data using your Invoice model structure
//       final invoiceData = {
//         'invoiceNumber': invoiceNumberController.text,
//         'customerName': customerNameController.text,
//         'customerMobile': customerMobileController.text,
//         'customerEmail': customerEmailController.text,
//         'customerAddress': customerAddressController.text,
//         'customerId': selectedCustomer.value?['id'],
//         'invoiceDate': Timestamp.fromDate(selectedDate.value),
//         'dueDate': Timestamp.fromDate(dueDate.value),
//         'items': invoiceItems.map((item) => {
//           'itemName': item.itemName,
//           'itemId': item.itemId,
//           'qty': item.qty,
//           'price': item.price,
//           'total': item.qty * item.price,
//         }).toList(),
//         'subtotal': subtotal.value,
//         'taxRate': taxRate.value,
//         'taxAmount': taxAmount.value,
//         'discountAmount': discountAmount.value,
//         'discountType': discountType.value,
//         'totalAmount': totalAmount.value,
//         'status': isDraft ? 'draft' : 'pending',
//         'notes': notesController.text,
//         'createdAt': Timestamp.now(),
//         'updatedAt': Timestamp.now(),
//       };
//
//       // Save to Firestore
//       await _firestore
//           .collection("users")
//           .doc(user.uid)
//           .collection("companies")
//           .doc(companyId)
//           .collection("invoices")
//           .add(invoiceData);
//
//       showCustomSnackbar(
//         title: 'Success',
//         message: isDraft ? 'Invoice saved as draft' : 'Invoice created successfully',
//         baseColor: Colors.green,
//         icon: Icons.check_circle,
//       );
//
//       // Navigate back to dashboard
//       Get.back();
//
//     } catch (e) {
//       print("Error saving invoice: $e");
//       showCustomSnackbar(
//         title: 'Error',
//         message: 'Failed to save invoice: ${e.toString()}',
//         baseColor: Colors.red,
//         icon: Icons.error,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> saveNewCustomer() async {
//     if (customerNameController.text.isEmpty) {
//       Get.snackbar('Error', 'Customer name is required');
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       final user = _auth.currentUser;
//       if (user == null) return;
//
//       String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
//       if (companyId.isEmpty) return;
//
//       final customerData = {
//         'name': customerNameController.text,
//         'mobile': customerMobileController.text,
//         'email': customerEmailController.text,
//         'address': customerAddressController.text,
//         'isActive': true,
//         'createdAt': Timestamp.now(),
//         'updatedAt': Timestamp.now(),
//       };
//
//       // Save customer to Firestore
//       final docRef = await _firestore
//           .collection("users")
//           .doc(user.uid)
//           .collection("companies")
//           .doc(companyId)
//           .collection("customers")
//           .add(customerData);
//
//       // Add to local list
//       customerData['id'] = docRef.id;
//       customers.add(customerData);
//       customerCount.value = customers.length;
//
//       // Select this customer
//       selectCustomer(customerData);
//
//       showCustomSnackbar(
//         title: 'Success',
//         message: 'Customer added successfully',
//         baseColor: Colors.green,
//         icon: Icons.check_circle,
//       );
//
//     } catch (e) {
//       print("Error saving customer: $e");
//       showCustomSnackbar(
//         title: 'Error',
//         message: 'Failed to save customer',
//         baseColor: Colors.red,
//         icon: Icons.error,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Search customers
//   List<Map<String, dynamic>> searchCustomers(String query) {
//     if (query.isEmpty) return customers;
//
//     return customers.where((customer) {
//       final name = customer['name']?.toString().toLowerCase() ?? '';
//       final mobile = customer['mobile']?.toString().toLowerCase() ?? '';
//       final email = customer['email']?.toString().toLowerCase() ?? '';
//
//       return name.contains(query.toLowerCase()) ||
//           mobile.contains(query.toLowerCase()) ||
//           email.contains(query.toLowerCase());
//     }).toList();
//   }
//
//   // Search items
//   List<Item> searchItems(String query) {
//     if (query.isEmpty) return itemList;
//
//     return itemList.where((item) {
//       final name = item.itemName.toLowerCase();
//       return name.contains(query.toLowerCase());
//     }).toList();
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
//   }
//
//   // Helper method to show custom snackbar
//   void showCustomSnackbar({
//     required String title,
//     required String message,
//     required Color baseColor,
//     required IconData icon,
//   }) {
//     Get.snackbar(
//       title,
//       message,
//       backgroundColor: baseColor.withOpacity(0.9),
//       colorText: Colors.white,
//       icon: Icon(icon, color: Colors.white),
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 3),
//     );
//   }
//
//   // Get invoice summary for display
//   String get invoiceSummary {
//     return 'Items: ${invoiceItems.length}, Total: ₹${totalAmount.value.toStringAsFixed(2)}';
//   }
//
//   // Check if form is valid
//   bool get isFormValid {
//     return invoiceNumberController.text.isNotEmpty &&
//         customerNameController.text.isNotEmpty &&
//         invoiceItems.isNotEmpty &&
//         invoiceItems.any((item) => item.itemName.isNotEmpty);
//   }
//
//   // Reset form
//   void resetForm() {
//     customerNameController.clear();
//     customerMobileController.clear();
//     customerEmailController.clear();
//     customerAddressController.clear();
//     notesController.clear();
//
//     selectedCustomer.value = null;
//     showCustomerForm.value = false;
//
//     invoiceItems.clear();
//     addNewItem();
//
//     taxRate.value = 0.0;
//     discountAmount.value = 0.0;
//     discountType.value = 'amount';
//
//     _initializeInvoice();
//   }
//
//   // Validate customer data
//   String? validateCustomerName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Customer name is required';
//     }
//     return null;
//   }
//
//   String? validateMobile(String? value) {
//     if (value != null && value.isNotEmpty) {
//       if (value.length < 10) {
//         return 'Mobile number must be at least 10 digits';
//       }
//     }
//     return null;
//   }
//
//   String? validateEmail(String? value) {
//     if (value != null && value.isNotEmpty) {
//       if (!GetUtils.isEmail(value)) {
//         return 'Please enter a valid email';
//       }
//     }
//     return null;
//   }
//
//   // Validate invoice number
//   String? validateInvoiceNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Invoice number is required';
//     }
//     return null;
//   }
// }