// screens/invoice/invoice_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/controller.dart';
import '../../model/model.dart';

class InvoiceListScreen extends GetView<InvoiceListController> {
  static const String pageId = '/InvoiceListScreen';

  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.refreshInvoices,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed('/new-invoice'),
            tooltip: 'Create New Invoice',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(),

          // Statistics Section
          _buildStatisticsSection(),

          // Invoice List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              if (controller.filteredInvoiceList.isEmpty) {
                return _buildEmptyState();
              }

              return _buildInvoiceList();
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/new-invoice'),
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search invoices...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: controller.filterInvoices,
          ),
          SizedBox(height: 12),

          // Filter Chips
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', controller.selectedFilter.value == 'All'),
                SizedBox(width: 8),
                _buildFilterChip('Paid', controller.selectedFilter.value == 'Paid'),
                SizedBox(width: 8),
                _buildFilterChip('Pending', controller.selectedFilter.value == 'Pending'),
                SizedBox(width: 8),
                _buildFilterChip('Overdue', controller.selectedFilter.value == 'Overdue'),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => controller.filterByStatus(label),
      selectedColor: Colors.blue.shade700,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Obx(() => Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', controller.totalInvoices.toString(), Colors.blue),
          _buildStatItem('Paid', controller.paidInvoices.toString(), Colors.green),
          _buildStatItem('Pending', controller.pendingInvoices.toString(), Colors.orange),
          _buildStatItem('Revenue', '\$${controller.totalRevenue.toStringAsFixed(2)}', Colors.purple),
        ],
      ),
    ));
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading invoices...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'No invoices found',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first invoice to get started',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.toNamed('/new-invoice'),
            child: Text('Create Invoice'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList() {
    return Obx(() => ListView.builder(
      padding: EdgeInsets.only(bottom: 80),
      itemCount: controller.filteredInvoiceList.length,
      itemBuilder: (context, index) {
        final invoice = controller.filteredInvoiceList[index];
        ///final invoiceItem = controller.invoiceItem[index];
        return _buildInvoiceListItem(invoice, );
      },
    ));
  }

  Widget _buildInvoiceListItem(Invoice invoice, ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        //key: Key(invoice.invoiceId),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(invoice.status),
          child: Icon(
            Icons.receipt,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          invoice.invoiceId ?? 'No ID',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invoice.customerName ?? 'No Customer'),
            Text(
              '${DateFormat('MMM dd, yyyy').format(invoice.issueDate ?? DateTime.now())} • \$${invoice.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        // In your _buildInvoiceListItem method, add a new PopupMenuItem
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            // Add this new option for PDF export
            PopupMenuItem(
              value: 'export_pdf',
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, size: 20),
                  SizedBox(width: 8),
                  Text('Export as PDF'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'view':
                controller.viewInvoiceDetails(invoice);
                break;
              case 'export_pdf': // Handle PDF export
                controller.exportInvoiceAsPdf(invoice,);
                break;
              case 'edit':
                controller.editInvoice(invoice);
                break;
              case 'delete':
                controller.deleteInvoice(invoice);
                break;
            }
          },
        ),
        // trailing: PopupMenuButton(
        //   itemBuilder: (context) => [
        //     PopupMenuItem(
        //       value: 'view',
        //       child: Row(
        //         children: [
        //           Icon(Icons.visibility, size: 20),
        //           SizedBox(width: 8),
        //           Text('View Details'),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem(
        //       value: 'edit',
        //       child: Row(
        //         children: [
        //           Icon(Icons.edit, size: 20),
        //           SizedBox(width: 8),
        //           Text('Edit'),
        //         ],
        //       ),
        //     ),
        //     PopupMenuItem(
        //       value: 'delete',
        //       child: Row(
        //         children: [
        //           Icon(Icons.delete, size: 20, color: Colors.red),
        //           SizedBox(width: 8),
        //           Text('Delete', style: TextStyle(color: Colors.red)),
        //         ],
        //       ),
        //     ),
        //   ],
        //   onSelected: (value) {
        //     switch (value) {
        //       case 'view':
        //         controller.viewInvoiceDetails(invoice);
        //         break;
        //       case 'edit':
        //         controller.editInvoice(invoice);
        //         break;
        //       case 'delete':
        //         controller.deleteInvoice(invoice);
        //         break;
        //     }
        //   },
        // ),
        onTap: () => controller.viewInvoiceDetails(invoice),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

