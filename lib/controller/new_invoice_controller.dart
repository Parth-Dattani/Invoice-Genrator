import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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

  // In your NewInvoiceController
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  var selectedFromDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var selectedToDate = DateTime.now().obs;

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

    fromDateController.text = DateFormat('dd/MM/yyyy').format(selectedFromDate.value);
    toDateController.text = DateFormat('dd/MM/yyyy').format(selectedToDate.value);
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

    fromDateController.dispose();
    toDateController.dispose();

    super.onClose();
  }

  /// Challan to Invoice methods
  // Future<void> loadChallansForInvoice() async {
  //   try {
  //     isLoading.value = true;
  //     allChallans.value = await RemoteService.getChallans();
  //
  //     // Extract unique customer names with null checks
  //     final uniqueCustomers = allChallans
  //         .map((challan) => challan.customerName)
  //         .where((name) => name != null && name.isNotEmpty)
  //         .toSet()
  //         .toList();
  //
  //     customerNames.value = uniqueCustomers.cast<String>();
  //
  //     print("Loaded ${allChallans.length} challans with ${customerNames.length} unique customers");
  //
  //   } catch (e) {
  //     print('Error loading challans: $e');
  //     showCustomSnackbar(
  //       title: "Error",
  //       message: "Failed to load challans",
  //       baseColor: Colors.red.shade700,
  //       icon: Icons.error_outline,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  Future<void> loadChallansForInvoice() async {
    try {
      isLoading.value = true;

      // Clear previous data
      allChallans.clear();
      customerNames.clear();
      selectedCustomerChallans.clear();
      invoiceItems.clear();

      // FIX: Fetch challans WITH ITEMS, not just basic challan data
      final challans = await RemoteService.getChallansByDateRange(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        userId: AppConstants.userId,
      ); // Changed this line

      allChallans.assignAll(challans);

      // Extract unique customer names
      final names = challans.map((challan) => challan.customerName).toSet().toList();
      customerNames.assignAll(names);

      print("Loaded ${challans.length} challans with items for ${names.length} customers");

    } catch (e) {
      Get.snackbar('Error', 'Failed to load challans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCustomerForInvoice(String? customerName) async {
    print("selectCustomerForInvoice called with: $customerName");
    selectedCustomerForInvoice.value = customerName ?? '';

    if (customerName != null && customerName.isNotEmpty) {
      try {
        isLoading.value = true;

        // Clear previous selection
        selectedCustomerChallans.clear();
        invoiceItems.clear();

        print("Loading challans with items for customer: $customerName");

        // Load ONLY the challans for this specific customer WITH ITEMS
        List<Challan> customerChallans = await RemoteService.getChallansWithItemsByCustomer(customerName);

// DOUBLE-CHECK: Filter by customer name AND ID to ensure no mixed data
        selectedCustomerChallans.value = customerChallans.where(
                (challan) => challan.customerName == customerName
        ).toList();

        /// Load ONLY the challans for this specific customer WITH ITEMS
        //selectedCustomerChallans.value = await RemoteService.getChallansWithItemsByCustomer(customerName);

        print("Found ${selectedCustomerChallans.length} challans for $customerName");

        if (selectedCustomerChallans.isNotEmpty) {
          populateInvoiceFromCustomerChallans();

          showCustomSnackbar(
            title: "Success",
            message: "Loaded ${selectedCustomerChallans.length} challans for $customerName",
            baseColor: Colors.green.shade700,
            icon: Icons.check_circle_outline,
          );
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
      } finally {
        isLoading.value = false;
      }
    } else {
      selectedCustomerChallans.clear();
      invoiceItems.clear();
    }
  }

  void populateInvoiceFromCustomerChallans2() {
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

  /// working Existing methods 9-9- Eving
  // Future<void> loadChallans() async {
  //   try {
  //     isLoading.value = true;
  //     print("=== ATTEMPTING TO FETCH CHALLANS ===");
  //
  //     List<Challan> challans = await RemoteService.getChallans();
  //     print("Final result: ${challans.length} challans found");
  //
  //     for (var challan in challans) {
  //       print("Found challan: ${challan.challanId} - ${challan.customerName}");
  //     }
  //
  //     challanList.assignAll(challans);
  //
  //     if (challans.isEmpty) {
  //       showCustomSnackbar(
  //         title: "No Challans",
  //         message: "No challans found",
  //         baseColor: Colors.orange.shade700,
  //         icon: Icons.info_outline,
  //       );
  //     } else {
  //       showCustomSnackbar(
  //         title: "Success",
  //         message: "Found ${challans.length} challans",
  //         baseColor: Colors.green.shade700,
  //         icon: Icons.check_circle_outline,
  //       );
  //     }
  //
  //   } catch (e) {
  //     print("Error in loadChallans(): $e");
  //     showCustomSnackbar(
  //       title: "Error",
  //       message: "Failed to load challans: ${e.toString()}",
  //       baseColor: Colors.red.shade700,
  //       icon: Icons.error_outline,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


/// OPTION 1: Don't combine items - Show each challan's items separately
//   void populateInvoiceFromCustomerChallans() {
//     print("=== POPULATING INVOICE (SEPARATE ITEMS) ===");
//
//     invoiceItems.clear();
//
//     if (selectedCustomerChallans.isEmpty) {
//       print("No challans selected");
//       return;
//     }
//
//     final String targetCustomerId = selectedCustomerChallans.first.customerId;
//     final String targetCustomerName = selectedCustomerChallans.first.customerName;
//
//     print("Target Customer: $targetCustomerName (ID: $targetCustomerId)");
//
//     final filteredChallans = selectedCustomerChallans.where(
//             (challan) => challan.customerId == targetCustomerId
//     ).toList();
//
//     for (var challan in filteredChallans) {
//       print("Processing challan: ${challan.challanId}");
//
//       if (challan.items != null && challan.items!.isNotEmpty) {
//         for (var challanItem in challan.items!) {
//           bool challanMatches = challan.customerId == targetCustomerId;
//           bool itemMatches = challanItem.customerId == targetCustomerId;
//
//           if (challanMatches && itemMatches) {
//             // Create unique item by adding challan ID
//             final invoiceItem = InvoiceItem(
//               itemId: "${challanItem.itemId}_${challan.challanId}",
//               description: "${challanItem.itemName} (${challan.challanId})",
//               quantity: challanItem.quantity,
//               rate: challanItem.price,
//               itemName: "${challanItem.itemName} (${challan.challanId})",
//               totalPrice: challanItem.totalPrice,
//             );
//
//             invoiceItems.add(invoiceItem);
//             print("Added: ${invoiceItem.itemName}, Qty: ${invoiceItem.quantity}");
//           }
//         }
//       }
//     }
//
//     calculateTotals();
//     print("Invoice populated with ${invoiceItems.length} separate items");
//   }

  // OPTION 2: Use only the FIRST occurrence of each item
  /// OPTION 3: Use only the LATEST occurrence of each item
  // void populateInvoiceFromCustomerChallans() {
  //   print("=== POPULATING INVOICE (LATEST OCCURRENCE ONLY) ===");
  //
  //   invoiceItems.clear();
  //   Map<String, InvoiceItem> latestItems = {}; // Track latest version of each item
  //
  //   if (selectedCustomerChallans.isEmpty) {
  //     print("No challans selected");
  //     return;
  //   }
  //
  //   final String targetCustomerId = selectedCustomerChallans.first.customerId;
  //   final String targetCustomerName = selectedCustomerChallans.first.customerName;
  //
  //   print("Target Customer: $targetCustomerName (ID: $targetCustomerId)");
  //
  //   final filteredChallans = selectedCustomerChallans.where(
  //           (challan) => challan.customerId == targetCustomerId
  //   ).toList();
  //
  //   for (var challan in filteredChallans) {
  //     print("Processing challan: ${challan.challanId}");
  //
  //     if (challan.items != null && challan.items!.isNotEmpty) {
  //       for (var challanItem in challan.items!) {
  //         bool challanMatches = challan.customerId == targetCustomerId;
  //         bool itemMatches = challanItem.customerId == targetCustomerId;
  //
  //         if (challanMatches && itemMatches) {
  //           String itemKey = challanItem.itemName.toLowerCase().trim();
  //
  //           final invoiceItem = InvoiceItem(
  //             itemId: challanItem.itemId,
  //             description: challanItem.itemName,
  //             quantity: challanItem.quantity,
  //             rate: challanItem.price,
  //             itemName: challanItem.itemName,
  //             totalPrice: challanItem.totalPrice,
  //           );
  //
  //           latestItems[itemKey] = invoiceItem; // This will overwrite previous occurrences
  //           print("Updated latest occurrence: ${invoiceItem.itemName}, Qty: ${invoiceItem.quantity}");
  //         }
  //       }
  //     }
  //   }
  //
  //   // Add all latest items to invoice
  //   invoiceItems.addAll(latestItems.values);
  //
  //   calculateTotals();
  //   print("Invoice populated with ${invoiceItems.length} unique items (latest occurrence only)");
  // }

  /// OPTION 4: Let user choose which challans to include (RECOMMENDED)
  // void populateInvoiceFromCustomerChallans() {
  //   print("=== POPULATING INVOICE (USER SELECTED CHALLANS ONLY) ===");
  //
  //   invoiceItems.clear();
  //
  //   if (selectedCustomerChallans.isEmpty) {
  //     print("No challans selected");
  //     return;
  //   }
  //
  //   final String targetCustomerId = selectedCustomerChallans.first.customerId;
  //   final String targetCustomerName = selectedCustomerChallans.first.customerName;
  //
  //   print("Target Customer: $targetCustomerName (ID: $targetCustomerId)");
  //
  //   // Only process the SPECIFICALLY SELECTED challans
  //   // Don't filter by customer ID again - trust user's selection
  //   for (var challan in selectedCustomerChallans) {
  //     print("Processing SELECTED challan: ${challan.challanId}");
  //
  //     if (challan.items != null && challan.items!.isNotEmpty) {
  //       for (var challanItem in challan.items!) {
  //         bool challanMatches = challan.customerId == targetCustomerId;
  //         bool itemMatches = challanItem.customerId == targetCustomerId;
  //
  //         if (challanMatches && itemMatches) {
  //           print("✓ Adding item from SELECTED challan ${challan.challanId}: ${challanItem.itemName} (Qty: ${challanItem.quantity})");
  //
  //           final invoiceItem = InvoiceItem(
  //             itemId: "${challanItem.itemId}_${challan.challanId}", // Make unique
  //             description: challanItem.itemName,
  //             quantity: challanItem.quantity,
  //             rate: challanItem.price,
  //             itemName: challanItem.itemName,
  //             totalPrice: challanItem.totalPrice,
  //           );
  //
  //           invoiceItems.add(invoiceItem); // Don't use _addOrUpdateInvoiceItem
  //         }
  //       }
  //     }
  //   }
  //
  //   calculateTotals();
  //   print("Invoice populated with ${invoiceItems.length} items from selected challans");
  // }
///
//   void populateInvoiceFromCustomerChallans() {
//     print("=== POPULATING INVOICE (USER SELECTED CHALLANS ONLY) ===");
//
//     invoiceItems.clear();
//
//     if (selectedCustomerChallans.isEmpty) {
//       print("No challans selected");
//       return;
//     }
//
//     final String targetCustomerId = selectedCustomerChallans.first.customerId;
//     final String targetCustomerName = selectedCustomerChallans.first.customerName;
//
//     print("Target Customer: $targetCustomerName (ID: $targetCustomerId)");
//     print("Selected challans count: ${selectedCustomerChallans.length}");
//
//     // DEBUG: Print all selected challans to see duplicates
//     print("=== DEBUG: All selected challans ===");
//     for (int i = 0; i < selectedCustomerChallans.length; i++) {
//       print("Index $i: ${selectedCustomerChallans[i].challanId} - ${selectedCustomerChallans[i].customerName}");
//     }
//
//     // SOLUTION 1: Remove duplicates by challanId
//     Map<String, Challan> uniqueChallans = {};
//     for (var challan in selectedCustomerChallans) {
//       if (challan.customerId == targetCustomerId) {
//         uniqueChallans[challan.challanId] = challan;
//       }
//     }
//
//     print("=== After removing duplicates ===");
//     print("Unique challans: ${uniqueChallans.keys.toList()}");
//
//     // Process only unique challans
//     for (var challan in uniqueChallans.values) {
//       print("Processing UNIQUE challan: ${challan.challanId}");
//
//       if (challan.items != null && challan.items!.isNotEmpty) {
//         for (var challanItem in challan.items!) {
//           bool challanMatches = challan.customerId == targetCustomerId;
//           bool itemMatches = challanItem.customerId == targetCustomerId;
//
//           if (challanMatches && itemMatches) {
//             print("✓ Adding item from challan ${challan.challanId}: ${challanItem.itemName} (Qty: ${challanItem.quantity})");
//
//             final invoiceItem = InvoiceItem(
//               itemId: "${challanItem.itemId}_${challan.challanId}", // Make unique
//               description: challanItem.itemName,
//               quantity: challanItem.quantity,
//               rate: challanItem.price,
//               itemName: challanItem.itemName,
//               totalPrice: challanItem.totalPrice,
//             );
//
//             invoiceItems.add(invoiceItem);
//           }
//         }
//       }
//     }
//
//     calculateTotals();
//     print("Invoice populated with ${invoiceItems.length} items from ${uniqueChallans.length} unique challans");
//   }


  void debugChallanData() {
    print("=== DEBUGGING CHALLAN DATA STRUCTURE ===");

    if (selectedCustomerChallans.isEmpty) {
      print("No challans selected");
      return;
    }

    final String targetCustomerId = selectedCustomerChallans.first.customerId;

    // Remove duplicates first
    Map<String, Challan> uniqueChallans = {};
    for (var challan in selectedCustomerChallans) {
      if (challan.customerId == targetCustomerId) {
        uniqueChallans[challan.challanId] = challan;
      }
    }

    print("Customer ID: $targetCustomerId");
    print("Unique challans count: ${uniqueChallans.length}");

    // Debug each challan's data
    for (var challan in uniqueChallans.values) {
      print("\n--- CHALLAN ${challan.challanId} ---");
      print("Customer ID: ${challan.customerId}");
      print("Customer Name: ${challan.customerName}");

      if (challan.items != null && challan.items!.isNotEmpty) {
        print("Items count: ${challan.items!.length}");

        for (int i = 0; i < challan.items!.length; i++) {
          var item = challan.items![i];
          print("  Item $i:");
          print("    ItemID: ${item.itemId}");
          print("    ItemName: ${item.itemName}");
          print("    Quantity: ${item.quantity}");
          print("    Price: ${item.price}");
          print("    CustomerID: ${item.customerId}");
          print("    TotalPrice: ${item.totalPrice}");
        }
      } else {
        print("No items found!");
      }
    }
  }

// Enhanced populate method with better filtering working-10 23 pm
  void populateInvoiceFromCustomerChallans() {
    print("=== POPULATING INVOICE (FIXED VERSION) ===");

    invoiceItems.clear();

    if (selectedCustomerChallans.isEmpty) {
      print("No challans selected");
      return;
    }

    final String targetCustomerId = selectedCustomerChallans.first.customerId;
    final String targetCustomerName = selectedCustomerChallans.first.customerName;

    print("Target Customer: $targetCustomerName (ID: $targetCustomerId)");

    // Remove duplicates by challanId
    Map<String, Challan> uniqueChallans = {};
    for (var challan in selectedCustomerChallans) {
      if (challan.customerId == targetCustomerId) {
        uniqueChallans[challan.challanId] = challan;
      }
    }

    print("Processing ${uniqueChallans.length} unique challans");

    // Process each unique challan
    for (var challan in uniqueChallans.values) {
      print("\n--- Processing challan: ${challan.challanId} ---");

      if (challan.items != null && challan.items!.isNotEmpty) {
        // Filter items that belong to THIS specific challan AND customer
        var validItems = challan.items!.where((item) =>
        item.customerId == targetCustomerId &&
            // ADD THIS: Check if item actually belongs to this challan
            (item.challanId == challan.challanId || item.challanId == null)
        ).toList();

        print("Valid items for ${challan.challanId}: ${validItems.length}");

        for (var challanItem in validItems) {
          print("✓ Adding: ${challanItem.itemName} (Qty: ${challanItem.quantity}) from ${challan.challanId}");

          final invoiceItem = InvoiceItem(
            itemId: "${challanItem.itemId}_${challan.challanId}",
            description: challanItem.itemName,
            quantity: challanItem.quantity,
            rate: challanItem.price,
            itemName: "${challanItem.itemName} (${challan.challanId})", // Show which challan
            totalPrice: challanItem.totalPrice,
          );

          invoiceItems.add(invoiceItem);
        }
      }
    }

    calculateTotals();
    print("\nInvoice populated with ${invoiceItems.length} items from ${uniqueChallans.length} unique challans");
  }

// ALTERNATIVE: Clean the selectedCustomerChallans list first
  void cleanAndPopulateInvoice() {
    print("=== CLEANING DUPLICATES FIRST ===");

    if (selectedCustomerChallans.isEmpty) {
      print("No challans selected");
      return;
    }

    // Get unique challans only
    Map<String, Challan> uniqueChallansMap = {};
    for (var challan in selectedCustomerChallans) {
      uniqueChallansMap[challan.challanId] = challan;
    }

    // Replace selectedCustomerChallans with unique ones
    selectedCustomerChallans.clear();
    selectedCustomerChallans.addAll(uniqueChallansMap.values);

    print("Cleaned duplicates. Unique challans: ${selectedCustomerChallans.length}");

    // Now call the normal populate function
    populateInvoiceFromCustomerChallans();
  }

// Fix in your challan selection method
  void selectChallan(Challan challan) {
    // Check if already selected
    bool alreadySelected = selectedCustomerChallans.any(
            (selected) => selected.challanId == challan.challanId
    );

    if (!alreadySelected) {
      selectedCustomerChallans.add(challan);
      print("Selected challan: ${challan.challanId}");
    } else {
      print("Challan ${challan.challanId} already selected");
    }
  }

// Fix in your challan deselection method
  void deselectChallan(Challan challan) {
    selectedCustomerChallans.removeWhere(
            (selected) => selected.challanId == challan.challanId
    );
    print("Deselected challan: ${challan.challanId}");
  }

// Method to clear all selections
  void clearChallanSelections() {
    selectedCustomerChallans.clear();
    print("Cleared all challan selections");
  }


  // Enhanced _addOrUpdateInvoiceItem method with detailed logging
  void _addOrUpdateInvoiceItem(InvoiceItem newItem) {
    print("_addOrUpdateInvoiceItem called with: ${newItem.itemName}, Qty: ${newItem.quantity}");

    // Check if item already exists
    final existingItemIndex = invoiceItems.indexWhere(
            (item) => item.itemId == newItem.itemId ||
            (item.itemName.toLowerCase().trim() == newItem.itemName.toLowerCase().trim())
    );

    if (existingItemIndex != -1) {
      // Item exists - decide how to handle it
      final existingItem = invoiceItems[existingItemIndex];
      print("Item already exists: ${existingItem.itemName}, Current Qty: ${existingItem.quantity}");

      // OPTION 1: Add quantities together (current behavior)
      final updatedQuantity = existingItem.quantity + newItem.quantity;
      print("Adding quantities: ${existingItem.quantity} + ${newItem.quantity} = $updatedQuantity");

      // OPTION 2: Replace with new quantity (uncomment if you want this behavior)
      // final updatedQuantity = newItem.quantity;
      // print("Replacing quantity: ${existingItem.quantity} -> ${newItem.quantity}");

      // OPTION 3: Keep existing quantity (uncomment if you want this behavior)
      // final updatedQuantity = existingItem.quantity;
      // print("Keeping existing quantity: ${existingItem.quantity}");

      final updatedItem = InvoiceItem(
        itemId: existingItem.itemId,
        description: existingItem.description,
        quantity: updatedQuantity,
        rate: newItem.rate, // Use new rate or keep existing?
        itemName: existingItem.itemName,
        totalPrice: updatedQuantity * newItem.rate,
      );

      invoiceItems[existingItemIndex] = updatedItem;
      print("Updated item: ${updatedItem.itemName}, New Qty: ${updatedItem.quantity}");

    } else {
      // New item - just add it
      print("Adding new item: ${newItem.itemName}, Qty: ${newItem.quantity}");
      invoiceItems.add(newItem);
    }
  }


  Future<void> loadChallans() async {
    try {
      isLoading.value = true;
      print("=== FETCHING CHALLANS WITH ITEMS FROM APPSHEET ===");

      // Use the new method that includes items
      List<Challan> challans = await RemoteService.getChallansWithItems();
      print("Final result: ${challans.length} challans found");

      // Detailed logging
      int totalItems = 0;
      for (var challan in challans) {
        totalItems += challan.items?.length ?? 0;
      }
      print("Total items across all challans: $totalItems");

      // Log each challan with items
      for (var i = 0; i < challans.length; i++) {
        var challan = challans[i];
        RemoteService.getChallanItemsByChallanId(challan.challanId);
        print("\nChallan ${i + 1}: ${challan.challanId}");
        print("  - Customer: ${challan.customerName}");
        print("  - Items: ${challan.items?.length ?? 0}");

        if (challan.items != null && challan.items!.isNotEmpty) {
          for (var j = 0; j < challan.items!.length; j++) {
            var item = challan.items![j];
            print("    Item ${j + 1}: ${item.itemName}");
            print("      - ID: ${item.itemId}");
            print("      - Qty: ${item.quantity}");
            print("      - Price: ${item.price}");
            print("      - Total: ${item.totalPrice}");
          }
        } else {
          print("    - NO ITEMS FOUND");
        }
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
          message: "Found ${challans.length} challans with $totalItems items",
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

  ///Workig just comment 5-6- 99
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



  Future<String> _findCustomerIdByNameOrPhone(String name, String phone) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return '';

      String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
      if (companyId.isEmpty) return '';

      // Search by name
      final nameQuery = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .collection("customers")
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (nameQuery.docs.isNotEmpty) {
        return nameQuery.docs.first.id;
      }

      // Search by phone if name not found
      if (phone.isNotEmpty) {
        final phoneQuery = await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("companies")
            .doc(companyId)
            .collection("customers")
            .where('mobile', isEqualTo: phone)
            .limit(1)
            .get();

        if (phoneQuery.docs.isNotEmpty) {
          return phoneQuery.docs.first.id;
        }
      }

      return '';
    } catch (e) {
      print("Error finding customer: $e");
      return '';
    }
  }

  Future<String> _createCustomerFromChallanData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return '';

      String companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
      if (companyId.isEmpty) return '';

      // Create new customer document
      final newCustomerRef = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("companies")
          .doc(companyId)
          .collection("customers")
          .add({
        'name': customerNameController.text.trim(),
        'mobile': customerMobileController.text.trim(),
        'email': customerEmailController.text.trim(),
        'address': customerAddressController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      return newCustomerRef.id;
    } catch (e) {
      print("Error creating customer: $e");
      return '';
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

    initializeInvoice();
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

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedFromDate.value) {
      selectedFromDate.value = picked;
      fromDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      // Reload challans with new date range
      loadChallansForInvoice();
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedToDate.value) {
      selectedToDate.value = picked;
      toDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      // Reload challans with new date range
      loadChallansForInvoice();
    }
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



