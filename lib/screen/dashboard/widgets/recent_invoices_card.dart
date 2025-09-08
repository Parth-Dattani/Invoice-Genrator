import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/controller.dart';

class RecentInvoicesCard extends GetView<DashboardController> {
  static const pageId = "/RecentInvoicesCard";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Invoices',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                TextButton(
                  onPressed: controller.navigateToInvoiceList,
                  child: Text('View All'),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.invoiceList.take(5).length,
            reverse: true,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final invoice = controller.invoiceList.take(5).toList()[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor('paid').withOpacity(0.1),
                  child: Text(
                    invoice.customerName.substring(0, 1),
                    style: TextStyle(
                      color: _getStatusColor('paid'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  '${invoice.invoiceId} - ${invoice.customerName}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${invoice.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor('paid').withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'paid',
                        style: TextStyle(
                          color: _getStatusColor('paid'),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => controller.viewInvoiceDetails(invoice.invoiceId.toString()),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}
