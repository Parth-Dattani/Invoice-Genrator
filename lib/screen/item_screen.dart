import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_prac_getx/constant/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/item_controller.dart';
import '../controller/item_controller_old.dart';
import '../model/model.dart';
import '../utils/pdf_helper.dart';
import '../utils/shared_preferences_helper.dart';
import '../widgets/widgets.dart';

/// working 10-09
// class ItemScreen extends GetView<ItemController> {
//   static const pageId = "/ItemScreen";
//
//   const ItemScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.tealColor,
//         leading: Icon(Icons.menu, color: AppColors.whiteColor),
//         title: Text(
//           "Items Management",
//           style: TextStyle(color: AppColors.whiteColor),
//         ),
//         actions: [
//           // Toggle inactive items visibility
//           Obx(() => IconButton(
//             icon: Icon(
//               controller.showInactiveItems.value
//                   ? Icons.visibility_off
//                   : Icons.visibility,
//               color: AppColors.whiteColor,
//             ),
//             onPressed: controller.toggleShowInactive,
//             tooltip: controller.showInactiveItems.value
//                 ? 'Hide Inactive Items'
//                 : 'Show Inactive Items',
//           )),
//           // Obx(() {
//           //   return Stack(
//           //     children: [
//           //       IconButton(
//           //         icon: Icon(Icons.shopping_cart, color: AppColors.whiteColor),
//           //         onPressed: controller.cart.isEmpty
//           //             ? null
//           //             : () => _showCartDialog(context),
//           //       ),
//           //       if (controller.cart.isNotEmpty)
//           //         Positioned(
//           //           right: 8,
//           //           top: 8,
//           //           child: CircleAvatar(
//           //             radius: 8,
//           //             backgroundColor: Colors.red,
//           //             child: Text(
//           //               "${controller.cart.length}",
//           //               style: const TextStyle(fontSize: 10, color: Colors.white),
//           //             ),
//           //           ),
//           //         ),
//           //     ],
//           //   );
//           // }),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final items = controller.filteredItemList;
//
//         if (items.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
//                 SizedBox(height: 16),
//                 Text(
//                   controller.showInactiveItems.value
//                       ? "No items found"
//                       : "No active items found",
//                   style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Add your first item using the + button",
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           itemCount: items.length,
//           padding: EdgeInsets.all(8),
//           itemBuilder: (context, index) {
//             final item = items[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: item.isActive
//                         ? Colors.transparent
//                         : Colors.red.shade300,
//                     width: item.isActive ? 0 : 2,
//                   ),
//                 ),
//                 child: ExpansionTile(
//                   tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                   childrenPadding: EdgeInsets.all(16),
//                   leading: Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: item.isActive
//                           ? AppColors.tealColor.withOpacity(0.1)
//                           : Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.inventory_2_outlined,
//                       color: item.isActive
//                           ? AppColors.tealColor
//                           : Colors.red.shade400,
//                     ),
//                   ),
//                   title: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           item.itemName,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: item.isActive ? Colors.black : Colors.grey.shade600,
//                             decoration: item.isActive
//                                 ? TextDecoration.none
//                                 : TextDecoration.lineThrough,
//                           ),
//                         ),
//                       ),
//                       if (!item.isActive)
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade100,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             "INACTIVE",
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red.shade700,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   subtitle: Row(
//                     children: [
//                       Text(
//                         "₹${item.price.toStringAsFixed(2)}",
//                         style: TextStyle(
//                           color: AppColors.tealColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(" / ${item.unitOfMeasurement}"),
//                       //Spacer(),
//                       // Container(
//                       //   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                       //   decoration: BoxDecoration(
//                       //     color: _getStockColor(item.currentStock).withOpacity(0.1),
//                       //     borderRadius: BorderRadius.circular(8),
//                       //   ),
//                       //   child: Text(
//                       //     item.currentStock == -1
//                       //         ? "Unlimited"
//                       //         : "Stock: ${item.currentStock}",
//                       //     style: TextStyle(
//                       //       fontSize: 12,
//                       //       color: _getStockColor(item.currentStock),
//                       //       fontWeight: FontWeight.w500,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // if (item.isActive) addToCartBtn(item),
//                       // SizedBox(width: 4),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.blue),
//                         onPressed: () => _confirmDelete(context, item),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.blue),
//                         onPressed: () => _showEditItemDialog(context, item),
//                       ),
//                     ],
//                   ),
//                   children: [
//                     _buildItemDetails(item),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColors.tealColor,
//         onPressed: () => _showAddItemDialog(context),
//         icon: Icon(Icons.add, color: AppColors.whiteColor),
//         label: Text(
//           "Add Item",
//           style: TextStyle(color: AppColors.whiteColor),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItemDetails(Item item) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow("Unit", item.unitOfMeasurement),
//               ),
//               Expanded(
//                 child: _buildDetailRow("Stock", item.currentStock == -1
//                     ? "Unlimited"
//                     : "${item.currentStock}"),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow("Price", "₹${item.price.toStringAsFixed(2)}"),
//               ),
//               Expanded(
//                 child: _buildDetailRow("Status", item.isActive ? "Active" : "Inactive"),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow("ID", "₹${item.userId.toString()}"),
//               ),
//
//             ],
//           ),
//           if (item.detailRequirement.isNotEmpty) ...[
//             SizedBox(height: 8),
//             _buildDetailRow("Details", item.detailRequirement),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showAddItemDialog(BuildContext context) {
//     final nameCtrl = TextEditingController();
//     final priceCtrl = TextEditingController();
//     final stockCtrl = TextEditingController();
//     final detailCtrl = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//
//     String selectedUnit = controller.unitOptions.first;
//     bool isActive = true;
//     bool isUnlimitedStock = false;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         bool isAdding = false;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 8,
//               insetPadding: EdgeInsets.all(16),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.85,
//                   maxWidth: 400,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Add New Item",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.tealColor,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close, color: AppColors.tealColor),
//                               onPressed: isAdding ? null : () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//
//                         // Item Name
//                         TextFormField(
//                           controller: nameCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Item Name *",
//                             hintText: "Enter item name",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.label_outline, color: AppColors.tealColor),
//                           ),
//                           enabled: !isAdding,
//                           validator: (value) => value?.trim().isEmpty ?? true ? "Item name is required" : null,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Price and Unit Row
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: TextFormField(
//                                 controller: priceCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Price *",
//                                   hintText: "0.00",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.currency_rupee_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                 enabled: !isAdding,
//                                 validator: (value) {
//                                   final price = double.tryParse(value ?? '');
//                                   if (price == null || price <= 0) return "Valid price required";
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 value: selectedUnit,
//                                 decoration: InputDecoration(
//                                   labelText: "Unit",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                 ),
//                                 items: controller.unitOptions.map((unit) {
//                                   return DropdownMenuItem(value: unit, child: Text(unit));
//                                 }).toList(),
//                                 onChanged: isAdding ? null : (value) {
//                                   setState(() => selectedUnit = value!);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Stock Section
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: isUnlimitedStock,
//                                   onChanged: isAdding ? null : (value) {
//                                     setState(() {
//                                       isUnlimitedStock = value!;
//                                       if (isUnlimitedStock) stockCtrl.clear();
//                                     });
//                                   },
//                                 ),
//                                 Text("Unlimited Stock"),
//                               ],
//                             ),
//                             if (!isUnlimitedStock)
//                               TextFormField(
//                                 controller: stockCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Stock *",
//                                   hintText: "Enter stock quantity",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 enabled: !isAdding,
//                                 validator: (value) {
//                                   if (isUnlimitedStock) return null;
//                                   final stock = int.tryParse(value ?? '');
//                                   if (stock == null || stock < 0) return "Valid stock required";
//                                   return null;
//                                 },
//                               ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Detail Requirements
//                         TextFormField(
//                           controller: detailCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Detail Requirements",
//                             hintText: "Enter additional details (optional)",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.notes_outlined, color: AppColors.tealColor),
//                           ),
//                           maxLines: 3,
//                           enabled: !isAdding,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Status Toggle
//                         Row(
//                           children: [
//                             Icon(Icons.toggle_on_outlined, color: AppColors.tealColor),
//                             SizedBox(width: 8),
//                             Text("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
//                             Spacer(),
//                             Switch(
//                               value: isActive,
//                               onChanged: isAdding ? null : (value) {
//                                 setState(() => isActive = value);
//                               },
//                               activeColor: AppColors.tealColor,
//                             ),
//                             Text(isActive ? "Active" : "Inactive"),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//
//                         // Action Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: isAdding ? null : () => Navigator.pop(context),
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.tealColor,
//                                 foregroundColor: AppColors.whiteColor,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                 elevation: 3,
//                               ),
//                               onPressed: isAdding ? null : () async {
//                                 if (formKey.currentState!.validate()) {
//                                   setState(() => isAdding = true);
//
//                                   final name = nameCtrl.text.trim();
//                                   final price = double.parse(priceCtrl.text);
//                                   final stock = isUnlimitedStock ? -1 : int.parse(stockCtrl.text);
//                                   final detail = detailCtrl.text.trim();
//
//                                   try {
//                                     await controller.addNewItem(
//                                       name: name,
//                                       price: price,
//                                       unitOfMeasurement: selectedUnit,
//                                       currentStock: stock,
//                                       detailRequirement: detail,
//                                       isActive: isActive,
//                                     );
//                                     Navigator.pop(context);
//                                   } catch (e) {
//                                     setState(() => isAdding = false);
//                                   }
//                                 }
//                               },
//                               child: isAdding
//                                   ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
//                                 ),
//                               )
//                                   : Text(
//                                 "Add Item",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showEditItemDialog(BuildContext context, Item item) {
//     final nameCtrl = TextEditingController(text: item.itemName);
//     final priceCtrl = TextEditingController(text: item.price.toStringAsFixed(2));
//     final stockCtrl = TextEditingController(
//         text: item.currentStock == -1 ? '' : item.currentStock.toString()
//     );
//     final detailCtrl = TextEditingController(text: item.detailRequirement);
//     final formKey = GlobalKey<FormState>();
//
//     String selectedUnit = item.unitOfMeasurement;
//     bool isActive = item.isActive;
//     bool isUnlimitedStock = item.currentStock == -1;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         bool isSaving = false;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 8,
//               insetPadding: EdgeInsets.all(16),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.85,
//                   maxWidth: 400,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Edit Item",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.tealColor,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close, color: AppColors.tealColor),
//                               onPressed: isSaving ? null : () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//
//                         // Item Name
//                         TextFormField(
//                           controller: nameCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Item Name *",
//                             hintText: "Enter item name",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.label_outline, color: AppColors.tealColor),
//                           ),
//                           enabled: !isSaving,
//                           validator: (value) => value?.trim().isEmpty ?? true ? "Item name is required" : null,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Price and Unit Row
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: TextFormField(
//                                 controller: priceCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Price *",
//                                   hintText: "0.00",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.currency_rupee_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                 enabled: !isSaving,
//                                 validator: (value) {
//                                   final price = double.tryParse(value ?? '');
//                                   if (price == null || price <= 0) return "Valid price required";
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 value: selectedUnit,
//                                 decoration: InputDecoration(
//                                   labelText: "Unit",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                 ),
//                                 items: controller.unitOptions.map((unit) {
//                                   return DropdownMenuItem(value: unit, child: Text(unit));
//                                 }).toList(),
//                                 onChanged: isSaving ? null : (value) {
//                                   setState(() => selectedUnit = value!);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Stock Section
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: isUnlimitedStock,
//                                   onChanged: isSaving ? null : (value) {
//                                     setState(() {
//                                       isUnlimitedStock = value!;
//                                       if (isUnlimitedStock) stockCtrl.clear();
//                                     });
//                                   },
//                                 ),
//                                 Text("Unlimited Stock"),
//                               ],
//                             ),
//                             if (!isUnlimitedStock)
//                               TextFormField(
//                                 controller: stockCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Stock *",
//                                   hintText: "Enter stock quantity",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 enabled: !isSaving,
//                                 validator: (value) {
//                                   if (isUnlimitedStock) return null;
//                                   final stock = int.tryParse(value ?? '');
//                                   if (stock == null || stock < 0) return "Valid stock required";
//                                   return null;
//                                 },
//                               ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Detail Requirements
//                         TextFormField(
//                           controller: detailCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Detail Requirements",
//                             hintText: "Enter additional details (optional)",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.notes_outlined, color: AppColors.tealColor),
//                           ),
//                           maxLines: 3,
//                           enabled: !isSaving,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Status Toggle
//                         Row(
//                           children: [
//                             Icon(Icons.toggle_on_outlined, color: AppColors.tealColor),
//                             SizedBox(width: 8),
//                             Text("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
//                             Spacer(),
//                             Switch(
//                               value: isActive,
//                               onChanged: isSaving ? null : (value) {
//                                 setState(() => isActive = value);
//                               },
//                               activeColor: AppColors.tealColor,
//                             ),
//                             Text(isActive ? "Active" : "Inactive"),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//
//                         // Action Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: isSaving ? null : () => Navigator.pop(context),
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.tealColor,
//                                 foregroundColor: AppColors.whiteColor,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                 elevation: 3,
//                               ),
//                               onPressed: isSaving ? null : () async {
//                                 if (formKey.currentState!.validate()) {
//                                   setState(() => isSaving = true);
//
//                                   final name = nameCtrl.text.trim();
//                                   final price = double.parse(priceCtrl.text);
//                                   final stock = isUnlimitedStock ? -1 : int.parse(stockCtrl.text);
//                                   final detail = detailCtrl.text.trim();
//
//                                   try {
//                                     await controller.editItem(
//                                       itemId: item.itemId,
//                                       newName: name,
//                                       newPrice: price,
//                                       unitOfMeasurement: selectedUnit,
//                                       currentStock: stock,
//                                       detailRequirement: detail,
//                                       isActive: isActive,
//                                     );
//                                     Navigator.pop(context);
//                                   } catch (e) {
//                                     setState(() => isSaving = false);
//                                   }
//                                 }
//                               },
//                               child: isSaving
//                                   ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
//                                 ),
//                               )
//                                   : Text(
//                                 "Update Item",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _confirmDelete(BuildContext context, Item item) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text("Delete Item"),
//         content: Text("Are you sure you want to delete '${item.itemName}'?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               // Close dialog immediately
//               Navigator.pop(context);
//
//               // Call delete method - it handles loading, success, and error states
//               await controller.deleteItem(itemId: item.itemId);
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

import 'package:shimmer/shimmer.dart';

class ItemScreen extends GetView<ItemController> {
  static const pageId = "/ItemScreen";

  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tealColor,
        leading: Icon(Icons.menu, color: AppColors.whiteColor),
        title: Text(
          "Items Management",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // Toggle inactive items visibility
          Obx(() => IconButton(
            icon: Icon(
              controller.showInactiveItems.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.whiteColor,
            ),
            onPressed: controller.toggleShowInactive,
            tooltip: controller.showInactiveItems.value
                ? 'Hide Inactive Items'
                : 'Show Inactive Items',
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoader();
        }

        final items = controller.filteredItemList;

        if (items.isEmpty) {
          return _buildEmptyState();
        }

        return _buildItemList(items);
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.tealColor,
        onPressed: () => _showAddItemDialog(context),
        icon: Icon(Icons.add, color: AppColors.whiteColor),
        label: Text(
          "Add Item",
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey.shade400
          ),
          SizedBox(height: 20),
          Text(
            controller.showInactiveItems.value
                ? "No items found"
                : "No active items found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Add your first item using the + button",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.isActive
                    ? Colors.transparent
                    : Colors.red.shade300,
                width: item.isActive ? 0 : 2,
              ),
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: item.isActive
                      ? AppColors.tealColor.withOpacity(0.1)
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: item.isActive
                      ? AppColors.tealColor
                      : Colors.red.shade400,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: item.isActive ? Colors.black : Colors.grey.shade600,
                        decoration: item.isActive
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                  if (!item.isActive)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "INACTIVE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "₹${item.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: AppColors.tealColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(" / ${item.unitOfMeasurement}"),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show different buttons based on item status
                  if (item.isActive) ...[
                    // Active item - show delete and edit
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, item),
                      tooltip: 'Delete Item',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditItemDialog(context, item),
                      tooltip: 'Edit Item',
                    ),
                  ] else ...[
                    // Inactive item - show restore and edit
                    IconButton(
                      icon: const Icon(Icons.restore, color: Colors.green),
                      onPressed: () => _confirmRestore(context, item),
                      tooltip: 'Restore Item',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditItemDialog(context, item),
                      tooltip: 'Edit Item',
                    ),
                  ],
                ],
              ),
              children: [
                _buildItemDetails(item),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemDetails(Item item) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailRow("Unit", item.unitOfMeasurement),
              ),
              Expanded(
                child: _buildDetailRow("Stock", item.currentStock == -1
                    ? "Unlimited"
                    : "${item.currentStock}"),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailRow("Price", "₹${item.price.toStringAsFixed(2)}"),
              ),
              Expanded(
                child: _buildDetailRow("Status", item.isActive ? "Active" : "Inactive"),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailRow("ID", item.itemId.toString()),
              ),
            ],
          ),
          if (item.detailRequirement.isNotEmpty) ...[
            SizedBox(height: 12),
            _buildDetailRow("Details", item.detailRequirement),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final detailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String selectedUnit = controller.unitOptions.first;
    bool isActive = true;
    bool isUnlimitedStock = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        bool isAdding = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              insetPadding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(24),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: 500,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add New Item",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tealColor,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: AppColors.tealColor),
                              onPressed: isAdding ? null : () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Item Name
                        TextFormField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            labelText: "Item Name *",
                            hintText: "Enter item name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.label_outline, color: AppColors.tealColor),
                          ),
                          enabled: !isAdding,
                          validator: (value) => value?.trim().isEmpty ?? true ? "Item name is required" : null,
                        ),
                        SizedBox(height: 16),

                        // Price and Unit Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: priceCtrl,
                                decoration: InputDecoration(
                                  labelText: "Price *",
                                  hintText: "0.00",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(Icons.currency_rupee_outlined, color: AppColors.tealColor),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                enabled: !isAdding,
                                validator: (value) {
                                  final price = double.tryParse(value ?? '');
                                  if (price == null || price <= 0) return "Valid price required";
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedUnit,
                                decoration: InputDecoration(
                                  labelText: "Unit",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                items: controller.unitOptions.map((unit) {
                                  return DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  );
                                }).toList(),
                                onChanged: isAdding ? null : (value) {
                                  setState(() => selectedUnit = value!);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Stock Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isUnlimitedStock,
                                  onChanged: isAdding ? null : (value) {
                                    setState(() {
                                      isUnlimitedStock = value!;
                                      if (isUnlimitedStock) stockCtrl.clear();
                                    });
                                  },
                                ),
                                Text("Unlimited Stock", style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                            if (!isUnlimitedStock)
                              TextFormField(
                                controller: stockCtrl,
                                decoration: InputDecoration(
                                  labelText: "Current Stock *",
                                  hintText: "Enter stock quantity",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.tealColor),
                                ),
                                keyboardType: TextInputType.number,
                                enabled: !isAdding,
                                validator: (value) {
                                  if (isUnlimitedStock) return null;
                                  final stock = int.tryParse(value ?? '');
                                  if (stock == null || stock < 0) return "Valid stock required";
                                  return null;
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Detail Requirements
                        TextFormField(
                          controller: detailCtrl,
                          decoration: InputDecoration(
                            labelText: "Detail Requirements",
                            hintText: "Enter additional details (optional)",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.notes_outlined, color: AppColors.tealColor),
                          ),
                          maxLines: 3,
                          enabled: !isAdding,
                        ),
                        SizedBox(height: 16),

                        // Status Toggle
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.toggle_on_outlined, color: AppColors.tealColor),
                              SizedBox(width: 8),
                              Text("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
                              Spacer(),
                              Switch(
                                value: isActive,
                                onChanged: isAdding ? null : (value) {
                                  setState(() => isActive = value);
                                },
                                activeColor: AppColors.tealColor,
                              ),
                              Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isAdding ? null : () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tealColor,
                                foregroundColor: AppColors.whiteColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                elevation: 3,
                              ),
                              onPressed: isAdding ? null : () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() => isAdding = true);

                                  final name = nameCtrl.text.trim();
                                  final price = double.parse(priceCtrl.text);
                                  final stock = isUnlimitedStock ? -1 : int.parse(stockCtrl.text);
                                  final detail = detailCtrl.text.trim();

                                  try {
                                    await controller.addNewItem(
                                      name: name,
                                      price: price,
                                      unitOfMeasurement: selectedUnit,
                                      currentStock: stock,
                                      detailRequirement: detail,
                                      isActive: isActive,
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    setState(() => isAdding = false);
                                  }
                                }
                              },
                              child: isAdding
                                  ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                                ),
                              )
                                  : Text(
                                "Add Item",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, Item item) {
    final nameCtrl = TextEditingController(text: item.itemName);
    final priceCtrl = TextEditingController(text: item.price.toStringAsFixed(2));
    final stockCtrl = TextEditingController(
        text: item.currentStock == -1 ? '' : item.currentStock.toString()
    );
    final detailCtrl = TextEditingController(text: item.detailRequirement);
    final formKey = GlobalKey<FormState>();

    String selectedUnit = item.unitOfMeasurement;
    bool isActive = item.isActive;
    bool isUnlimitedStock = item.currentStock == -1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        bool isSaving = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              insetPadding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(24),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: 500,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Edit Item",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tealColor,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: AppColors.tealColor),
                              onPressed: isSaving ? null : () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Item Name
                        TextFormField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            labelText: "Item Name *",
                            hintText: "Enter item name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.label_outline, color: AppColors.tealColor),
                          ),
                          enabled: !isSaving,
                          validator: (value) => value?.trim().isEmpty ?? true ? "Item name is required" : null,
                        ),
                        SizedBox(height: 16),

                        // Price and Unit Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: priceCtrl,
                                decoration: InputDecoration(
                                  labelText: "Price *",
                                  hintText: "0.00",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(Icons.currency_rupee_outlined, color: AppColors.tealColor),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                enabled: !isSaving,
                                validator: (value) {
                                  final price = double.tryParse(value ?? '');
                                  if (price == null || price <= 0) return "Valid price required";
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedUnit,
                                decoration: InputDecoration(
                                  labelText: "Unit",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                items: controller.unitOptions.map((unit) {
                                  return DropdownMenuItem(value: unit, child: Text(unit));
                                }).toList(),
                                onChanged: isSaving ? null : (value) {
                                  setState(() => selectedUnit = value!);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Stock Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isUnlimitedStock,
                                  onChanged: isSaving ? null : (value) {
                                    setState(() {
                                      isUnlimitedStock = value!;
                                      if (isUnlimitedStock) stockCtrl.clear();
                                    });
                                  },
                                ),
                                Text("Unlimited Stock", style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                            if (!isUnlimitedStock)
                              TextFormField(
                                controller: stockCtrl,
                                decoration: InputDecoration(
                                  labelText: "Current Stock *",
                                  hintText: "Enter stock quantity",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.tealColor),
                                ),
                                keyboardType: TextInputType.number,
                                enabled: !isSaving,
                                validator: (value) {
                                  if (isUnlimitedStock) return null;
                                  final stock = int.tryParse(value ?? '');
                                  if (stock == null || stock < 0) return "Valid stock required";
                                  return null;
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Detail Requirements
                        TextFormField(
                          controller: detailCtrl,
                          decoration: InputDecoration(
                            labelText: "Detail Requirements",
                            hintText: "Enter additional details (optional)",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.notes_outlined, color: AppColors.tealColor),
                          ),
                          maxLines: 3,
                          //enabled: not isSaving,
                        ),
                        SizedBox(height: 16),

                        // Status Toggle
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.toggle_on_outlined, color: AppColors.tealColor),
                              SizedBox(width: 8),
                              Text("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
                              Spacer(),
                              Switch(
                                value: isActive,
                                onChanged: isSaving ? null : (value) {
                                  setState(() => isActive = value);
                                },
                                activeColor: AppColors.tealColor,
                              ),
                              Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isSaving ? null : () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tealColor,
                                foregroundColor: AppColors.whiteColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                elevation: 3,
                              ),
                              onPressed: isSaving ? null : () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() => isSaving = true);

                                  final name = nameCtrl.text.trim();
                                  final price = double.parse(priceCtrl.text);
                                  final stock = isUnlimitedStock ? -1 : int.parse(stockCtrl.text);
                                  final detail = detailCtrl.text.trim();

                                  try {
                                    await controller.editItem(
                                      itemId: item.itemId,
                                      newName: name,
                                      newPrice: price,
                                      unitOfMeasurement: selectedUnit,
                                      currentStock: stock,
                                      detailRequirement: detail,
                                      isActive: isActive,
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    setState(() => isSaving = false);
                                  }
                                }
                              },
                              child: isSaving
                                  ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                                ),
                              )
                                  : Text(
                                "Update Item",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Item", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete '${item.itemName}'?\n\nThis will mark the item as inactive. You can restore it later if needed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);


              // Call delete method
              await controller.deleteItem(itemId: item.itemId);

              // Close loading overlay
              Get.back();
            },
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmRestore(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Restore Item", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to restore '${item.itemName}'?\n\nThis will mark the item as active again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              // Show loading overlay
              Get.dialog(
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.tealColor),
                  ),
                ),
                barrierDismissible: false,
              );

              // Call restore method - you need to implement this in your controller
              await controller.deleteItem(itemId: item.itemId);

              // Close loading overlay
              Get.back();
            },
            child: Text("Restore", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
// class ItemScreen extends GetView<ItemController> {
//   static const pageId = "/ItemScreen";
//
//   const ItemScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.tealColor,
//         leading: Icon(Icons.menu, color: AppColors.whiteColor),
//         title: Text(
//           "Items Management",
//           style: TextStyle(color: AppColors.whiteColor),
//         ),
//         actions: [
//           // Toggle inactive items visibility
//           Obx(() => IconButton(
//             icon: Icon(
//               controller.showInactiveItems.value
//                   ? Icons.visibility_off
//                   : Icons.visibility,
//               color: AppColors.whiteColor,
//             ),
//             onPressed: controller.toggleShowInactive,
//             tooltip: controller.showInactiveItems.value
//                 ? 'Hide Inactive Items'
//                 : 'Show Inactive Items',
//           )),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final items = controller.filteredItemList;
//
//         if (items.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
//                 SizedBox(height: 16),
//                 Text(
//                   controller.showInactiveItems.value
//                       ? "No items found"
//                       : "No active items found",
//                   style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Add your first item using the + button",
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           itemCount: items.length,
//           padding: EdgeInsets.all(8),
//           itemBuilder: (context, index) {
//             final item = items[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               elevation: 2,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: item.isActive
//                         ? Colors.transparent
//                         : Colors.red.shade300,
//                     width: item.isActive ? 0 : 2,
//                   ),
//                 ),
//                 child: ExpansionTile(
//                   tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                   childrenPadding: EdgeInsets.all(16),
//                   leading: Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: item.isActive
//                           ? AppColors.tealColor.withOpacity(0.1)
//                           : Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.inventory_2_outlined,
//                       color: item.isActive
//                           ? AppColors.tealColor
//                           : Colors.red.shade400,
//                     ),
//                   ),
//                   title: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           item.itemName,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: item.isActive ? Colors.black : Colors.grey.shade600,
//                             decoration: item.isActive
//                                 ? TextDecoration.none
//                                 : TextDecoration.lineThrough,
//                           ),
//                         ),
//                       ),
//                       if (!item.isActive)
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade100,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             "INACTIVE",
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red.shade700,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   subtitle: Row(
//                     children: [
//                       Text(
//                         "₹${item.price.toStringAsFixed(2)}",
//                         style: TextStyle(
//                           color: AppColors.tealColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(" / ${item.unitOfMeasurement}"),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Show different buttons based on item status
//                       if (item.isActive) ...[
//                         // Active item - show delete and edit
//                         IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _confirmDelete(context, item),
//                           tooltip: 'Delete Item',
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => _showEditItemDialog(context, item),
//                           tooltip: 'Edit Item',
//                         ),
//                       ] else ...[
//                         // Inactive item - show restore and edit
//                         IconButton(
//                           icon: const Icon(Icons.restore, color: Colors.green),
//                           onPressed: () => _confirmRestore(context, item),
//                           tooltip: 'Restore Item',
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => _showEditItemDialog(context, item),
//                           tooltip: 'Edit Item',
//                         ),
//                       ],
//                     ],
//                   ),
//                   children: [
//                     _buildItemDetails(item),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColors.tealColor,
//         onPressed: () => _showAddItemDialog(context),
//         icon: Icon(Icons.add, color: AppColors.whiteColor),
//         label: Text(
//           "Add Item",
//           style: TextStyle(color: AppColors.whiteColor),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItemDetails(Item item) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow("Unit", item.unitOfMeasurement),
//               ),
//               Expanded(
//                 child: _buildDetailRow("Stock", item.currentStock == -1
//                     ? "Unlimited"
//                     : "${item.currentStock}"),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow("Price", "₹${item.price.toStringAsFixed(2)}"),
//               ),
//               Expanded(
//                 child: _buildDetailRow("Status", item.isActive ? "Active" : "Inactive"),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDetailRow("ID", item.itemId.toString()),
//               ),
//             ],
//           ),
//           if (item.detailRequirement.isNotEmpty) ...[
//             SizedBox(height: 8),
//             _buildDetailRow("Details", item.detailRequirement),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showAddItemDialog(BuildContext context) {
//     final nameCtrl = TextEditingController();
//     final priceCtrl = TextEditingController();
//     final stockCtrl = TextEditingController();
//     final detailCtrl = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//
//     String selectedUnit = controller.unitOptions.first;
//     bool isActive = true;
//     bool isUnlimitedStock = false;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         bool isAdding = false;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 8,
//               insetPadding: EdgeInsets.all(16),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.85,
//                   maxWidth: 400,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Add New Item",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.tealColor,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close, color: AppColors.tealColor),
//                               onPressed: isAdding ? null : () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//
//                         // Item Name
//                         TextFormField(
//                           controller: nameCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Item Name *",
//                             hintText: "Enter item name",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.label_outline, color: AppColors.tealColor),
//                           ),
//                           enabled: !isAdding,
//                           validator: (value) => value?.trim().isEmpty ?? true ? "Item name is required" : null,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Price and Unit Row
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: TextFormField(
//                                 controller: priceCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Price *",
//                                   hintText: "0.00",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.currency_rupee_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                 enabled: !isAdding,
//                                 validator: (value) {
//                                   final price = double.tryParse(value ?? '');
//                                   if (price == null || price <= 0) return "Valid price required";
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 value: selectedUnit,
//                                 decoration: InputDecoration(
//                                   labelText: "Unit",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                 ),
//                                 items: controller.unitOptions.map((unit) {
//                                   return DropdownMenuItem(value: unit, child: Text(unit));
//                                 }).toList(),
//                                 onChanged: isAdding ? null : (value) {
//                                   setState(() => selectedUnit = value!);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Stock Section
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: isUnlimitedStock,
//                                   onChanged: isAdding ? null : (value) {
//                                     setState(() {
//                                       isUnlimitedStock = value!;
//                                       if (isUnlimitedStock) stockCtrl.clear();
//                                     });
//                                   },
//                                 ),
//                                 Text("Unlimited Stock"),
//                               ],
//                             ),
//                             if (!isUnlimitedStock)
//                               TextFormField(
//                                 controller: stockCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Stock *",
//                                   hintText: "Enter stock quantity",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 enabled: !isAdding,
//                                 validator: (value) {
//                                   if (isUnlimitedStock) return null;
//                                   final stock = int.tryParse(value ?? '');
//                                   if (stock == null || stock < 0) return "Valid stock required";
//                                   return null;
//                                 },
//                               ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Detail Requirements
//                         TextFormField(
//                           controller: detailCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Detail Requirements",
//                             hintText: "Enter additional details (optional)",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.notes_outlined, color: AppColors.tealColor),
//                           ),
//                           maxLines: 3,
//                           enabled: !isAdding,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Status Toggle
//                         Row(
//                           children: [
//                             Icon(Icons.toggle_on_outlined, color: AppColors.tealColor),
//                             SizedBox(width: 8),
//                             Text("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
//                             Spacer(),
//                             Switch(
//                               value: isActive,
//                               onChanged: isAdding ? null : (value) {
//                                 setState(() => isActive = value);
//                               },
//                               activeColor: AppColors.tealColor,
//                             ),
//                             Text(isActive ? "Active" : "Inactive"),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//
//                         // Action Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: isAdding ? null : () => Navigator.pop(context),
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.tealColor,
//                                 foregroundColor: AppColors.whiteColor,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                 elevation: 3,
//                               ),
//                               onPressed: isAdding ? null : () async {
//                                 if (formKey.currentState!.validate()) {
//                                   setState(() => isAdding = true);
//
//                                   final name = nameCtrl.text.trim();
//                                   final price = double.parse(priceCtrl.text);
//                                   final stock = isUnlimitedStock ? -1 : int.parse(stockCtrl.text);
//                                   final detail = detailCtrl.text.trim();
//
//                                   try {
//                                     await controller.addNewItem(
//                                       name: name,
//                                       price: price,
//                                       unitOfMeasurement: selectedUnit,
//                                       currentStock: stock,
//                                       detailRequirement: detail,
//                                       isActive: isActive,
//                                     );
//                                     Navigator.pop(context);
//                                   } catch (e) {
//                                     setState(() => isAdding = false);
//                                   }
//                                 }
//                               },
//                               child: isAdding
//                                   ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
//                                 ),
//                               )
//                                   : Text(
//                                 "Add Item",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showEditItemDialog(BuildContext context, Item item) {
//     final nameCtrl = TextEditingController(text: item.itemName);
//     final priceCtrl = TextEditingController(text: item.price.toStringAsFixed(2));
//     final stockCtrl = TextEditingController(
//         text: item.currentStock == -1 ? '' : item.currentStock.toString()
//     );
//     final detailCtrl = TextEditingController(text: item.detailRequirement);
//     final formKey = GlobalKey<FormState>();
//
//     String selectedUnit = item.unitOfMeasurement;
//     bool isActive = item.isActive;
//     bool isUnlimitedStock = item.currentStock == -1;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         bool isSaving = false;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 8,
//               insetPadding: EdgeInsets.all(16),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.85,
//                   maxWidth: 400,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Edit Item",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.tealColor,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close, color: AppColors.tealColor),
//                               onPressed: isSaving ? null : () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//
//                         // Item Name
//                         TextFormField(
//                           controller: nameCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Item Name *",
//                             hintText: "Enter item name",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.label_outline, color: AppColors.tealColor),
//                           ),
//                           enabled: !isSaving,
//                           validator: (value) => value?.trim().isEmpty ?? true ? "Item name is required" : null,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Price and Unit Row
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: TextFormField(
//                                 controller: priceCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Price *",
//                                   hintText: "0.00",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.currency_rupee_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                 enabled: !isSaving,
//                                 validator: (value) {
//                                   final price = double.tryParse(value ?? '');
//                                   if (price == null || price <= 0) return "Valid price required";
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 value: selectedUnit,
//                                 decoration: InputDecoration(
//                                   labelText: "Unit",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                 ),
//                                 items: controller.unitOptions.map((unit) {
//                                   return DropdownMenuItem(value: unit, child: Text(unit));
//                                 }).toList(),
//                                 onChanged: isSaving ? null : (value) {
//                                   setState(() => selectedUnit = value!);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Stock Section
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: isUnlimitedStock,
//                                   onChanged: isSaving ? null : (value) {
//                                     setState(() {
//                                       isUnlimitedStock = value!;
//                                       if (isUnlimitedStock) stockCtrl.clear();
//                                     });
//                                   },
//                                 ),
//                                 Text("Unlimited Stock"),
//                               ],
//                             ),
//                             if (!isUnlimitedStock)
//                               TextFormField(
//                                 controller: stockCtrl,
//                                 decoration: InputDecoration(
//                                   labelText: "Current Stock *",
//                                   hintText: "Enter stock quantity",
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade50,
//                                   prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.tealColor),
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 enabled: !isSaving,
//                                 validator: (value) {
//                                   if (isUnlimitedStock) return null;
//                                   final stock = int.tryParse(value ?? '');
//                                   if (stock == null || stock < 0) return "Valid stock required";
//                                   return null;
//                                 },
//                               ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Detail Requirements
//                         TextFormField(
//                           controller: detailCtrl,
//                           decoration: InputDecoration(
//                             labelText: "Detail Requirements",
//                             hintText: "Enter additional details (optional)",
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.grey.shade50,
//                             prefixIcon: Icon(Icons.notes_outlined, color: AppColors.tealColor),
//                           ),
//                           maxLines: 3,
//                           enabled: !isSaving,
//                         ),
//                         SizedBox(height: 12),
//
//                         // Status Toggle
//                         Row(
//                           children: [
//                             Icon(Icons.toggle_on_outlined, color: AppColors.tealColor),
//                             SizedBox(width: 8),
//                             Text("Status:", style: TextStyle(fontWeight: FontWeight.w500)),
//                             Spacer(),
//                             Switch(
//                               value: isActive,
//                               onChanged: isSaving ? null : (value) {
//                                 setState(() => isActive = value);
//                               },
//                               activeColor: AppColors.tealColor,
//                             ),
//                             Text(isActive ? "Active" : "Inactive"),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//
//                         // Action Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: isSaving ? null : () => Navigator.pop(context),
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.tealColor,
//                                 foregroundColor: AppColors.whiteColor,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                 elevation: 3,
//                               ),
//                               onPressed: isSaving ? null : () async {
//                                 if (formKey.currentState!.validate()) {
//                                   setState(() => isSaving = true);
//
//                                   final name = nameCtrl.text.trim();
//                                   final price = double.parse(priceCtrl.text);
//                                   final stock = isUnlimitedStock ? -1 : int.parse(stockCtrl.text);
//                                   final detail = detailCtrl.text.trim();
//
//                                   try {
//                                     await controller.editItem(
//                                       itemId: item.itemId,
//                                       newName: name,
//                                       newPrice: price,
//                                       unitOfMeasurement: selectedUnit,
//                                       currentStock: stock,
//                                       detailRequirement: detail,
//                                       isActive: isActive,
//                                     );
//                                     Navigator.pop(context);
//                                   } catch (e) {
//                                     setState(() => isSaving = false);
//                                   }
//                                 }
//                               },
//                               child: isSaving
//                                   ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
//                                 ),
//                               )
//                                   : Text(
//                                 "Update Item",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _confirmDelete(BuildContext context, Item item) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text("Delete Item"),
//         content: Text("Are you sure you want to delete '${item.itemName}'?\n\nThis will mark the item as inactive. You can restore it later if needed."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               // Close dialog immediately
//               Navigator.pop(context);
//
//               // Call delete method - it handles loading, success, and error states
//               await controller.deleteItem(itemId: item.itemId);
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmRestore(BuildContext context, Item item) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text("Restore Item"),
//         content: Text("Are you sure you want to restore '${item.itemName}'?\n\nThis will mark the item as active again."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             onPressed: () async {
//               // Close dialog immediately
//               Navigator.pop(context);
//
//               // Call restore method
//               await controller.deleteItem(itemId: item.itemId);
//             },
//             child: const Text("Restore", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget addToCartBtn(Item item) {
//     return Obx(() {
//       final inCart = controller.cart.any((e) => e.itemId == item.itemId);
//       final isOutOfStock = item.currentStock <= 0 && item.currentStock != -1;
//
//       return ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isOutOfStock
//               ? Colors.grey.shade400
//               : inCart
//               ? Colors.orange
//               : AppColors.tealColor,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           minimumSize: const Size(80, 32),
//         ),
//         icon: Icon(
//           isOutOfStock
//               ? Icons.inventory_2_outlined
//               : inCart
//               ? Icons.check
//               : Icons.add_shopping_cart,
//           size: 16,
//         ),
//         label: Text(
//           isOutOfStock
//               ? "Stock Out"
//               : inCart
//               ? "Added"
//               : "Add",
//           style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//         ),
//         onPressed: isOutOfStock
//             ? null
//             : () {
//           if (!inCart) {
//             controller.addToCart(item);
//           } else {
//             _showCartDialog(Get.context!);
//           }
//         },
//       );
//     });
//   }
//
//   Color _getStockColor(int stock) {
//     if (stock == -1) return Colors.blue; // Unlimited
//     if (stock <= 0) return Colors.red;    // Out of stock
//     if (stock <= 10) return Colors.orange; // Low stock
//     return Colors.green;                   // Good stock
//   }
//
//   ///working 02-09-2.41
//   void _showCartDialog(BuildContext context) {
//     final nameCtrl = TextEditingController();
//     final phoneCtrl = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//     bool isFormValid = false;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             void validateForm() {
//               final isValid = formKey.currentState?.validate() ?? false;
//               if (isValid != isFormValid) {
//                 setState(() {
//                   isFormValid = isValid;
//                 });
//               }
//             }
//
//             return Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 8,
//               insetPadding: EdgeInsets.all(16),
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.85,
//                   maxWidth: 400,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.tealColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Your Cart",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.tealColor,
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.close, color: AppColors.tealColor),
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Obx(() {
//                         if (controller.cart.isEmpty) {
//                           return Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   "Your cart is empty",
//                                   style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                         return ListView.builder(
//                           shrinkWrap: true,
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           itemCount: controller.cart.length,
//                           itemBuilder: (context, index) {
//                             final item = controller.cart[index];
//                             return Card(
//                               margin: EdgeInsets.symmetric(vertical: 8),
//                               elevation: 2,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                               child: ListTile(
//                                 contentPadding: EdgeInsets.all(12),
//                                 title: Text(
//                                   "${item.itemName}",
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                                 ),
//                                 subtitle: Text(
//                                   "₹${item.price.toStringAsFixed(2)} x ${item.qty} = ₹${(item.price * item.qty).toStringAsFixed(2)}",
//                                   style: TextStyle(color: Colors.grey.shade600),
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(Icons.remove_circle_outline, color: Colors.red.shade400),
//                                       onPressed: () {
//                                         if (item.qty > 1) {
//                                           controller.cart[index] = Invoice(
//                                             invoiceId: item.invoiceId,
//                                             itemId: item.itemId,
//                                             itemName: item.itemName,
//                                             qty: item.qty - 1,
//                                             price: item.price,
//                                             mobile: item.mobile,
//                                             customerName: item.customerName,
//                                           );
//                                           showCustomSnackbar(
//                                             title: "Updated",
//                                             message: "${item.itemName} quantity decreased to ${item.qty - 1}",
//                                             baseColor: AppColors.darkGreenColor,
//                                             icon: Icons.remove_shopping_cart,
//                                           );
//                                         } else {
//                                           controller.removeFromCart(item.itemId);
//                                           showCustomSnackbar(
//                                             title: "Removed",
//                                             message: "${item.itemName} removed from cart",
//                                             baseColor: Colors.red.shade700,
//                                             icon: Icons.delete_outline,
//                                           );
//                                         }
//                                       },
//                                     ),
//                                     Text(
//                                       "${item.qty}",
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.add_circle_outline, color: AppColors.darkGreenColor),
//                                       onPressed: () {
//                                         controller.cart[index] = Invoice(
//                                           invoiceId: item.invoiceId,
//                                           itemId: item.itemId,
//                                           itemName: item.itemName,
//                                           qty: item.qty + 1,
//                                           price: item.price,
//                                           mobile: item.mobile,
//                                           customerName: item.customerName,
//                                         );
//                                         showCustomSnackbar(
//                                           title: "Updated",
//                                           message: "${item.itemName} quantity increased to ${item.qty + 1}",
//                                           baseColor: AppColors.darkGreenColor,
//                                           icon: Icons.add_shopping_cart,
//                                         );
//                                       },
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
//                                       onPressed: () {
//                                         controller.removeFromCart(item.itemId);
//                                         showCustomSnackbar(
//                                           title: "Removed",
//                                           message: "${item.itemName} removed from cart",
//                                           baseColor: Colors.red.shade700,
//                                           icon: Icons.delete_outline,
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       }),
//                     ),
//                     Divider(height: 1, thickness: 1),
//                     Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Form(
//                         key: formKey,
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               controller: nameCtrl,
//                               decoration: InputDecoration(
//                                 labelText: "User Name",
//                                 hintText: "Enter your name",
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 filled: true,
//                                 fillColor: Colors.grey.shade50,
//                                 prefixIcon: Icon(Icons.person_outline, color: AppColors.tealColor),
//                               ),
//                               validator: (value) => value == null || value.trim().isEmpty ? "Enter name" : null,
//                               onChanged: (value) => validateForm(),
//                             ),
//                             SizedBox(height: 12),
//                             TextFormField(
//                               controller: phoneCtrl,
//                               decoration: InputDecoration(
//                                 labelText: "Phone Number",
//                                 hintText: "Enter 10-digit phone number",
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 filled: true,
//                                 fillColor: Colors.grey.shade50,
//                                 prefixIcon: Icon(Icons.phone_outlined, color: AppColors.tealColor),
//                               ),
//                               keyboardType: TextInputType.phone,
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) return "Enter phone";
//                                 if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) return "Enter valid 10-digit number";
//                                 return null;
//                               },
//                               onChanged: (value) => validateForm(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.tealColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//                       ),
//                       child: Obx(() {
//                         final double total = controller.cart.fold(0, (sum, item) => sum + (item.price * item.qty));
//                         return Column(
//                           children: [
//                             Text(
//                               "Total: ₹${total.toStringAsFixed(2)}",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.tealColor,
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.tealColor,
//                                 foregroundColor: AppColors.whiteColor,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                 minimumSize: Size(double.infinity, 50),
//                                 elevation: 3,
//                               ),
//                               onPressed: isFormValid && controller.cart.isNotEmpty
//                                   ? () async {
//                                 final phone = phoneCtrl.text.trim();
//                                 final userName = nameCtrl.text.trim();
//
//                                 try {
//                                   // Save to invoices table with userName
//
//                                   final cartCopy = controller.cart.toList();
//                                   final saved = await controller.saveInvoice(cartCopy, userName, phone);
//                                   if (saved) {
//                                     ///await InvoiceHelper.generateAndShareInvoice(cartCopy, userName, phone);
//                                     // Now you can clear the cart if you want
//                                     controller.clearCart();
//
//                                   }
//                                   Navigator.pop(context);
//                                   showCustomSnackbar(
//                                     title: "Success",
//                                     message: "Invoice saved successfully!",
//                                     baseColor: AppColors.darkGreenColor,
//                                     icon: Icons.check_circle_outline,
//                                   );
//                                 } catch (e) {
//                                   showCustomSnackbar(
//                                     title: "Error",
//                                     message: "Failed to save invoice: $e",
//                                     baseColor: Colors.red.shade700,
//                                     icon: Icons.error_outline,
//                                   );
//                                 }
//                               }
//                                   : null,
//                               child: Text(
//                                 "Generate Invoice",
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   ///with Cdtomer List
//   // void _showCartDialog(BuildContext context) {
//   //   final nameCtrl = TextEditingController();
//   //   final phoneCtrl = TextEditingController();
//   //   final formKey = GlobalKey<FormState>();
//   //   bool isFormValid = false;
//   //
//   //   // Customer selection variables
//   //   Map<String, dynamic>? selectedCustomer;
//   //   bool showCustomerForm = false;
//   //   List<Map<String, dynamic>> customers = [];
//   //   bool isLoadingCustomers = true;
//   //   String debugMessage = "Initializing...";
//   //
//   //   // Enhanced load customers with better debugging
//   //   Future<void> loadCustomers() async {
//   //     try {
//   //       debugMessage = "Getting Firebase Auth user...";
//   //       print("🔄 Loading customers...");
//   //
//   //       final user = FirebaseAuth.instance.currentUser;
//   //       if (user == null) {
//   //         debugMessage = "No authenticated user found";
//   //         print("❌ No authenticated user");
//   //         return;
//   //       }
//   //
//   //       debugMessage = "Getting company ID...";
//   //       print("✅ User authenticated: ${user.uid}");
//   //
//   //       // Try different ways to get company ID
//   //       String companyId = "";
//   //       try {
//   //         companyId = await sharedPreferencesHelper.getPrefData("CompanyId") ?? "";
//   //       } catch (e) {
//   //         print("❌ SharedPreferencesHelper error: $e");
//   //         // Try alternative method if you have it
//   //         // companyId = Get.find<YourAuthController>().companyId ?? "";
//   //       }
//   //
//   //       debugMessage = "Company ID: $companyId";
//   //       print("🏢 Company ID: '$companyId'");
//   //
//   //       if (companyId.isEmpty) {
//   //         debugMessage = "Company ID is empty - please register a company first";
//   //         print("❌ Company ID is empty");
//   //         Get.snackbar(
//   //           'Company Required',
//   //           'Please register a company first',
//   //           snackPosition: SnackPosition.BOTTOM,
//   //           backgroundColor: Colors.orange,
//   //           colorText: Colors.white,
//   //         );
//   //         return;
//   //       }
//   //
//   //       debugMessage = "Fetching customers from Firestore...";
//   //       print("📡 Fetching from path: users/${user.uid}/companies/$companyId/customers");
//   //
//   //       // Build the Firestore query step by step for debugging
//   //       final firestore = FirebaseFirestore.instance;
//   //       final userDoc = firestore.collection("users").doc(user.uid);
//   //       final companyDoc = userDoc.collection("companies").doc(companyId);
//   //       final customersCollection = companyDoc.collection("customers");
//   //
//   //       // Check if company document exists
//   //       final companyDocSnapshot = await companyDoc.get();
//   //       if (!companyDocSnapshot.exists) {
//   //         debugMessage = "Company document does not exist";
//   //         print("❌ Company document does not exist");
//   //         return;
//   //       }
//   //
//   //       print("✅ Company document exists");
//   //
//   //       // Get customers with error handling
//   //       final customersSnapshot = await customersCollection
//   //           .orderBy('createdAt', descending: true)
//   //           .get()
//   //           .catchError((error) {
//   //         print("❌ Firestore query error: $error");
//   //         debugMessage = "Firestore query error: $error";
//   //         throw error;
//   //       });
//   //
//   //       debugMessage = "Processing ${customersSnapshot.docs.length} customers...";
//   //       print("📋 Found ${customersSnapshot.docs.length} customer documents");
//   //
//   //       customers.clear();
//   //       for (var doc in customersSnapshot.docs) {
//   //         try {
//   //           final customerData = doc.data() as Map<String, dynamic>;
//   //           customerData['id'] = doc.id;
//   //           customers.add(customerData);
//   //           print("✅ Added customer: ${customerData['name']} - ${customerData['phone']}");
//   //         } catch (e) {
//   //           print("❌ Error processing customer doc ${doc.id}: $e");
//   //         }
//   //       }
//   //
//   //       debugMessage = "Successfully loaded ${customers.length} customers";
//   //       print("🎉 Successfully loaded ${customers.length} customers");
//   //
//   //     } catch (e) {
//   //       debugMessage = "Error: $e";
//   //       print("💥 Error loading customers: $e");
//   //       print("Stack trace: ${StackTrace.current}");
//   //
//   //       Get.snackbar(
//   //         'Error',
//   //         'Failed to load customers: $e',
//   //         snackPosition: SnackPosition.BOTTOM,
//   //         backgroundColor: Colors.red,
//   //         colorText: Colors.white,
//   //       );
//   //     } finally {
//   //       isLoadingCustomers = false;
//   //     }
//   //   }
//   //
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (_) {
//   //       return StatefulBuilder(
//   //         builder: (context, setState) {
//   //           // Load customers on first build
//   //           if (isLoadingCustomers && customers.isEmpty) {
//   //             loadCustomers().then((_) {
//   //               if (context.mounted) {
//   //                 setState(() {
//   //                   // Force rebuild after loading
//   //                 });
//   //               }
//   //             });
//   //           }
//   //
//   //           void validateForm() {
//   //             bool isValid = false;
//   //             if (selectedCustomer != null) {
//   //               isValid = true; // Customer is selected from dropdown
//   //             } else if (showCustomerForm) {
//   //               isValid = formKey.currentState?.validate() ?? false;
//   //             }
//   //
//   //             if (isValid != isFormValid) {
//   //               setState(() {
//   //                 isFormValid = isValid;
//   //               });
//   //             }
//   //           }
//   //
//   //           void onCustomerSelected(Map<String, dynamic>? customer) {
//   //             setState(() {
//   //               selectedCustomer = customer;
//   //               if (customer != null) {
//   //                 nameCtrl.text = customer['name'] ?? '';
//   //                 phoneCtrl.text = customer['phone'] ?? '';
//   //                 showCustomerForm = false;
//   //               } else {
//   //                 nameCtrl.clear();
//   //                 phoneCtrl.clear();
//   //                 showCustomerForm = true;
//   //               }
//   //             });
//   //             validateForm();
//   //           }
//   //
//   //           return Dialog(
//   //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//   //             elevation: 8,
//   //             insetPadding: EdgeInsets.all(16),
//   //             child: Container(
//   //               constraints: BoxConstraints(
//   //                 maxHeight: MediaQuery.of(context).size.height * 0.9,
//   //                 maxWidth: 400,
//   //               ),
//   //               decoration: BoxDecoration(
//   //                 color: Colors.white,
//   //                 borderRadius: BorderRadius.circular(16),
//   //                 boxShadow: [
//   //                   BoxShadow(
//   //                     color: Colors.black.withOpacity(0.1),
//   //                     blurRadius: 10,
//   //                     offset: Offset(0, 4),
//   //                   ),
//   //                 ],
//   //               ),
//   //               child: Column(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 children: [
//   //                   // Header
//   //                   Container(
//   //                     padding: EdgeInsets.all(16),
//   //                     decoration: BoxDecoration(
//   //                       color: AppColors.tealColor.withOpacity(0.1),
//   //                       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//   //                     ),
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         Text(
//   //                           "Your Cart",
//   //                           style: TextStyle(
//   //                             fontSize: 20,
//   //                             fontWeight: FontWeight.bold,
//   //                             color: AppColors.tealColor,
//   //                           ),
//   //                         ),
//   //                         IconButton(
//   //                           icon: Icon(Icons.close, color: AppColors.tealColor),
//   //                           onPressed: () => Navigator.pop(context),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //
//   //                   // Cart Items (simplified for debugging)
//   //                   Expanded(
//   //                     child: Obx(() {
//   //                       if (controller.cart.isEmpty) {
//   //                         return Center(
//   //                           child: Column(
//   //                             mainAxisSize: MainAxisSize.min,
//   //                             children: [
//   //                               Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
//   //                               SizedBox(height: 8),
//   //                               Text(
//   //                                 "Your cart is empty",
//   //                                 style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         );
//   //                       }
//   //                       return ListView.builder(
//   //                         shrinkWrap: true,
//   //                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   //                         itemCount: controller.cart.length,
//   //                         itemBuilder: (context, index) {
//   //                           final item = controller.cart[index];
//   //                           return Card(
//   //                             margin: EdgeInsets.symmetric(vertical: 4),
//   //                             elevation: 2,
//   //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   //                             child: ListTile(
//   //                               title: Text(item.itemName),
//   //                               subtitle: Text("₹${item.price.toStringAsFixed(2)} x ${item.qty}"),
//   //                               trailing: Text("₹${(item.price * item.qty).toStringAsFixed(2)}"),
//   //                             ),
//   //                           );
//   //                         },
//   //                       );
//   //                     }),
//   //                   ),
//   //
//   //                   Divider(height: 1, thickness: 1),
//   //
//   //                   // Customer Selection Section with Debug Info
//   //                   Padding(
//   //                     padding: EdgeInsets.all(16),
//   //                     child: Column(
//   //                       crossAxisAlignment: CrossAxisAlignment.start,
//   //                       children: [
//   //                         Text(
//   //                           "Customer Details",
//   //                           style: TextStyle(
//   //                             fontSize: 16,
//   //                             fontWeight: FontWeight.bold,
//   //                             color: AppColors.tealColor,
//   //                           ),
//   //                         ),
//   //                         SizedBox(height: 8),
//   //
//   //                         // Debug Information
//   //                         Container(
//   //                           padding: EdgeInsets.all(8),
//   //                           decoration: BoxDecoration(
//   //                             color: Colors.grey.shade100,
//   //                             borderRadius: BorderRadius.circular(8),
//   //                           ),
//   //                           child: Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.start,
//   //                             children: [
//   //                               Text(
//   //                                 "Debug Info:",
//   //                                 style: TextStyle(
//   //                                   fontSize: 12,
//   //                                   fontWeight: FontWeight.bold,
//   //                                   color: Colors.blue,
//   //                                 ),
//   //                               ),
//   //                               Text(
//   //                                 debugMessage,
//   //                                 style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
//   //                               ),
//   //                               Text(
//   //                                 "Customers loaded: ${customers.length}",
//   //                                 style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
//   //                               ),
//   //                               Text(
//   //                                 "Loading: $isLoadingCustomers",
//   //                                 style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         SizedBox(height: 12),
//   //
//   //                         // Customer Dropdown with enhanced error handling
//   //                         if (isLoadingCustomers)
//   //                           Container(
//   //                             padding: EdgeInsets.all(16),
//   //                             decoration: BoxDecoration(
//   //                               border: Border.all(color: Colors.grey.shade300),
//   //                               borderRadius: BorderRadius.circular(12),
//   //                             ),
//   //                             child: Row(
//   //                               children: [
//   //                                 SizedBox(
//   //                                   width: 20,
//   //                                   height: 20,
//   //                                   child: CircularProgressIndicator(strokeWidth: 2),
//   //                                 ),
//   //                                 SizedBox(width: 12),
//   //                                 Expanded(
//   //                                   child: Column(
//   //                                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                                     children: [
//   //                                       Text("Loading customers..."),
//   //                                       Text(
//   //                                         debugMessage,
//   //                                         style: TextStyle(fontSize: 10, color: Colors.grey),
//   //                                       ),
//   //                                     ],
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           )
//   //                         else
//   //                           Container(
//   //                             decoration: BoxDecoration(
//   //                               border: Border.all(color: Colors.grey.shade300),
//   //                               borderRadius: BorderRadius.circular(12),
//   //                               color: Colors.grey.shade50,
//   //                             ),
//   //                             child: DropdownButtonFormField<Map<String, dynamic>?>(
//   //                               value: selectedCustomer,
//   //                               decoration: InputDecoration(
//   //                                 labelText: "Select Customer (${customers.length} available)",
//   //                                 border: InputBorder.none,
//   //                                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   //                                 prefixIcon: Icon(Icons.people_outline, color: AppColors.tealColor),
//   //                               ),
//   //                               items: [
//   //                                 DropdownMenuItem<Map<String, dynamic>?>(
//   //                                   value: null,
//   //                                   child: Text(
//   //                                     "Add New Customer",
//   //                                     style: TextStyle(
//   //                                       color: AppColors.tealColor,
//   //                                       fontWeight: FontWeight.w500,
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                                 ...customers.map((customer) {
//   //                                   return DropdownMenuItem<Map<String, dynamic>?>(
//   //                                     value: customer,
//   //                                     child: Column(
//   //                                       crossAxisAlignment: CrossAxisAlignment.start,
//   //                                       mainAxisSize: MainAxisSize.min,
//   //                                       children: [
//   //                                         Text(
//   //                                           customer['name'] ?? 'Unknown',
//   //                                           style: TextStyle(fontWeight: FontWeight.w500),
//   //                                         ),
//   //                                         Text(
//   //                                           customer['phone'] ?? '',
//   //                                           style: TextStyle(
//   //                                             fontSize: 12,
//   //                                             color: Colors.grey.shade600,
//   //                                           ),
//   //                                         ),
//   //                                       ],
//   //                                     ),
//   //                                   );
//   //                                 }).toList(),
//   //                               ],
//   //                               onChanged: onCustomerSelected,
//   //                             ),
//   //                           ),
//   //
//   //                         SizedBox(height: 12),
//   //
//   //                         // Manual Entry Form
//   //                         if (showCustomerForm || selectedCustomer == null)
//   //                           Form(
//   //                             key: formKey,
//   //                             child: Column(
//   //                               children: [
//   //                                 TextFormField(
//   //                                   controller: nameCtrl,
//   //                                   decoration: InputDecoration(
//   //                                     labelText: "Customer Name *",
//   //                                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//   //                                     prefixIcon: Icon(Icons.person_outline, color: AppColors.tealColor),
//   //                                   ),
//   //                                   validator: (value) => value?.trim().isEmpty ?? true ? "Enter customer name" : null,
//   //                                   onChanged: (value) => validateForm(),
//   //                                 ),
//   //                                 SizedBox(height: 12),
//   //                                 TextFormField(
//   //                                   controller: phoneCtrl,
//   //                                   decoration: InputDecoration(
//   //                                     labelText: "Phone Number *",
//   //                                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//   //                                     prefixIcon: Icon(Icons.phone_outlined, color: AppColors.tealColor),
//   //                                   ),
//   //                                   keyboardType: TextInputType.phone,
//   //                                   validator: (value) {
//   //                                     if (value?.trim().isEmpty ?? true) return "Enter phone number";
//   //                                     if (!RegExp(r'^\d{10}$').hasMatch(value!.trim())) return "Enter valid 10-digit number";
//   //                                     return null;
//   //                                   },
//   //                                   onChanged: (value) => validateForm(),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //
//   //                         // Selected Customer Display
//   //                         if (selectedCustomer != null)
//   //                           Container(
//   //                             padding: EdgeInsets.all(12),
//   //                             decoration: BoxDecoration(
//   //                               color: AppColors.tealColor.withOpacity(0.1),
//   //                               borderRadius: BorderRadius.circular(12),
//   //                             ),
//   //                             child: Row(
//   //                               children: [
//   //                                 Icon(Icons.person, color: AppColors.tealColor),
//   //                                 SizedBox(width: 12),
//   //                                 Expanded(
//   //                                   child: Column(
//   //                                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                                     children: [
//   //                                       Text(
//   //                                         selectedCustomer!['name'] ?? 'Unknown',
//   //                                         style: TextStyle(fontWeight: FontWeight.w600),
//   //                                       ),
//   //                                       Text(
//   //                                         selectedCustomer!['phone'] ?? '',
//   //                                         style: TextStyle(color: Colors.grey.shade600),
//   //                                       ),
//   //                                     ],
//   //                                   ),
//   //                                 ),
//   //                                 TextButton(
//   //                                   onPressed: () => onCustomerSelected(null),
//   //                                   child: Text("Change"),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //
//   //                   // Footer - simplified for debugging
//   //                   Container(
//   //                     padding: EdgeInsets.all(16),
//   //                     decoration: BoxDecoration(
//   //                       color: AppColors.tealColor.withOpacity(0.1),
//   //                       borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//   //                     ),
//   //                     child: ElevatedButton(
//   //                       style: ElevatedButton.styleFrom(
//   //                         backgroundColor: AppColors.tealColor,
//   //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   //                         minimumSize: Size(double.infinity, 50),
//   //                       ),
//   //                       onPressed: isFormValid ? () {
//   //                         print("Generate Invoice clicked");
//   //                         print("Selected customer: $selectedCustomer");
//   //                         print("Name: ${nameCtrl.text}");
//   //                         print("Phone: ${phoneCtrl.text}");
//   //                         Navigator.pop(context);
//   //                       } : null,
//   //                       child: Text(
//   //                         "Generate Invoice",
//   //                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//
//   /// ✅ Edit Item Dialog
//   // void _showEditItemDialog(BuildContext context, Item item) {
//   //   final nameCtrl = TextEditingController(text: item.itemName);
//   //   final priceCtrl = TextEditingController(text: item.price.toStringAsFixed(2));
//   //
//   //   showDialog(
//   //     context: context,
//   //     builder: (_) {
//   //       return AlertDialog(
//   //         title: const Text("Edit Item"),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             TextField(
//   //               controller: nameCtrl,
//   //               decoration: const InputDecoration(labelText: "Item Name"),
//   //             ),
//   //             TextField(
//   //               controller: priceCtrl,
//   //               keyboardType: TextInputType.number,
//   //               decoration: const InputDecoration(labelText: "Price"),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () => Navigator.pop(context),
//   //             child: const Text("Cancel"),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () async {
//   //               final newName = nameCtrl.text;
//   //               final newPrice = double.tryParse(priceCtrl.text) ?? item.price;
//   //
//   //               await controller.editItem(item.itemId, newName, newPrice);
//   //
//   //               // ✅ Safer way
//   //               if (Get.isDialogOpen ?? false) {
//   //                 Get.back(); // closes dialog safely
//   //               }
//   //             },
//   //             child: const Text("Save"),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//
// }


