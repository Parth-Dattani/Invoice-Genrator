import 'dart:convert';

import 'package:demo_prac_getx/model/comment_model.dart';
import 'package:demo_prac_getx/services/api.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';
import '../utils/pdf_helper.dart';

class RemoteService{

  static const String appId = "24b22f90-835f-4202-a038-3f1dd7057aa8"; // Replace
  static const String accessKey = "V2-9NVog-SGuQ6-prAu2-HG5GE-Y6K1d-w40RW-XAlD5-EbLcB"; // Replace
  static const String invoiceTableName = "Invoice";
  static const String itemsTableName = "Item"; // Replace
  static const String apiKey = "cnp1X-AFICA-X25lf-NuAwm-jQfEr-Cj9nr-S9mqj-xOYni";



  static Future<http.Response> getComment() async {
    Map<String, String>header = {
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse(Apis.commetApi);

    http.Response response = await http.get(
        headers: header,
        uri);
    return response;
  }


  /// Add item to Items table
  static Future<void> addItem(Item item) async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    final body = jsonEncode({
      "Action": "Add",
      "Rows": [item.toMap()],
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("✅ Item added successfully: ${response.body}");
    } else {
      throw Exception("❌ Failed to add item: ${response.body}");
    }
  }



  static Future<void> addInvoice(List<Invoice> invoices) async {
   checkInvoiceTableStructure();
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");

    final body = jsonEncode({
      "Action": "Add",
      "Rows": invoices.map((e) => e.toMap()).toList(),
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey, // ✅ must match AppSheet key
      },
      body: body,
    );

    print("AppSheet Response:-saveRespo:---- ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      print("-----Error on saveInvoice() in service,,,, e.toString()}");
      final responseData = jsonDecode(response.body);
      if (responseData is Map && responseData.containsKey("RowsAffected")) {
        print("✅ Invoice sent successfully. Rows affected: ${responseData["RowsAffected"]}");
      }
      else {
        print("✅ Invoice sent successfully: ${response.body}");
      }
      // ⬇️ Share invoice after success
      ///await InvoiceHelper.generateAndShareInvoice(invoices);
    } else {
      throw Exception("❌ Failed to send invoice: ${response.body}");
    }
  }

  // Debug method to check table structure
  static Future<void> checkInvoiceTableStructure() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");

    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US",
        "Selector": 'Filter(1=1)',
        "SelectColumns": ["pid", "productName", "qty", "price", "mobile", "userName", "date"]
      }
    });

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ApplicationAccessKey": accessKey,
        },
        body: body,
      );

      print("Table Structure Response: ${response.statusCode} - ${response.body}");
    } catch (e) {
      print("Error checking table structure: $e");
    }
  }

  static Future<List<Invoice>> fetchInvoices() async {
    final url =
    Uri.parse("https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");

    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US",
        "Selector": 'Sort([{ColumnName: "date", Ascending: false}])',
      }
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey("Rows")) {
        final rows = data["Rows"] as List;
        return rows.map((e) => Invoice.fromMap(e)).toList();
      } else {
        throw Exception("Invalid response format: ${response.body}");
      }
    }  else {
      throw Exception("❌ Failed to load invoices: ${response.body}");
    }
  }

  // Get all items from Items table
  static Future<List<Item>> getItems() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");
  
    final body = jsonEncode({
      "Action": "Find",
      "Properties": {},
      "Rows": []
    });
  
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );
  
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // final List items = data['Rows'] ?? [];
      print("------------data:${data}");


      // return items.map((e) => Item.fromMap(e)).toList();
  
      if (data is List) {
        return data.map((e) => Item.fromMap(e)).toList();
      }
       else if (data is Map && data["Rows"] is List) {
        final rows = data["Rows"] as List;
        return rows.map((e) => Item.fromMap(e)).toList();
      }
      else {
        throw Exception("Invalid response format: ${response.body}");
      }
    } else {
      throw Exception("❌ Failed to load items: ${response.body}");
    }
  }

  static Future<void> addSingleInvoice(Map<String, dynamic> invoiceRow) async {
  final url = Uri.parse(
      "https://api.appsheet.com/api/v2/apps/$appId/tables/Invoice/Action");
  final body = jsonEncode({
    "Action": "Add",
    "Rows": [invoiceRow],
  });

  final response = await http.post(
    url,
    headers: {
      "ApplicationAccessKey": accessKey,
      "Content-Type": "application/json",
    },
    body: body,
  );

  print("AppSheet Response: ${response.statusCode} - ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("❌ Failed to send invoice: ${response.body}");
  }
}
}
