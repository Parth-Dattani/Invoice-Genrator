import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controller/controller.dart';
import '../../../model/model.dart';

class RevenueChartCard extends GetView<DashboardController> {
  static const pageId = "/RevenueChartCard";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  numberFormat: NumberFormat.compact(),
                  majorGridLines: MajorGridLines(
                    width: 1,
                    color: Colors.grey.shade100,
                  ),
                ),
                /// CORRECTED: Use CartesianSeries instead of ChartSeries
                // series: <CartesianSeries<RevenueData, String>>[
                //   LineSeries<RevenueData, String>(
                //     dataSource: controller.revenueData,
                //     xValueMapper: (RevenueData data, _) => data.month,
                //     yValueMapper: (RevenueData data, _) => data.revenue,
                //     color: Colors.blue,
                //     width: 3,
                //     markerSettings: MarkerSettings(isVisible: true),
                //   )
                // ],
                // Replace the series section with this:
                series: <CartesianSeries<RevenueData, String>>[
                  ColumnSeries<RevenueData, String>(
                    dataSource: controller.revenueData,
                    xValueMapper: (RevenueData data, _) => data.month,
                    yValueMapper: (RevenueData data, _) => data.revenue,
                    color: Colors.blue,
                    width: 0.6,
                    borderRadius: BorderRadius.circular(4),
                  )
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RevenueData {
  final String month;
  final double revenue;
  final int year;

  RevenueData({
    required this.month,
    required this.revenue,
    required this.year,
  });
}

// class RevenueChartCard extends GetView<DashboardController> {
//   static const pageId = "/RevenueChartCard";
//
//   const RevenueChartCard({Key? key}) : super(key: key);
//
//   // Generate revenue data for specified number of months
//   List<RevenueData> _generateRevenueData(List<Invoice> invoices, {int months = 6}) {
//     final now = DateTime.now();
//     final List<RevenueData> result = [];
//
//     for (int i = months - 1; i >= 0; i--) {
//       final monthDate = DateTime(now.year, now.month - i, 1);
//       final monthName = DateFormat('MMM').format(monthDate);
//       final year = monthDate.year;
//
//       // Calculate revenue for this month (only paid invoices)
//       double monthlyTotal = 0;
//       for (var invoice in invoices) {
//         if (invoice.issueDate != null &&
//             invoice.issueDate!.year == monthDate.year &&
//             invoice.issueDate!.month == monthDate.month &&
//             invoice.status?.toLowerCase() == 'paid') {
//           monthlyTotal += invoice.totalAmount ?? 0;
//         }
//       }
//
//       result.add(RevenueData(
//         month: monthName,
//         revenue: monthlyTotal,
//         year: year,
//       ));
//     }
//
//     return result;
//   }
//
//   // Get appropriate Y-axis interval based on max revenue
//   // Simplified Y-axis interval calculation
//   double _getYAxisInterval(double maxRevenue) {
//     if (maxRevenue <= 0) return 1000.0;
//
//     // Calculate appropriate interval based on max value
//     if (maxRevenue < 1000) return 200.0;
//     if (maxRevenue < 5000) return 1000.0;
//     if (maxRevenue < 20000) return 5000.0;
//     if (maxRevenue < 100000) return 20000.0;
//     if (maxRevenue < 500000) return 100000.0;
//     return 200000.0;
//   }
//
//   // Format currency for display
//   String _formatCurrency(double amount) {
//     if (amount >= 1000000) {
//       return '\$${(amount / 1000000).toStringAsFixed(1)}M';
//     } else if (amount >= 1000) {
//       return '\$${(amount / 1000).toStringAsFixed(1)}K';
//     } else {
//       return '\$${amount.toStringAsFixed(0)}';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Get dynamic revenue data from invoices for last 6 months
//       final revenueData = _generateRevenueData(
//         controller.invoiceList,
//         months: 6,
//       );
//
//       // Calculate statistics
//       final totalRevenue = revenueData.fold(0.0, (sum, data) => sum + data.revenue);
//       final maxRevenue = revenueData.isNotEmpty
//           ? revenueData.map((e) => e.revenue).reduce((a, b) => a > b ? a : b).toDouble()
//           : 0.0;
//       final yAxisInterval = _getYAxisInterval(maxRevenue);
//       final chartMax = maxRevenue > 0 ? maxRevenue * 1.2 : 10000;
//
//       return Container(
//         height: 240, // Slightly taller to accommodate stats
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 12,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with total revenue
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Revenue Trend',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey.shade800,
//                     ),
//                   ),
//                   if (totalRevenue > 0)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade50,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: Colors.green.shade100),
//                       ),
//                       child: Text(
//                         _formatCurrency(totalRevenue),
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.green.shade700,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//
//               const SizedBox(height: 8),
//
//               // Subtitle
//               Text(
//                 'Last 6 months • Paid invoices only',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               Expanded(
//                 child: revenueData.isEmpty
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.show_chart,
//                         size: 40,
//                         color: Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'No revenue data',
//                         style: TextStyle(
//                           color: Colors.grey.shade500,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Create paid invoices to see trends',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey.shade400,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : SfCartesianChart(
//                   margin: EdgeInsets.zero,
//                   plotAreaBorderWidth: 0,
//                   primaryXAxis: CategoryAxis(
//                     labelStyle: TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     majorGridLines: const MajorGridLines(width: 0),
//                     majorTickLines: const MajorTickLines(size: 0),
//                   ),
//                   primaryYAxis: NumericAxis(
//                     labelStyle: TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey.shade600,
//                     ),
//                     interval: yAxisInterval,
//                     maximum: chartMax.toDouble(),
//                     minimum: 0,
//                     // axisLabelFormatter: (AxisLabelRenderDetails details) {
//                     //   retun ChartAxisLabel(
//                     //     _formatCurrerncy(details.value),
//                     //     TextStyle(
//                     //       fontSize: 10,
//                     //       color: Colors.grey.shade600,
//                     //       fontWeight: FontWeight.w500,
//                     //     ),
//                     //   );
//                     // },
//                     //
//                     majorGridLines: MajorGridLines(
//                       width: 1,
//                       color: Colors.grey.shade100,
//                     ),
//                     majorTickLines: const MajorTickLines(size: 0),
//                   ),
//                   series: <CartesianSeries<RevenueData, String>>[
//                     LineSeries<RevenueData, String>(
//                       dataSource: controller.monthlyRevenueData,
//                       xValueMapper: (RevenueData data, _) => data.month,
//                       yValueMapper: (RevenueData data, _) => data.revenue,
//                       color: Colors.blue,
//                       width: 3,
//                       markerSettings: MarkerSettings(isVisible: true),
//                     )
//                   ],
//                   tooltipBehavior: TooltipBehavior(
//                     enable: true,
//                     activationMode: ActivationMode.singleTap,
//                     builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//                       final revenueData = data as RevenueData;
//                       return Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade700,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 8,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               revenueData.month,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               '\$${revenueData.revenue.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               // Quick stats footer
//               if (revenueData.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 Divider(height: 1, color: Colors.grey.shade200),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStatItem(
//                       icon: Icons.trending_up,
//                       label: 'Highest',
//                       value: _formatCurrency(maxRevenue),
//                       color: Colors.green,
//                     ),
//                     _buildStatItem(
//                       icon: Icons.calendar_today,
//                       label: 'Months',
//                       value: revenueData.length.toString(),
//                       color: Colors.blue,
//                     ),
//                     _buildStatItem(
//                       icon: Icons.av_timer,
//                       label: 'Avg/Month',
//                       value: _formatCurrency(totalRevenue / revenueData.length),
//                       color: Colors.orange,
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, size: 16, color: color),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             color: Colors.grey.shade500,
//           ),
//         ),
//       ],
//     );
//   }
// }