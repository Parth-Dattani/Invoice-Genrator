import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constant/constant.dart';
import '../model/model.dart';
import '../services/service.dart';
import '../utils/shared_preferences_helper.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'controller.dart';


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
  final RxString selectedCustomerId = ''.obs;

  // Observable variables
  var isLoading = false.obs;
  var selectedCustomer = Rxn<Map<String, dynamic>>();
  var customers = <Map<String, dynamic>>[].obs;
  var items = <Map<String, dynamic>>[].obs;
  var itemList = <Item>[].obs;
  var invoiceList = <Invoice>[].obs;
  var invoiceItems = <InvoiceItem>[].obs;
  var selectedDate = DateTime.now().obs;
  var dueDate = DateTime.now().add(Duration(days: 30)).obs;
  var taxRate = 0.0.obs;
  var discountAmount = 0.0.obs;
  var discountType = 'amount'.obs;
  var showCustomerForm = false.obs;
  var customerCount = 0.obs;
  final invoiceType = InvoiceType.invoice.obs;

  // Calculated values
  var subtotal = 0.0.obs;
  var taxAmount = 0.0.obs;
  var totalAmount = 0.0.obs;

  // Company data
  var companyData = <String, dynamic>{}.obs;
  int _lastInvoiceId = 0;

  // Challan related variables
  var challanList = <Challan>[].obs;
  var challanItems = <ChallanItem>[].obs;
  var challanDate = DateTime.now().obs;
  final Rx<Challan?> selectedChallan = Rx<Challan?>(null);
  final RxList<Challan> allChallans = <Challan>[].obs;
  final RxList<String> customerNames = <String>[].obs;
  final RxString selectedCustomerForInvoice = ''.obs;
  final RxList<Challan> selectedCustomerChallans = <Challan>[].obs;
  final RxBool createFromChallan = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
    loadChallansForInvoice();
    initializeInvoice();
    loadCompanyData();
    loadCustomers();
    loadChallans();
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

  // Challan to Invoice methods
  Future<void> loadChallansForInvoice() async {
    try {
      isLoading.value = true;
      allChallans.value = await RemoteService.getChallans();

      // Extract unique customer names with null checks
      final uniqueCustomers = allChallans
          .map((challan) => challan.customerName)
          .where((name) => name != null && name.isNotEmpty)
          .toSet()
          .toList();

      customerNames.value = uniqueCustomers.cast<String>();

      print("Loaded ${allChallans.length} challans with ${customerNames.length} unique customers");

    } catch (e) {
      print('Error loading challans: $e');
      showCustomSnackbar(
        title: "Error",
        message: "Failed to load challans",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectCustomerForInvoice(String? customerName) {
    print("selectCustomerForInvoice called with: $customerName");
    selectedCustomerForInvoice.value = customerName ?? '';

    if (customerName != null && customerName.isNotEmpty) {
      try {
        // Get all challans for this customer with null check
        selectedCustomerChallans.value = allChallans
            .where((challan) => challan.customerName == customerName)
            .toList();

        if (selectedCustomerChallans.isNotEmpty) {
          // Populate invoice with combined challan items
          populateInvoiceFromCustomerChallans();
        } else {
          showCustomSnackbar(
            title: "No Challans",
            message: "No challans found for $customerName",
            baseColor: Colors.orange.shade700,
            icon: Icons.info_outline,
          );
        }
      } catch (e) {
        print("Error selecting customer for invoice: $e");
        showCustomSnackbar(
          title: "Error",
          message: "Failed to load challans for customer",
          baseColor: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      }
    } else {
      // Clear selection if no customer selected
      selectedCustomerChallans.clear();
    }
  }

  void populateInvoiceFromCustomerChallans() {
    print("populateInvoiceFromCustomerChallans called");
    print("Selected customer challans count: ${selectedCustomerChallans.length}");

    // Debug: Print all challan details to see what data we have
    for (var i = 0; i < selectedCustomerChallans.length; i++) {
      var challan = selectedCustomerChallans[i];
      print("Challan $i: ID=${challan.challanId}, CustomerID=${challan.customerId}, CustomerName=${challan.customerName}");
    }

    if (selectedCustomerChallans.isEmpty) return;

    // Clear existing items
    invoiceItems.clear();

    // Group challans by challanId (since each challan represents one item)
    final groupedChallans = <String, List<Challan>>{};

    for (var challan in selectedCustomerChallans) {
      if (!groupedChallans.containsKey(challan.challanId)) {
        groupedChallans[challan.challanId] = [];
      }
      groupedChallans[challan.challanId]!.add(challan);
    }

    print("Found ${groupedChallans.length} unique challan IDs");

    // Process each group of challans (each group represents one delivery)
    for (var challanGroup in groupedChallans.values) {
      if (challanGroup.isEmpty) continue;

      // Each challan in the group represents one item
      for (var challan in challanGroup) {
        try {
          // Convert Challan to InvoiceItem
          final invoiceItem = InvoiceItem(
            itemId: challan.itemId,
            description: challan.itemName,
            quantity: challan.qty,
            rate: challan.price,
            itemName: challan.itemName,
            totalPrice: challan.subtotal
          );

          // Check if item already exists (by description and rate)
          final existingItemIndex = invoiceItems.indexWhere(
                  (invItem) => invItem.description == invoiceItem.description && invItem.rate == invoiceItem.rate
          );

          if (existingItemIndex != -1) {
            // Update quantity if item exists
            invoiceItems[existingItemIndex] = invoiceItems[existingItemIndex].copyWith(
                quantity: invoiceItems[existingItemIndex].quantity + invoiceItem.quantity
            );

            print("Updated item: ${invoiceItem.description}, new quantity: ${invoiceItems[existingItemIndex].quantity}");
          } else {
            // Add new item
            invoiceItems.add(invoiceItem);
            print("Added new item: ${invoiceItem.description}");
          }
        } catch (e) {
          print("Error processing challan ${challan.challanId}: $e");
        }
      }
    }

    // Set customer information from the first challan
    if (selectedCustomerChallans.isNotEmpty) {
      final firstChallan = selectedCustomerChallans.first;
      customerNameController.text = firstChallan.customerName;
      customerMobileController.text = firstChallan.customerMobile;
      customerEmailController.text = firstChallan.customerEmail;
      customerAddressController.text = firstChallan.customerAddress;

      // CAPTURE CUSTOMER ID FROM CHALLAN
      selectedCustomerId.value = firstChallan.customerId;

      print("Set customer details: ${firstChallan.customerName}");
      print("Customer ID: ${firstChallan.customerId}");
    }

    calculateTotals();

    // Debug info
    print("Final invoice items count: ${invoiceItems.length}");
    for (var item in invoiceItems) {
      print("Item: ${item.description}, Qty: ${item.quantity}, Rate: ${item.rate}");
    }

    showCustomSnackbar(
      title: "Challans Combined",
      message: "Combined ${groupedChallans.length} challans for ${selectedCustomerForInvoice.value}",
      baseColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
    );
  }

  // Existing methods
  Future<void> loadChallans() async {
    try {
      isLoading.value = true;
      print("=== ATTEMPTING TO FETCH CHALLANS ===");

      List<Challan> challans = await RemoteService.getChallans();
      print("Final result: ${challans.length} challans found");

      for (var challan in challans) {
        print("Found challan: ${challan.challanId} - ${challan.customerName}");
      }

      challanList.assignAll(challans);

      if (challans.isEmpty) {
        showCustomSnackbar(
          title: "No Challans",
          message: "No challans found",
          baseColor: Colors.orange.shade700,
          icon: Icons.info_outline,
        );
      } else {
        showCustomSnackbar(
          title: "Success",
          message: "Found ${challans.length} challans",
          baseColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      }

    } catch (e) {
      print("Error in loadChallans(): $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to load challans: ${e.toString()}",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCompanyData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
      if (companyId.isEmpty) return;

      final companyDoc = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .get();

      if (companyDoc.exists) {
        companyData.value = companyDoc.data() ?? {};
        print("Company data loaded: ${companyData.value}");
      }
    } catch (e) {
      print("Error loading company data: $e");
    }
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

      customerCount.value = customers.length;
      print("Customer count: ${customerCount.value}");

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

      List<Item> items = await RemoteService.getItems(userId: userId);

      if (items.isEmpty) {
        print("Standard method failed, trying alternative...");
        items = await RemoteService.getItemsAlternative(userId);
      }

      print("Final result: ${items.length} items found");

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

  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;
      print("=== ATTEMPTING TO FETCH INVOICES ===");

      List<Invoice> invoices = await RemoteService.getInvoices();

      if (invoices.isEmpty) {
        print("Standard method failed, trying alternative...");
        invoices = await RemoteService.getInvoices();
      }

      print("Final result: ${invoices.length} invoices found");

      for (var invoice in invoices) {
        print("Found invoice: ${invoice.invoiceId} - Amount: ${invoice.totalAmount}");
      }

      invoiceList.assignAll(invoices);

      if (invoices.isEmpty) {
        showCustomSnackbar(
          title: "No Invoices",
          message: "No invoices found",
          baseColor: Colors.orange.shade700,
          icon: Icons.info_outline,
        );
      } else {
        showCustomSnackbar(
          title: "Success",
          message: "Found ${invoices.length} invoices",
          baseColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      }

    } catch (e) {
      print("Error in fetchInvoices2(): $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to load invoices: $e",
        baseColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void initializeInvoice() async {
    print("🆕 INITIALIZING INVOICE - Starting...");
    await loadInvoices();
    final newInvoiceId = generateInvoiceId();
    print("🆔 GENERATED NEW INVOICE ID: $newInvoiceId");
    invoiceNumberController.text = newInvoiceId;
    dueDateController.text = _formatDate(dueDate.value);
    print("📅 DUE DATE SET TO: ${dueDateController.text}");
    addNewItem();
    print("✅ INVOICE INITIALIZATION COMPLETE");
  }

  void setInvoiceType(InvoiceType type) {
    invoiceType.value = type;
    _generateInvoiceId();
  }

  String _generateInvoiceId() {
    final newId = generateInvoiceId();
    invoiceNumberController.text = newId;
    print("------------New ID---------${newId}");
    return newId;
  }

  String generateInvoiceId() {
    final sameTypeInvoices = invoiceList.where((inv) =>
    inv.invoiceId != null &&
        inv.invoiceId!.startsWith(invoiceType.value.prefix)
    ).toList();

    if (sameTypeInvoices.isEmpty) {
      return "${invoiceType.value.prefix}001";
    }

    final maxId = sameTypeInvoices.map((inv) {
      try {
        return int.parse(inv.invoiceId!.replaceAll(invoiceType.value.prefix, ''));
      } catch (e) {
        return 0;
      }
    }).reduce((max, current) => current > max ? current : max);

    return "${invoiceType.value.prefix}${(maxId + 1).toString().padLeft(3, '0')}";
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
    selectedCustomerId.value = customer['id'] ?? ''; // Make sure this captures the ID
    customerNameController.text = customer['name'] ?? '';
    customerMobileController.text = customer['mobile'] ?? '';
    customerEmailController.text = customer['email'] ?? '';
    customerAddressController.text = customer['address'] ?? '';
    showCustomerForm.value = false;

    print("Selected CustomerID: ${selectedCustomerId.value} ---- Name: ${customerNameController.text}");
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
      itemName: '',
      totalPrice: 0.0
    ));
    calculateTotals();
  }

  void updateItem(int index, {String? description, int? quantity, double? rate, String? itemId}) {
    if (index < invoiceItems.length) {
      final item = invoiceItems[index];
      invoiceItems[index] = InvoiceItem(
        description: description ?? item.description,
        quantity: quantity ?? item.quantity,
        rate: rate ?? item.rate,
        itemId: itemId ?? item.itemId,
        totalPrice: item.totalPrice,
        itemName: description ?? item.itemName
      );
      calculateTotals();
    }
  }

  void selectRemoteItemForIndex(int index, Item item) {
    if (index < invoiceItems.length) {
      invoiceItems[index] = InvoiceItem(
        description: item.itemName,
        quantity: invoiceItems[index].quantity,
        rate: item.price.toDouble(),
        itemId: item.itemId,
        itemName: item.itemName,
        totalPrice: item.price
      );
      calculateTotals();
    }
  }

  void removeItem(int index) {
    if (invoiceItems.length > 1) {
      invoiceItems.removeAt(index);
      calculateTotals();
    }
  }

  void calculateTotals() {
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
    calculateTotals();
  }

  void updateDiscount(double amount, String type) {
    discountAmount.value = amount;
    discountType.value = type;
    calculateTotals();
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

  Future<bool> saveInvoice({required bool isDraft}) async {
    try {
      if (!formKey.currentState!.validate()) {
        showCustomSnackbar(
          title: "Validation Error",
          message: "Please fill all required fields",
          baseColor: Colors.orange.shade700,
          icon: Icons.warning,
        );
        return false;
      }

      isLoading.value = true;

      // Get customer ID logic (keep your existing logic)
      String finalCustomerId = selectedCustomerId.value;
      // ... your existing customer ID logic ...

      // Create the main invoice record
      Map<String, dynamic> invoiceData = {
        'invoiceId': invoiceNumberController.text,
        'customerId': finalCustomerId,
        'customerName': customerNameController.text.trim(),
        'mobile': customerMobileController.text.trim(),
        'customerEmail': customerEmailController.text.trim(),
        'customerAddress': customerAddressController.text.trim(),
        'issueDate': DateTime.now().toIso8601String(),
        'dueDate': dueDate.value.toIso8601String(),
        'subtotal': subtotal.value,
        'taxRate': taxRate.value,
        'taxAmount': taxAmount.value,
        'discountAmount': discountAmount.value,
        'totalAmount': totalAmount.value,
        'notes': notesController.text,
        'status': isDraft ? 'draft' : 'issued',
        'userId': AppConstants.userId,
      };

      print("Saving invoice: ${invoiceData['invoiceId']}");

      // 1. First save the main invoice
      await RemoteService.addInvoice(invoiceData, AppConstants.userId);


      // 2. Then save each invoice item
      for (var item in invoiceItems) {
        Map<String, dynamic> invoiceItemData = {
          '_RowNumber': '',
          'invoiceId': invoiceNumberController.text, // This must match the main invoice ID
          'itemId': item.itemId,
          'itemName': item.description,
          'description': item.description,
          'quantity': item.quantity.toString(), // Convert to string if API expects string
          'price': item.rate.toString(), // Convert to string if API expects string
          'totalPrice': item.amount.toString(), // Convert to string if API expects string
        };

        print("Saving invoice item: ${jsonEncode(invoiceItemData)}");

         await RemoteService.addInvoiceItem(invoiceItemData, AppConstants.userId);


        // 3. Update stock (if needed)
        await _updateStockForItem(item.itemId, item.quantity);
      }

      showCustomSnackbar(
        title: "Success",
        message: "Invoice ${isDraft ? 'saved as draft' : 'created'} successfully!",
        baseColor: AppColors.darkGreenColor,
        icon: Icons.check_circle_outline,
      );

      if (!isDraft) {
        clearForm();
      }

      Get.back();
      return true;

    } catch (e) {
      print("Error saving invoice: $e");
      showCustomSnackbar(
        title: "Error",
        message: "Failed to save invoice: ${e.toString()}",
        baseColor: Colors.red.shade700,
        icon: Icons.error,
      );

      // Optional: Add rollback logic here if invoice was saved but items failed
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateStockForItem(String itemId, int quantity) async {
    try {
      // Implement your stock update logic here
      print("Updating stock for item $itemId, quantity: $quantity");
      // await _firestore.collection('items').doc(itemId).update({
      //   'stock': FieldValue.increment(-quantity)
      // });
    } catch (e) {
      print("Error updating stock for item $itemId: $e");
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
    calculateTotals();
  }

  void showCustomSnackbar({
    required String title,
    required String message,
    required Color baseColor,
    required IconData icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: baseColor,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      duration: Duration(seconds: 3),
    );
  }
}



enum InvoiceType {
  invoice,
  quotation,
}

extension InvoiceTypeExtension on InvoiceType {
  String get name {
    switch (this) {
      case InvoiceType.invoice:
        return 'Invoice';
      case InvoiceType.quotation:
        return 'Quotation';
    }
  }

  String get prefix {
    switch (this) {
      case InvoiceType.invoice:
        return 'INV';
      case InvoiceType.quotation:
        return 'QUO';
    }
  }
}



