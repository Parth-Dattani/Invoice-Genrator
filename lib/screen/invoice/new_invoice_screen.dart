// new_invoice_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_prac_getx/model/item_model.dart';
import 'package:flutter/foundation.dart';

// class NewInvoiceScreen extends GetView<NewInvoiceController> {
//   static const String pageId = '/NewInvoiceScreen';
//
//   const NewInvoiceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Invoice'),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//         actions: [
//           Obx(() => controller.isLoading.value
//               ? Padding(
//             padding: EdgeInsets.all(16),
//             child: SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           )
//               : Row(
//             children: [
//               TextButton(
//                 onPressed: () => controller.saveInvoice(isDraft: true),
//                 child: Text(
//                   'Save Draft',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => controller.saveInvoice(isDraft: false),
//                 child: Text(
//                   'Create Invoice',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           )),
//         ],
//       ),
//       body: Form(
//         key: controller.formKey,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Invoice Details Section
//               _buildInvoiceDetailsCard(),
//
//               SizedBox(height: 16),
//
//               // Customer Section
//               _buildCustomerSection(),
//
//               SizedBox(height: 16),
//
//               // Items Section
//               _buildItemsSection(),
//
//               SizedBox(height: 16),
//
//               // Calculations Section
//               _buildCalculationsSection(),
//
//               SizedBox(height: 16),
//
//               // Notes Section
//               _buildNotesSection(),
//
//               SizedBox(height: 32),
//
//               // Action Buttons
//               _buildActionButtons(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInvoiceDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Invoice Details',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade700,
//               ),
//             ),
//             SizedBox(height: 16),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: controller.invoiceNumberController,
//                     decoration: InputDecoration(
//                       labelText: 'Invoice Number',
//                       prefixIcon: Icon(Icons.receipt),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter invoice number';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: TextFormField(
//                     controller: controller.dueDateController,
//                     decoration: InputDecoration(
//                       labelText: 'Due Date',
//                       prefixIcon: Icon(Icons.calendar_today),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     readOnly: true,
//                     onTap: controller.selectDueDate,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select due date';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomerSection() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Customer Information',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade700,
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                   onPressed: controller.toggleCustomerForm,
//                   icon: Icon(
//                     controller.showCustomerForm.value
//                         ? Icons.person
//                         : Icons.person_add,
//                     color: Colors.blue.shade700,
//                   ),
//                   tooltip: controller.showCustomerForm.value
//                       ? 'Select from existing customers'
//                       : 'Add new customer manually',
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Customer dropdown
//             if (!controller.showCustomerForm.value)
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: DropdownButton<Map<String, dynamic>>(
//                     value: controller.selectedCustomer.value,
//                     isExpanded: true,
//                     hint: Text('Select Customer'),
//                     underline: SizedBox(),
//                     items: [
//                       DropdownMenuItem(
//                         value: null,
//                         child: Text('Select Customer'),
//                       ),
//                       ...controller.customers.map((customer) {
//                         return DropdownMenuItem(
//                           value: customer,
//                           child: Text(customer['name'] ?? 'Unknown Customer'),
//                         );
//                       }).toList(),
//                     ],
//                     onChanged: controller.selectCustomer,
//                   ),
//                 );
//               }),
//
//             // Show selected customer info or form
//             Obx(() {
//               if (controller.selectedCustomer.value != null &&
//                   !controller.showCustomerForm.value) {
//                 final customer = controller.selectedCustomer.value!;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 12),
//                     Text(
//                       'Selected Customer:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green.shade700,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text('Name: ${customer['name'] ?? ''}'),
//                     if (customer['mobile'] != null && customer['mobile'].isNotEmpty)
//                       Text('Mobile: ${customer['mobile']}'),
//                     if (customer['email'] != null && customer['email'].isNotEmpty)
//                       Text('Email: ${customer['email']}'),
//                   ],
//                 );
//               } else if (controller.showCustomerForm.value) {
//                 return Column(
//                   children: [
//                     SizedBox(height: 12),
//                     Text(
//                       'Add New Customer',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.orange.shade700,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     TextFormField(
//                       controller: controller.customerNameController,
//                       decoration: InputDecoration(
//                         labelText: 'Customer Name *',
//                         prefixIcon: Icon(Icons.person),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter customer name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: controller.customerMobileController,
//                             decoration: InputDecoration(
//                               labelText: 'Mobile Number',
//                               prefixIcon: Icon(Icons.phone),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             keyboardType: TextInputType.phone,
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: TextFormField(
//                             controller: controller.customerEmailController,
//                             decoration: InputDecoration(
//                               labelText: 'Email',
//                               prefixIcon: Icon(Icons.email),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12),
//                     TextFormField(
//                       controller: controller.customerAddressController,
//                       decoration: InputDecoration(
//                         labelText: 'Address',
//                         prefixIcon: Icon(Icons.location_on),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       maxLines: 2,
//                     ),
//                   ],
//                 );
//               }
//               return SizedBox();
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItemsSection() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Invoice Items',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade700,
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                   onPressed: controller.addNewItem,
//                   icon: Icon(Icons.add_circle, color: Colors.green),
//                   tooltip: 'Add Item',
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Debug info (remove in production)
//             if (kDebugMode)
//               Obx(() => Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   'Debug: ${controller.itemList.length} items loaded from RemoteService',
//                   style: TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               )),
//             if (kDebugMode) SizedBox(height: 8),
//
//             Obx(() => Column(
//               children: controller.invoiceItems.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 InvoiceItem item = entry.value;
//
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 12),
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Item ${index + 1}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                           Spacer(),
//                           if (controller.invoiceItems.length > 1)
//                             IconButton(
//                               onPressed: () => controller.removeItem(index),
//                               icon: Icon(Icons.delete, color: Colors.red, size: 20),
//                             ),
//                         ],
//                       ),
//
//                       SizedBox(height: 8),
//
//                       // Item dropdown - UPDATED to use itemList from RemoteService
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: DropdownButton<Item>(
//                           value: controller.itemList.firstWhereOrNull(
//                                   (element) => element.itemId == item.itemId
//                           ),
//                           isExpanded: true,
//                           hint: Text('Select Item'),
//                           underline: SizedBox(),
//                           items: [
//                             DropdownMenuItem(
//                               value: null,
//                               child: Text('Select Item'),
//                             ),
//                             ...controller.itemList.map((item) {
//                               return DropdownMenuItem(
//                                 value: item,
//                                 child: Text('${item.itemName} - ₹${item.price}'),
//                               );
//                             }).toList(),
//                           ],
//                           onChanged: (selectedItem) {
//                             if (selectedItem != null) {
//                               controller.selectRemoteItemForIndex(index, selectedItem);
//                             }
//                           },
//                         ),
//                       ),
//
//                       SizedBox(height: 8),
//
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               initialValue: item.quantity.toString(),
//                               decoration: InputDecoration(
//                                 labelText: 'Qty',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                               ),
//                               keyboardType: TextInputType.number,
//                               onChanged: (value) {
//                                 int? qty = int.tryParse(value);
//                                 if (qty != null && qty > 0) {
//                                   controller.updateItem(index, quantity: qty);
//                                 }
//                               },
//                             ),
//                           ),
//
//                           SizedBox(width: 12),
//
//                           Expanded(
//                             flex: 3,
//                             child: TextFormField(
//                               initialValue: item.rate.toString(),
//                               decoration: InputDecoration(
//                                 labelText: 'Rate',
//                                 prefixText: '₹ ',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                               ),
//                               keyboardType: TextInputType.numberWithOptions(decimal: true),
//                               onChanged: (value) {
//                                 double? rate = double.tryParse(value);
//                                 if (rate != null && rate >= 0) {
//                                   controller.updateItem(index, rate: rate);
//                                 }
//                               },
//                             ),
//                           ),
//
//                           SizedBox(width: 12),
//
//                           Expanded(
//                             flex: 3,
//                             child: Container(
//                               padding: EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 '₹ ${item.amount.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue.shade700,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCalculationsSection() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Calculations',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade700,
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Tax Rate Input
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Tax Rate (%)',
//                       prefixIcon: Icon(Icons.percent),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     onChanged: (value) {
//                       double? rate = double.tryParse(value);
//                       if (rate != null && rate >= 0) {
//                         controller.updateTaxRate(rate);
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Discount',
//                       prefixIcon: Icon(Icons.discount),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       suffixIcon: Obx(() => DropdownButton<String>(
//                         value: controller.discountType.value,
//                         underline: SizedBox(),
//                         items: [
//                           DropdownMenuItem(value: 'amount', child: Text('₹')),
//                           DropdownMenuItem(value: 'percentage', child: Text('%')),
//                         ],
//                         onChanged: (value) {
//                           if (value != null) {
//                             controller.updateDiscount(
//                               controller.discountAmount.value,
//                               value,
//                             );
//                           }
//                         },
//                       )),
//                     ),
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     onChanged: (value) {
//                       double? discount = double.tryParse(value);
//                       if (discount != null && discount >= 0) {
//                         controller.updateDiscount(
//                           discount,
//                           controller.discountType.value,
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 20),
//             Divider(),
//
//             // Totals
//             Obx(() => Column(
//               children: [
//                 _buildTotalRow('Subtotal', controller.subtotal.value),
//                 if (controller.discountAmount.value > 0)
//                   _buildTotalRow(
//                     'Discount',
//                     controller.discountType.value == 'percentage'
//                         ? controller.subtotal.value * (controller.discountAmount.value / 100)
//                         : controller.discountAmount.value,
//                     isDiscount: true,
//                   ),
//                 if (controller.taxRate.value > 0)
//                   _buildTotalRow('Tax (${controller.taxRate.value}%)', controller.taxAmount.value),
//                 Divider(),
//                 _buildTotalRow('Total Amount', controller.totalAmount.value, isTotal: true),
//               ],
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTotalRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 16,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.blue.shade700 : Colors.black87,
//             ),
//           ),
//           Text(
//             '${isDiscount ? '-' : ''}₹ ${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 16,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isDiscount ? Colors.red : (isTotal ? Colors.blue.shade700 : Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNotesSection() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Additional Notes',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade700,
//               ),
//             ),
//             SizedBox(height: 16),
//
//             TextFormField(
//               controller: controller.notesController,
//               decoration: InputDecoration(
//                 hintText: 'Add any additional notes or terms...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               maxLines: 4,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Obx(() => Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: controller.isLoading.value ? null : () => Get.back(),
//             style: OutlinedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text('Cancel'),
//           ),
//         ),
//
//         SizedBox(width: 16),
//
//         Expanded(
//           child: ElevatedButton(
//             onPressed: controller.isLoading.value
//                 ? null
//                 : () => controller.saveInvoice(isDraft: true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey.shade600,
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: controller.isLoading.value
//                 ? SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//                 : Text('Save Draft', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//
//         SizedBox(width: 16),
//
//         Expanded(
//           child: ElevatedButton(
//             onPressed: controller.isLoading.value
//                 ? null
//                 : () => controller.saveInvoice(isDraft: false),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade700,
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: controller.isLoading.value
//                 ? SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//                 : Text('Create Invoice', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ],
//     ));
//   }
// }

///
///
///
///
///
///

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class NewInvoiceScreen extends GetView<NewInvoiceController> {
  static const String pageId = '/NewInvoiceScreen';

  const NewInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Invoice'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          Obx(() => controller.isLoading.value
              ? Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
              : Row(
            children: [
              TextButton(
                onPressed: () => controller.saveInvoice(isDraft: true),
                child: Text(
                  'Save Draft',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => controller.saveInvoice(isDraft: false),
                child: Text(
                  'Create Invoice',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice Details Section
              _buildInvoiceDetailsCard(),

              SizedBox(height: 16),

              // Customer Section
              _buildCustomerSection(),

              SizedBox(height: 16),

              // Items Section
              _buildItemsSection(),

              SizedBox(height: 16),

              // Calculations Section
              _buildCalculationsSection(),

              SizedBox(height: 16),

              // Notes Section
              _buildNotesSection(),

              SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.invoiceNumberController,
                    decoration: InputDecoration(
                      labelText: 'Invoice Number',
                      prefixIcon: Icon(Icons.receipt),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: controller.dueDateController,
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    readOnly: true,
                    onTap: controller.selectDueDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select due date';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: controller.toggleCustomerForm,
                  icon: Icon(
                    controller.showCustomerForm.value
                        ? Icons.person
                        : Icons.person_add,
                    color: Colors.blue.shade700,
                  ),
                  tooltip: controller.showCustomerForm.value
                      ? 'Select from existing customers'
                      : 'Add new customer manually',
                ),
              ],
            ),
            SizedBox(height: 16),
            Obx(() {
              if (controller.customers.isEmpty && !controller.showCustomerForm.value) {
                return Column(
                  children: [
                    Text(
                      'No customers found. Please add a customer.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.toggleCustomerForm,
                      child: Text('Add New Customer'),
                    ),
                  ],
                );
              } else if (!controller.showCustomerForm.value) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    value: controller.selectedCustomer.value,
                    isExpanded: true,
                    hint: Text('Select Customer'),
                    underline: SizedBox(),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Select Customer'),
                      ),
                      ...controller.customers.map((customer) {
                        return DropdownMenuItem(
                          value: customer,
                          child: Text(customer['name'] ?? 'Unknown Customer'),
                        );
                      }).toList(),
                    ],
                    onChanged: controller.selectCustomer,
                  ),
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: 12),
                    Text(
                      'Add New Customer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: controller.customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name *',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter customer name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.customerMobileController,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: controller.customerEmailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: controller.customerAddressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Invoice Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                Spacer(),
                Obx(() => Text(
                  'Total: ₹${controller.totalAmount.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                )),
              ],
            ),
            SizedBox(height: 16),

            // Items list header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Item Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Qty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),  textAlign: TextAlign.center,

                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Expanded(
                      flex: 2,
                      child: Text(
                        'Rate (₹)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),textAlign: TextAlign.center,

                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),textAlign: TextAlign.center,

                    ),
                  ),
                  SizedBox(width: 40), // Space for delete button
                ],
              ),
            ),
            SizedBox(height: 12),

            Obx(() => Column(
              children: [
                // Display message if no items available
                if (controller.itemList.isEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange.shade700),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No items available. Please add items in your inventory first.',
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Invoice items list
                ...controller.invoiceItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  InvoiceItem item = entry.value;

                  // Create a TextEditingController for the rate field
                  final rateController = TextEditingController(text: item.rate > 0 ? item.rate.toStringAsFixed(2) : '');

                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (controller.itemList.isNotEmpty)
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: DropdownButton<Item>(
                                        value: controller.itemList.firstWhereOrNull(
                                                (element) => element.itemId == item.itemId
                                        ),
                                        isExpanded: true,
                                        hint: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          child: Text('Select Item', style: TextStyle(fontSize: 14)),
                                        ),
                                        underline: SizedBox(),
                                        icon: Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(Icons.arrow_drop_down, size: 20),
                                        ),
                                        items: [
                                          DropdownMenuItem(
                                            value: null,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: Text('Select Item', style: TextStyle(fontSize: 14)),
                                            ),
                                          ),
                                          ...controller.itemList.map((item) {
                                            return DropdownMenuItem(
                                              value: item,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  '${item.itemName} - ₹${item.price.toStringAsFixed(2)}',
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                        onChanged: (selectedItem) {
                                          if (selectedItem != null) {
                                            // Update the rate field with the selected item's price
                                            rateController.text = selectedItem.price.toStringAsFixed(2);
                                            controller.selectRemoteItemForIndex(index, selectedItem);
                                          }
                                        },
                                      ),
                                    ),
                                  if (controller.itemList.isEmpty)
                                    TextFormField(
                                      initialValue: item.description,
                                      decoration: InputDecoration(
                                        labelText: 'Item Description',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      ),
                                      onChanged: (value) {
                                        controller.updateItem(index, description: value);
                                      },
                                    ),
                                ],
                              ),
                            ),

                            SizedBox(width: 12),

                            // Quantity
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Qty',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    height: 40,
                                    child: TextFormField(
                                      initialValue: item.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        int? qty = int.tryParse(value);
                                        if (qty != null && qty > 0) {
                                          controller.updateItem(index, quantity: qty);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 12),

                            // Rate
                            Visibility(
                              visible: false,
                              child: Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rate (₹)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      height: 40,
                                      child: TextFormField(
                                        controller: rateController,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        onChanged: (value) {
                                          double? rate = double.tryParse(value);
                                          if (rate != null && rate >= 0) {
                                            controller.updateItem(index, rate: rate);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: 12),

                            // Amount
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    height: 40,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '₹${item.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete button
                            if (controller.invoiceItems.length > 1)
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: IconButton(
                                  onPressed: () => controller.removeItem(index),
                                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),

                // Add item button
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.addNewItem,
                    icon: Icon(Icons.add_circle_outline, size: 20),
                    label: Text('Add Another Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Summary
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Items:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      Text(
                        '${controller.invoiceItems.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }



  Widget _buildCalculationsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tax Rate (%)',
                      prefixIcon: Icon(Icons.percent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      double? rate = double.tryParse(value);
                      if (rate != null && rate >= 0) {
                        controller.updateTaxRate(rate);
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Discount',
                      prefixIcon: Icon(Icons.discount),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: Obx(() => DropdownButton<String>(
                        value: controller.discountType.value,
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(value: 'amount', child: Text('₹')),
                          DropdownMenuItem(value: 'percentage', child: Text('%')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateDiscount(
                              controller.discountAmount.value,
                              value,
                            );
                          }
                        },
                      )),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      double? discount = double.tryParse(value);
                      if (discount != null && discount >= 0) {
                        controller.updateDiscount(
                          discount,
                          controller.discountType.value,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            Obx(() => Column(
              children: [
                _buildTotalRow('Subtotal', controller.subtotal.value),
                if (controller.discountAmount.value > 0)
                  _buildTotalRow(
                    'Discount',
                    controller.discountType.value == 'percentage'
                        ? controller.subtotal.value * (controller.discountAmount.value / 100)
                        : controller.discountAmount.value,
                    isDiscount: true,
                  ),
                if (controller.taxRate.value > 0)
                  _buildTotalRow('Tax (${controller.taxRate.value}%)', controller.taxAmount.value),
                Divider(),
                _buildTotalRow('Total Amount', controller.totalAmount.value, isTotal: true),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue.shade700 : Colors.black87,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}₹ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : (isTotal ? Colors.blue.shade700 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.notesController,
              decoration: InputDecoration(
                hintText: 'Add any additional notes or terms...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: controller.isLoading.value ? null : () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.saveInvoice(isDraft: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text('Save Draft', style: TextStyle(color: Colors.white)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.saveInvoice(isDraft: false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text('Create Invoice', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ));
  }
}