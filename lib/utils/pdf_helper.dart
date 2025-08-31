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
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' show Font;

import '../model/model.dart';

import 'package:printing/printing.dart';



class InvoiceHelper {
  static Future<void> generateAndShareInvoice(
      List<Invoice> invoices,
      String userName,
      String phoneNumber,
      ) async {
    final pdf = pw.Document();

    // Load a font that supports ₹ symbol (make sure font is in assets/fonts)
    final ttf = pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"));

    final theme = pw.ThemeData.withFont(
      base: ttf,
      bold: ttf,
      italic: ttf,
      boldItalic: ttf,
    );

    final String invoiceId = invoices.isNotEmpty
        ? (invoices.first.invoiceId ?? "UNKNOWN")
        : "UNKNOWN";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme, // ✅ Set theme so ₹ works everywhere
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
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Customer info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer: $userName'),
                      pw.Text('Phone: $phoneNumber'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
                      pw.Text('Invoice #: $invoiceId'),
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
                  pw.Expanded(flex: 3, child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(flex: 1, child: pw.Text('Qty', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(flex: 2, child: pw.Text('Price', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Expanded(flex: 2, child: pw.Text('Total', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ],
              ),
              pw.Divider(),

              // Items
              ...invoices.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(flex: 3, child: pw.Text(item.itemName)),
                      pw.Expanded(flex: 1, child: pw.Text('${item.qty}', textAlign: pw.TextAlign.center)),
                      pw.Expanded(flex: 2, child: pw.Text('₹${item.price.toStringAsFixed(2)}', textAlign: pw.TextAlign.right)),
                      pw.Expanded(flex: 2, child: pw.Text('₹${(item.price * item.qty).toStringAsFixed(2)}', textAlign: pw.TextAlign.right)),
                    ],
                  ),
                );
              }),

              pw.Divider(),

              // Grand total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Grand Total: ₹${invoices.fold<double>(0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2)}',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              pw.Center(
                child: pw.Text('Thank you for your business!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );

    // ✅ Show preview before sharing
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => pdf.save(),
    // );
    // /// Save to local file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$invoiceId.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("✅ PDF saved with filename: $invoiceId.pdf");

    /// Share
    await Share.shareXFiles([XFile(file.path)], text: "Here is your Invoice: $invoiceId");
  }

  static Future<void> generateAndPreviewInvoice(
      List<Invoice> invoices,
      String userName,
      String phoneNumber,
      ) async {
    final pdf = pw.Document();

    final ttf = pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"));

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text("Invoice Preview", style: pw.TextStyle(font: ttf, fontSize: 22)),
              pw.SizedBox(height: 20),
              pw.Text("Customer: $userName"),
              pw.Text("Phone: $phoneNumber"),
              pw.SizedBox(height: 10),
              ...invoices.map((e) => pw.Text(
                "${e.itemName} x${e.qty} = ₹${(e.price * e.qty).toStringAsFixed(2)}",
                style: pw.TextStyle(font: ttf),
              )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Grand Total: ₹${invoices.fold<double>(0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2)}',
                style: pw.TextStyle(font: ttf, fontSize: 18),
              ),
            ],
          );
        },
      ),
    );

    // ✅ Show preview before sharing
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
