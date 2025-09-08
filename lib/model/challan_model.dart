import 'item_model.dart';

class Challan {
  final String challanId;
  final DateTime? challanDate;
  final String customerId;
  final String customerName;
  final String customerMobile;
  final String customerEmail;
  final String customerAddress;
  final String itemId;
  final String itemName;
  final int qty;
  final double price;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final String paymentStatus;
  final String notes;
  final String status;
  final List<ChallanItem>? items;

  Challan({
    required this.challanId,
    required this.challanDate,
    this.customerId = '',
    required this.customerName,
    required this.customerMobile,
    this.customerEmail = '',
    this.customerAddress = '',
    required this.itemId,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.subtotal,
    this.taxRate = 0.0,
    this.taxAmount = 0.0,
    this.paymentStatus = 'Pending',
    this.notes = '',
    this.status = 'Draft',
    this.items
  });

  // Convert Challan object to Map
  Map<String, dynamic> toMap() {
    return {
      'challanId': challanId,
      'challanDate': challanDate?.toIso8601String(),
      'customerId': customerId,
      'customerName': customerName,
      'customerMobile': customerMobile,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'itemId': itemId,
      'itemName': itemName,
      'qty': qty,
      'price': price,
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'paymentStatus': paymentStatus,
      'notes': notes,
      'status': status,
    };
  }


  // Create Challan object from Map
  factory Challan.fromMap(Map<String, dynamic> map) {
    return Challan(
      challanId: map['challanId'] ?? '',
      challanDate: map['challanDate'] != null
          ? DateTime.tryParse(map['challanDate'])
          : map['challanDate'] != null
          ?  DateTime.tryParse(map['ChallanDate'])
          : null,
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerMobile: map['customerMobile'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
      customerAddress: map['customerAddress'] ?? '',
      itemId: map['itemId'] ?? '',
      itemName: map['itemName'] ?? '',
      qty: map['qty'] != null ? int.parse(map['qty'].toString()) : 0,
      price: map['price'] != null ? double.parse(map['price'].toString()) : 0.0,
      subtotal: map['subtotal'] != null ? double.parse(map['subtotal'].toString()) : 0.0,
      taxRate: map['taxRate'] != null ? double.parse(map['taxRate'].toString()) : 0.0,
      taxAmount: map['taxAmount'] != null ? double.parse(map['taxAmount'].toString()) : 0.0,
      paymentStatus: map['paymentStatus'] ?? 'Pending',
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'Draft',
      items: [],
    );
  }

  // Create Challan object from JSON
  factory Challan.fromJson(Map<String, dynamic> json) {
    return Challan(
      challanId: json['challanId']?.toString() ?? '',
      challanDate: json['challanDate'] != null
          ? DateTime.tryParse(json['challanDate'].toString())
          : null,
      customerId: json['customerId']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      customerMobile: json['customerMobile']?.toString() ?? '',
      customerEmail: json['customerEmail']?.toString() ?? '',
      customerAddress: json['customerAddress']?.toString() ?? '',
      itemId: json['itemId']?.toString() ?? '',
      itemName: json['itemName']?.toString() ?? '',
      qty: json['qty'] != null ? int.tryParse(json['qty'].toString()) ?? 0 : 0,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      subtotal: json['subtotal'] != null ? double.tryParse(json['subtotal'].toString()) ?? 0.0 : 0.0,
      taxRate: json['taxRate'] != null ? double.tryParse(json['taxRate'].toString()) ?? 0.0 : 0.0,
      taxAmount: json['taxAmount'] != null ? double.tryParse(json['taxAmount'].toString()) ?? 0.0 : 0.0,
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      notes: json['notes']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Draft',
      items: json['items'] != null
          ? (json['items'] as List).map((item) => ChallanItem.fromJson(item)).toList()
          : [],
    );
  }

  // Optional: Copy with method for easy updates
  Challan copyWith({
    String? challanId,
    DateTime? challanDate,
    String? customerId,
    String? customerName,
    String? customerMobile,
    String? customerEmail,
    String? customerAddress,
    String? itemId,
    String? itemName,
    int? qty,
    double? price,
    double? subtotal,
    double? taxRate,
    double? taxAmount,
    String? paymentStatus,
    String? notes,
    String? status,
    List<ChallanItem>? items,
  }) {
    return Challan(
      challanId: challanId ?? this.challanId,
      challanDate: challanDate ?? this.challanDate,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      customerEmail: customerEmail ?? this.customerEmail,
      customerAddress: customerAddress ?? this.customerAddress,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      subtotal: subtotal ?? this.subtotal,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      items: items,
    );
  }
}


class ChallanItem {
  final String description;
  final int quantity;
  final double price;
  final String itemId;
  final String itemName;
  final double totalPrice;

  ChallanItem({
    required this.description,
    required this.quantity,
    required this.price,
    required this.itemId,
    required this.itemName,
    required this.totalPrice,
  });

  double get amount => quantity * price;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'price': price,
      'itemId': itemId,
      'itemName': itemName,
      'totalPrice': totalPrice,
    };
  }

  factory ChallanItem.fromJson(Map<String, dynamic> map) {
    return ChallanItem(
      description: map['description']?.toString() ?? '',
      quantity: int.tryParse(map['quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(map['price']?.toString() ?? '0.0') ?? 0.0,
      itemId: map['itemId']?.toString() ?? '',
      itemName: map['itemName']?.toString() ?? '',
      totalPrice: double.tryParse(map['totalPrice']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  ChallanItem copyWith({
    String? description,
    int? quantity,
    double? price,
    String? itemId,
    String? itemName,
    double? totalPrice,
  }) {
    return ChallanItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}