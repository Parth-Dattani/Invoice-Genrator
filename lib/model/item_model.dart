import 'dart:convert';

class Item {
  final String itemId;
  final String itemName;
  final double price;

  final String unitOfMeasurement;
  final int currentStock;
  final String detailRequirement;
  final bool isActive;
  final String userId;

  Item({
    required this.itemId,
    required this.itemName,
    required this.price,

    this.unitOfMeasurement = 'pcs',
    this.currentStock = 0,
    this.detailRequirement = '',
    this.isActive = true,
    this.userId = '0',
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'price': price,

      'unitOfMeasurement': unitOfMeasurement,
      'currentStock': currentStock,
      'detailRequirement': detailRequirement,
      'isActive': isActive,
      "userId": userId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemId: map['itemId']?.toString() ?? '',
      itemName: map['itemName']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,

      unitOfMeasurement: map['unitOfMeasurement']?.toString() ?? 'pcs',
      currentStock: int.tryParse(map['currentStock']?.toString() ?? '0') ?? 0,
      detailRequirement: map['detailRequirement']?.toString() ?? '',
      isActive: _parseIsActive(map['isActive']),
      userId: map['userId']?.toString() ?? '',
    );
  }

  // Helper method to handle different isActive formats
  static bool _parseIsActive(dynamic value) {
    if (value == null) return true; // Default to active if null

    // Handle string values (AppSheet Yes/No)
    if (value is String) {
      final lowerValue = value.toLowerCase().trim();
      return lowerValue == 'yes' ||
          lowerValue == 'y' ||      // Handle "Y"/"N" format
          lowerValue == 'true' ||
          lowerValue == '1' ||
          lowerValue == 'active';
    }

    // Handle boolean values
    if (value is bool) {
      return value;
    }

    // Handle integer values (1 = true, 0 = false)
    if (value is int) {
      return value == 1;
    }

    // Handle numeric strings
    if (value is String && (value == '1' || value == '0')) {
      return value == '1';
    }

    // Default to true for any other case
    return true;
  }

  Item copyWith({
    String? itemId,
    String? itemName,
    double? price,
    String? unitOfMeasurement,
    int? currentStock,
    String? detailRequirement,
    bool? isActive,
  }) {
    return Item(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
      currentStock: currentStock ?? this.currentStock,
      detailRequirement: detailRequirement ?? this.detailRequirement,
      isActive: isActive ?? this.isActive,
    );
  }

}

// class Invoice {
//   final String? invoiceId;
//   final String itemId;
//   final int qty;
//   final double price;
//   final String mobile;
//   final String customerName;
//   final String itemName;
//   //final DateTime date;
//
//   Invoice({
//      this.invoiceId,
//     required this.itemId,
//     required this.qty,
//     required this.price,
//     required this.mobile,
//     required this.customerName,
//     required this.itemName,
//     //required this.date,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'invoiceId': invoiceId,
//       'itemId': itemId,
//       'qty': qty,
//       'price': price,
//       'mobile': mobile,
//       'customerName': customerName,
//       'itemName': itemName,
//       //'date': date.toIso8601String(),
//       'total': qty * price,
//     };
//   }
//
//   factory Invoice.fromMap(Map<String, dynamic> map) {
//     return Invoice(
//       invoiceId: map['invoiceId']?.toString() ?? '',
//       itemId: map['itemId']?.toString() ?? '',
//       qty: int.tryParse(map['qty']?.toString() ?? '0') ?? 0,
//       price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
//       mobile: map['mobile']?.toString() ?? '',
//       customerName: map['customerName']?.toString() ?? '',
//       itemName: map['itemName']?.toString() ?? '',
//       //date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
//     );
//   }
// }



///
class Invoice {
  final String invoiceId;
  final String itemId;
  final String itemName;
  final int qty;
  final double price;
  final String mobile;
  final String customerId;
  final String customerName;
  final String? customerEmail;
  final String? customerAddress;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final double? subtotal;
  final double? taxRate;
  final double? taxAmount;
  final double? discountAmount;
  //final String? discountType;
  final double? totalAmount;
  final String? notes;
  final String? status;
  final List<InvoiceItem>? items;
  final String? userId;

  Invoice({
    required this.invoiceId,
    required this.itemId,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.mobile,
    required this.customerName,
    this.customerId = '',
    this.customerEmail,
    this.customerAddress,
    this.issueDate,
    this.dueDate,
    this.subtotal,
    this.taxRate,
    this.taxAmount,
    this.discountAmount,
    //this.discountType,
    this.totalAmount,
    this.notes,
    this.status,
    this.items,
    this.userId
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'itemId': itemId,
      'itemName': itemName,
      'qty': qty,
      'price': price,
      'mobile': mobile,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'issueDate': issueDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      //'discountType': discountType,
      'totalAmount': totalAmount,
      'notes': notes,
      'status': status,
      ///'items': json.encode(items?.map((item) => item.toMap()).toList()),

    };
  }

  // Convert invoice items to a separate map for the items table
  List<Map<String, dynamic>> itemsToMap() {
    if (items == null) return [];

    return items!.map((item) {
      return {
        'invoiceId': invoiceId, // Foreign key reference
        'itemId': item.itemId,
        'description': item.description,
        'quantity': item.quantity,
        'rate': item.rate,
        'amount': item.amount,
      };
    }).toList();
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      invoiceId: map['invoiceId'] ?? map['InvoiceId'] ?? '',
      itemId: map['itemId'] ?? map['ItemId'] ?? '',
      itemName: map['itemName'] ?? map['ItemName'] ?? '',
      qty: (map['qty'] ?? map['Qty'] ?? map['quantity'] ?? 0) is int
          ? map['qty'] ?? map['Qty'] ?? map['quantity'] ?? 0
          : int.tryParse(map['qty']?.toString() ?? '0') ?? 0,
      price: (map['price'] ?? map['Price'] ?? 0.0) is double
          ? map['price'] ?? map['Price'] ?? 0.0
          : double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      mobile: map['mobile'] ?? map['Mobile'] ?? map['phone'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? map['CustomerName'] ?? map['customer'] ?? '',
      customerEmail: map['customerEmail'] ?? map['CustomerEmail'] ?? map['email'] ?? '',
      customerAddress: map['customerAddress'] ?? map['CustomerAddress'] ?? map['address'] ?? '',
      issueDate: map['issueDate'] != null
          ? DateTime.tryParse(map['issueDate'])
          : map['IssueDate'] != null
          ? DateTime.tryParse(map['IssueDate'])
          : null,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'])
          : map['DueDate'] != null
          ? DateTime.tryParse(map['DueDate'])
          : null,
      subtotal: (map['subtotal'] ?? map['Subtotal'] ?? 0.0) is double
          ? map['subtotal'] ?? map['Subtotal'] ?? 0.0
          : double.tryParse(map['subtotal']?.toString() ?? '0') ?? 0.0,
      taxRate: (map['taxRate'] ?? map['TaxRate'] ?? 0.0) is double
          ? map['taxRate'] ?? map['TaxRate'] ?? 0.0
          : double.tryParse(map['taxRate']?.toString() ?? '0') ?? 0.0,
      taxAmount: (map['taxAmount'] ?? map['TaxAmount'] ?? 0.0) is double
          ? map['taxAmount'] ?? map['TaxAmount'] ?? 0.0
          : double.tryParse(map['taxAmount']?.toString() ?? '0') ?? 0.0,
      discountAmount: (map['discountAmount'] ?? map['DiscountAmount'] ?? 0.0) is double
          ? map['discountAmount'] ?? map['DiscountAmount'] ?? 0.0
          : double.tryParse(map['discountAmount']?.toString() ?? '0') ?? 0.0,
      //discountType: map['discountType'] ?? map['DiscountType'] ?? 'amount',
      totalAmount: (map['totalAmount'] ?? map['TotalAmount'] ?? 0.0) is double
          ? map['totalAmount'] ?? map['TotalAmount'] ?? 0.0
          : double.tryParse(map['totalAmount']?.toString() ?? '0') ?? 0.0,
      notes: map['notes'] ?? map['Notes'] ?? '',
      status: map['status'] ?? map['Status'] ?? 'issued',
      items: [],
      userId: map['userId'] ?? '',
    );
  }

  // Helper method to create a copy of the invoice with updated values
  Invoice copyWith({
    String? invoiceId,
    String? itemId,
    String? itemName,
    int? qty,
    double? price,
    String? mobile,
    String? customerName,
    String? customerEmail,
    String? customerAddress,
    DateTime? issueDate,
    DateTime? dueDate,
    double? subtotal,
    double? taxRate,
    double? taxAmount,
    double? discountAmount,
    //String? discountType,
    double? totalAmount,
    String? notes,
    String? status,
    List<InvoiceItem>? items,
  }) {
    return Invoice(
      invoiceId: invoiceId ?? this.invoiceId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      mobile: mobile ?? this.mobile,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerAddress: customerAddress ?? this.customerAddress,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      subtotal: subtotal ?? this.subtotal,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      //discountType: discountType ?? this.discountType,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      items: items,
    );
  }

  @override
  String toString() {
    return 'Invoice(invoiceId: $invoiceId, itemId: $itemId, itemName: $itemName, qty: $qty, price: $price, mobile: $mobile, customerName: $customerName)';
  }
}


class InvoiceItem {
  final String description;
  final int quantity;
  final double rate;
  final String itemId;
  final String itemName;
  final double totalPrice;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.rate,
    required this.itemId,
    required this.itemName,
    required this.totalPrice,
  });

  // Use the totalPrice from API instead of calculating
  double get amount => quantity * rate;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'rate': rate,
      'itemId': itemId,
      'itemName': itemName,
      'totalPrice': totalPrice,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> map) {
    return InvoiceItem(
      description: map['description']?.toString() ?? '',
      quantity: int.tryParse(map['quantity']?.toString() ?? '0') ?? 0,
      rate: double.tryParse(map['price']?.toString() ?? '0.0') ?? 0.0,
      itemId: map['itemId']?.toString() ?? '',
      itemName: map['itemName']?.toString() ?? '',
      totalPrice: double.tryParse(map['totalPrice']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) => InvoiceItem.fromJson(map);

  InvoiceItem copyWith({
    String? description,
    int? quantity,
    double? rate,
    String? itemId,
    String? itemName,
    double? totalPrice,
  }) {
    return InvoiceItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}