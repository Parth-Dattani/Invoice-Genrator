// import 'dart:io';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../model/model.dart';
//
//
// class PdfHelper {
//   static Future<void> generateInvoice(List<Item> items) async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text("Invoice", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//               pw.Table.fromTextArray(
//                 headers: ["Item", "Qty", "Price", "Total"],
//                 data: items.map((item) => [
//                   item.name,
//                   item.qty.toString(),
//                   item.price.toString(),
//                   (item.qty * item.price).toString()
//                 ]).toList(),
//               ),
//               pw.Divider(),
//               pw.Text(
//                 "Grand Total: ₹${items.fold(0.0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2)}",
//                 style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File("${dir.path}/invoice.pdf");
//     await file.writeAsBytes(await pdf.save());
//
//     await Share.shareXFiles([XFile(file.path)], text: "Here is your invoice");
//   }
// }

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' show Font;

import '../model/model.dart';

class InvoiceHelper {
  static Future<void> generateAndShareInvoice(
    List<Invoice> invoices,
    String userName,
    String phoneNumber,
  ) async {
    final pdf = pw.Document();

    // Use a font that supports ₹ and Unicode (NotoSans)

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    //font: boldFont,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Customer information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer: $userName', style: pw.TextStyle()),
                      pw.Text('Phone: $phoneNumber', style: pw.TextStyle()),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}', style: pw.TextStyle()),
                      pw.Text('Invoice #: ${invoices.isNotEmpty ? invoices.first.invoiceId ?? "" : ""}', style: pw.TextStyle()),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),

              // Table header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'Item',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Qty',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Price',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Total',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
              pw.Divider(),

              // Invoice items
              ...invoices.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(item.itemName, style: pw.TextStyle()),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          '${item.qty}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '₹${item.price.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '₹${(item.price * item.qty).toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              pw.Divider(),

              // Grand Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Grand Total: ₹${invoices.fold<double>(0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,

                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Thank you for your business!',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,

                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF file locally
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Share PDF file
    await Share.shareXFiles([XFile(file.path)], text: "Here is your Invoice");
  }
}