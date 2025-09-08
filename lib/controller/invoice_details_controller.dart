import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../model/model.dart';
import '../services/remote_service.dart';
import '../utils/pdf_helper.dart';

// class InvoiceDetailsController extends GetxController {
//   final invoice = Rx<Invoice?>(null);
//   final isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Get the invoice passed as argument
//     final Invoice? passedInvoice = Get.arguments as Invoice?;
//     if (passedInvoice != null) {
//       invoice.value = passedInvoice;
//     }
//   }
//
//   void editInvoice() {
//     if (invoice.value != null) {
//       Get.toNamed('/edit-invoice', arguments: invoice.value);
//     }
//   }
//
//   void shareInvoice() {
//     // Implement share functionality
//     Get.snackbar(
//       'Share',
//       'Share functionality to be implemented',
//       backgroundColor: Colors.blue.shade100,
//       colorText: Colors.blue.shade800,
//     );
//   }
//
//   void downloadInvoice() {
//     // Implement download functionality
//     Get.snackbar(
//       'Download',
//       'Download functionality to be implemented',
//       backgroundColor: Colors.green.shade100,
//       colorText: Colors.green.shade800,
//     );
//   }
//
//   void deleteInvoice() async {
//     final confirmed = await Get.dialog(
//       AlertDialog(
//         title: Text('Delete Invoice?'),
//         content: Text('Are you sure you want to delete this invoice?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(result: false),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Get.back(result: true),
//             child: Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed == true) {
//       // Implement delete logic
//       Get.back(); // Go back to invoice list
//       Get.snackbar(
//         'Deleted',
//         'Invoice deleted successfully',
//         backgroundColor: Colors.green.shade100,
//         colorText: Colors.green.shade800,
//       );
//     }
//   }
// }

class InvoiceDetailsController extends GetxController {
  final invoice = Rx<Invoice?>(null);
  final invoiceItems = <InvoiceItem>[].obs;
  final isLoading = false.obs;
  final isLoadingItems = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the invoice passed as argument
    final Invoice? passedInvoice = Get.arguments as Invoice?;
    if (passedInvoice != null) {
      invoice.value = passedInvoice;
      loadInvoiceItems(passedInvoice.invoiceId);

    }
  }

  Future<void> loadInvoiceItems(String invoiceId) async {
    try {
      isLoading.value = true;
      print("Loading items for invoice: $invoiceId");

      // Fetch ONLY the items for this specific invoice
      List<InvoiceItem> items = await RemoteService.getInvoiceItemsByInvoiceId(invoiceId);
      invoiceItems.assignAll(items);

      print("✅ Successfully loaded ${items.length} items for invoice $invoiceId");

      // Add debug info
      if (items.isNotEmpty) {
        //print("First item invoiceId: ${items.first.invoiceId}");
        print("Items breakdown:");
        for (var item in items) {
          print("  - ${item.description}: Qty ${item.quantity} × \$${item.rate} = \$${item.totalPrice}");
        }
      }
    } catch (e) {
      print("Error loading invoice items: $e");
      Get.snackbar(
        'Error',
        'Failed to load invoice items: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void editInvoice() {
    if (invoice.value != null) {
      Get.toNamed('/edit-invoice', arguments: invoice.value);
    }
  }



  void downloadInvoice() {
    // Implement download functionality
    Get.snackbar(
      'Download',
      'Download functionality to be implemented',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
    );
  }

  void deleteInvoice() async {
    final confirmed = await Get.dialog(
      AlertDialog(
        title: Text('Delete Invoice?'),
        content: Text('Are you sure you want to delete this invoice?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        isLoading.value = true;

        // Delete from remote service
        if (invoice.value != null) {
          //await RemoteService.deleteInvoice(invoice.value!.invoiceId);
          await RemoteService.deleteInvoiceItems(invoice.value!.invoiceId);
        }

        Get.back(); // Go back to invoice list
        Get.snackbar(
          'Deleted',
          'Invoice deleted successfully',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete invoice: ${e.toString()}',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Calculate totals from loaded items
  double get itemsSubtotal {
    return invoiceItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void refreshInvoiceItems() {
    if (invoice.value != null) {
      loadInvoiceItems(invoice.value!.invoiceId);
    }
  }
}