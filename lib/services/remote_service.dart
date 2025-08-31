import 'dart:convert';

import 'package:demo_prac_getx/model/comment_model.dart';
import 'package:demo_prac_getx/services/api.dart';
import 'package:http/http.dart' as http;

import '../model/model.dart';
import '../utils/pdf_helper.dart';

///old Working
// class RemoteService{
//
//   static const String appId = "24b22f90-835f-4202-a038-3f1dd7057aa8"; // Replace
//   static const String accessKey = "V2-9NVog-SGuQ6-prAu2-HG5GE-Y6K1d-w40RW-XAlD5-EbLcB"; // Replace
//   static const String invoiceTableName = "Invoice";
//   static const String itemsTableName = "Item"; // Replace
//   static const String apiKey = "cnp1X-AFICA-X25lf-NuAwm-jQfEr-Cj9nr-S9mqj-xOYni";
//
//
//
//   static Future<http.Response> getComment() async {
//     Map<String, String>header = {
//       'Content-Type': 'application/json',
//     };
//
//     final uri = Uri.parse(Apis.commetApi);
//
//     http.Response response = await http.get(
//         headers: header,
//         uri);
//     return response;
//   }
//
//
//   /// Add item to Items table
//   static Future<void> addItem(Item item) async {
//     final url = Uri.parse(
//         "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");
//
//     final body = jsonEncode({
//       "Action": "Add",
//       "Rows": [item.toMap()],
//     });
//
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ApplicationAccessKey": accessKey,
//       },
//       body: body,
//     );
//
//     if (response.statusCode == 200) {
//       print("✅ Item added successfully: ${response.body}");
//     } else {
//       throw Exception("❌ Failed to add item: ${response.body}");
//     }
//   }
//
//
//
//   static Future<void> addInvoice(List<Invoice> invoices) async {
//    checkInvoiceTableStructure();
//     final url = Uri.parse(
//         "https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");
//
//     final body = jsonEncode({
//       "Action": "Add",
//       "Rows": invoices.map((e) => e.toMap()).toList(),
//     });
//
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ApplicationAccessKey": accessKey, // ✅ must match AppSheet key
//       },
//       body: body,
//     );
//
//     print("AppSheet Response:-saveRespo:---- ${response.statusCode} - ${response.body}");
//
//     if (response.statusCode == 200) {
//       print("-----Error on saveInvoice() in service,,,, e.toString()}");
//       final responseData = jsonDecode(response.body);
//       if (responseData is Map && responseData.containsKey("RowsAffected")) {
//         print("✅ Invoice sent successfully. Rows affected: ${responseData["RowsAffected"]}");
//       }
//       else {
//         print("✅ Invoice sent successfully: ${response.body}");
//       }
//       // ⬇️ Share invoice after success
//       ///await InvoiceHelper.generateAndShareInvoice(invoices);
//     } else {
//       throw Exception("❌ Failed to send invoice: ${response.body}");
//     }
//   }
//
//   // Debug method to check table structure
//   static Future<void> checkInvoiceTableStructure() async {
//     final url = Uri.parse(
//         "https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");
//
//     final body = jsonEncode({
//       "Action": "Find",
//       "Properties": {
//         "Locale": "en-US",
//         "Selector": 'Filter(1=1)',
//         "SelectColumns": ["pid", "productName", "qty", "price", "mobile", "userName", "date"]
//       }
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "ApplicationAccessKey": accessKey,
//         },
//         body: body,
//       );
//
//       print("Table Structure Response: ${response.statusCode} - ${response.body}");
//     } catch (e) {
//       print("Error checking table structure: $e");
//     }
//   }
//
//   static Future<List<Invoice>> fetchInvoices() async {
//     final url =
//     Uri.parse("https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");
//
//     final body = jsonEncode({
//       "Action": "Find",
//       "Properties": {
//         "Locale": "en-US",
//         "Selector": 'Sort([{ColumnName: "date", Ascending: false}])',
//       }
//     });
//
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ApplicationAccessKey": accessKey,
//       },
//       body: body,
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data is Map && data.containsKey("Rows")) {
//         final rows = data["Rows"] as List;
//         return rows.map((e) => Invoice.fromMap(e)).toList();
//       } else {
//         throw Exception("Invalid response format: ${response.body}");
//       }
//     }  else {
//       throw Exception("❌ Failed to load invoices: ${response.body}");
//     }
//   }
//
//
//   // Get all items from Items table
//   static Future<List<Item>> getItems() async {
//     final url = Uri.parse(
//         "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");
//
//     final body = jsonEncode({
//       "Action": "Find",
//       "Properties": {},
//       "Rows": []
//     });
//
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ApplicationAccessKey": accessKey,
//       },
//       body: body,
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // final List items = data['Rows'] ?? [];
//       print("------------data:${data}");
//
//
//       // return items.map((e) => Item.fromMap(e)).toList();
//
//       if (data is List) {
//         return data.map((e) => Item.fromMap(e)).toList();
//       }
//        else if (data is Map && data["Rows"] is List) {
//         final rows = data["Rows"] as List;
//         return rows.map((e) => Item.fromMap(e)).toList();
//       }
//       else {
//         throw Exception("Invalid response format: ${response.body}");
//       }
//     } else {
//       throw Exception("❌ Failed to load items: ${response.body}");
//     }
//   }
//
//   static Future<void> addSingleInvoice(Map<String, dynamic> invoiceRow) async {
//   final url = Uri.parse(
//       "https://api.appsheet.com/api/v2/apps/$appId/tables/Invoice/Action");
//   final body = jsonEncode({
//     "Action": "Add",
//     "Rows": [invoiceRow],
//   });
//
//   final response = await http.post(
//     url,
//     headers: {
//       "ApplicationAccessKey": accessKey,
//       "Content-Type": "application/json",
//     },
//     body: body,
//   );
//
//   print("AppSheet Response: ${response.statusCode} - ${response.body}");
//
//   if (response.statusCode != 200) {
//     throw Exception("❌ Failed to send invoice: ${response.body}");
//   }
// }
//
//   static Future<void> editItem(String itemId, String newName, double newPrice) async {
//     final url = Uri.parse(
//       "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action",
//     );
//
//     final body = jsonEncode({
//       "Action": "Edit",
//       "Rows": [
//         {
//           "itemId": itemId,
//           "itemName": newName,
//           "price": newPrice.toStringAsFixed(2), // keeping 2 decimals
//         }
//       ]
//     });
//
//     print("Editing item: $body");
//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "ApplicationAccessKey": accessKey,
//       },
//       body: body,
//     );
//
//     print("Edit Item Response: ${response.statusCode} - ${response.body}");
//     if (response.statusCode != 200) {
//       throw Exception("❌ Failed to edit item: ${response.body}");
//     }
//   }
// }


///new
class RemoteService {
  static const String appId = "24b22f90-835f-4202-a038-3f1dd7057aa8";
  static const String accessKey = "V2-9NVog-SGuQ6-prAu2-HG5GE-Y6K1d-w40RW-XAlD5-EbLcB";
  static const String invoiceTableName = "Invoice";
  static const String itemsTableName = "Item";
  static const String apiKey = "cnp1X-AFICA-X25lf-NuAwm-jQfEr-Cj9nr-S9mqj-xOYni";

  static Future<http.Response> getComment() async {
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse(Apis.commetApi);

    http.Response response = await http.get(headers: header, uri);
    return response;
  }

  /// Add item to Items table with enhanced fields
  static Future<void> addItem(Item item) async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    final body = jsonEncode({
      "Action": "Add",
      "Rows": [item.toMap()],
    });

    print("Adding item with data: ${item.toMap()}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("Add Item Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      print("Item added successfully: ${response.body}");
    } else {
      throw Exception("Failed to add item: ${response.body}");
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
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("AppSheet Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is Map && responseData.containsKey("RowsAffected")) {
        print("Invoice sent successfully. Rows affected: ${responseData["RowsAffected"]}");
      } else {
        print("Invoice sent successfully: ${response.body}");
      }
    } else {
      throw Exception("Failed to send invoice: ${response.body}");
    }
  }

  static Future<void> checkInvoiceTableStructure() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");

    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US",
        "Selector": 'Filter(1=1)',
        "SelectColumns": ["invoiceId", "itemId", "itemName", "qty", "price", "mobile", "customerName"]
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
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$invoiceTableName/Action");

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
    } else {
      throw Exception("Failed to load invoices: ${response.body}");
    }
  }

  /// Get all items from Items table with enhanced fields
  static Future<List<Item>> getItemsoldwork() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US",
        "Selector": 'Filter(1=1)', // Get all items
        "SelectColumns": [
          "itemId",
          "itemName",
          "price",
          "unitOfMeasurement",
          "currentStock",
          "detailRequirement",
          "isActive"
        ]
      }
    });

    print("Fetching items with request: $body");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("Get Items Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((e) => Item.fromMap(e)).toList();
      } else if (data is Map && data["Rows"] is List) {
        final rows = data["Rows"] as List;
        return rows.map((e) => Item.fromMap(e)).toList();
      } else {
        throw Exception("Invalid response format: ${response.body}");
      }
    } else {
      throw Exception("Failed to load items: ${response.body}");
    }
  }

  // Add this test method to your RemoteService class
  static Future<void> testConnection() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    // Test with minimal request first
    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US"
        // No Selector or SelectColumns - get everything
      }
    });

    print("Testing connection with: $body");
    print("App ID: $appId");
    print("Table Name: $itemsTableName");
    print("Access Key: ${accessKey.substring(0, 10)}..."); // Show first 10 chars only

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("Test Response: ${response.statusCode}");
    print("Test Response Body: '${response.body}'");

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      print("Test Data Structure: ${data.runtimeType}");
      if (data is List) {
        print("Found ${data.length} items");
        if (data.isNotEmpty) {
          print("First item keys: ${data[0].keys.toList()}");
        }
      } else if (data is Map) {
        print("Response keys: ${data.keys.toList()}");
      }
    }
  }

  static Future<List<Item>> getItems() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US",
        // "Selector": 'Filter(1=1)', // Get all items
        // "SelectColumns": [
        //   "itemId",
        //   "itemName",
        //   "price",
        //   "unitOfMeasurement",
        //   "currentStock",
        //   "detailRequirement",
        //   "isActive"
        // ]
      }
    });

    print("Fetching items with request: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ApplicationAccessKey": accessKey,
        },
        body: body,
      );

      print("Get Items Response: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body Length: ${response.body.length}");
      print("Response Body: '${response.body}'"); // Added quotes to see exact content

      if (response.statusCode == 200) {
        // Check if response body is empty or just whitespace
        if (response.body.trim().isEmpty) {
          print("Warning: Response body is empty, returning empty list");
          return <Item>[];
        }

        dynamic data;
        try {
          data = jsonDecode(response.body);
        } catch (jsonError) {
          print("JSON Decode Error: $jsonError");
          print("Raw response body: ${response.body.codeUnits}"); // Show as code units for debugging
          throw Exception("Failed to parse JSON response: $jsonError");
        }

        print("Parsed data type: ${data.runtimeType}");
        print("Parsed data: $data");

        if (data is List) {
          print("Processing data as direct list with ${data.length} items");
          return data.map((e) {
            print("Processing item: $e");
            return Item.fromMap(e as Map<String, dynamic>);
          }).toList();
        } else if (data is Map && data["Rows"] is List) {
          final rows = data["Rows"] as List;
          print("Processing data as map with Rows containing ${rows.length} items");
          return rows.map((e) {
            print("Processing row: $e");
            return Item.fromMap(e as Map<String, dynamic>);
          }).toList();
        } else if (data is Map && data.isEmpty) {
          print("Received empty map, returning empty list");
          return <Item>[];
        } else {
          print("Unexpected data structure received");
          print("Data keys: ${data is Map ? data.keys.toList() : 'Not a map'}");
          throw Exception("Invalid response format. Expected List or Map with 'Rows', got: ${data.runtimeType}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        print("Error response: ${response.body}");
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Network or processing error: $e");
      rethrow;
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
      throw Exception("Failed to send invoice: ${response.body}");
    }
  }

  /// Edit item with all enhanced fields
  // Replace your current RemoteService.editItem method with this
  static Future<void> editItem(Item item) async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    final body = jsonEncode({
      "Action": "Edit",
      "Properties": {"Locale": "en-US"},
      // "Rows": [
      //   {
      //     "itemId": item.itemId.toString(),
      //     "itemName": item.itemName,
      //     "price": item.price,
      //     "unitOfMeasurement": item.unitOfMeasurement,
      //     "currentStock": item.currentStock,
      //     "detailRequirement": item.detailRequirement,
      //     "isActive": item.isActive ? "TRUE" : "FALSE", // Your table uses TRUE/FALSE
      //   }
      // ]
    });

    print("Edit Request Body: $body");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("Edit Response: ${response.statusCode} - '${response.body}'");

    // FIX: Accept empty response body as success for AppSheet
    if (response.statusCode == 200) {
      // AppSheet often returns empty body for successful edits
      if (response.body.trim().isEmpty) {
        print("✅ Edit successful (empty response body is normal for AppSheet edits)");
        return;
      }

      // If there is a response body, validate it
      try {
        final responseData = jsonDecode(response.body);
        print("✅ Edit successful with response data: $responseData");
        return;
      } catch (e) {
        // If we can't parse the response but status is 200, still consider it success
        print("✅ Edit successful (couldn't parse response but status is 200)");
        return;
      }
    } else {
      throw Exception("Failed to edit item: HTTP ${response.statusCode} - ${response.body}");
    }
  }


  /// Update only stock for an item
  static Future<void> updateItemStock(String itemId, int newStock) async {
    final url = Uri.parse(
      "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action",
    );

    final body = jsonEncode({
      "Action": "Edit",
      "Rows": [
        {
          "itemId": itemId,
          "currentStock": newStock,
        }
      ]
    });

    print("Updating stock for item $itemId to $newStock");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("Update Stock Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to update stock: ${response.body}");
    }
  }

  /// Delete item (set as inactive)
  static Future<void> deleteItem(String itemId) async {
    final url = Uri.parse(
      "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action",
    );

    final body = jsonEncode({
      "Action": "Edit",
      "Rows": [
        {
          "itemId": itemId,
          "isActive": 0, // Set as inactive instead of deleting
        }
      ]
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ApplicationAccessKey": accessKey,
      },
      body: body,
    );

    print("Delete Item Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to delete item: ${response.body}");
    }
  }

  /// Check if item table structure is correct for enhanced fields
  static Future<void> checkItemTableStructure() async {
    final url = Uri.parse(
        "https://api.appsheet.com/api/v2/apps/$appId/tables/$itemsTableName/Action");

    final body = jsonEncode({
      "Action": "Find",
      "Properties": {
        "Locale": "en-US",
        "Selector": 'Filter(1=1)',
        "SelectColumns": [
          "itemId",
          "itemName",
          "price",
          "unitOfMeasurement",
          "currentStock",
          "detailRequirement",
          "isActive"
        ]
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

      print("Item Table Structure Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode != 200) {
        print("Warning: Item table may not have all required columns");
        print("Expected columns: itemId, itemName, price, unitOfMeasurement, currentStock, detailRequirement, isActive");
      }
    } catch (e) {
      print("Error checking item table structure: $e");
    }
  }
}