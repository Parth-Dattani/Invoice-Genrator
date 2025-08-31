class Item {
  final String itemId;
  final String itemName;
  final double price;

  final String unitOfMeasurement;
  final int currentStock;
  final String detailRequirement;
  final bool isActive;

  Item({
    required this.itemId,
    required this.itemName,
    required this.price,

    this.unitOfMeasurement = 'pcs',
    this.currentStock = 0,
    this.detailRequirement = '',
    this.isActive = true,
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

class Invoice {
  final String? invoiceId;
  final String itemId;
  final int qty;
  final double price;
  final String mobile;
  final String customerName;
  final String itemName;
  //final DateTime date;

  Invoice({
     this.invoiceId,
    required this.itemId,
    required this.qty,
    required this.price,
    required this.mobile,
    required this.customerName,
    required this.itemName, 
    //required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'itemId': itemId,
      'qty': qty,
      'price': price,
      'mobile': mobile,
      'customerName': customerName,
      'itemName': itemName, 
      //'date': date.toIso8601String(),
      'total': qty * price,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      invoiceId: map['invoiceId']?.toString() ?? '',
      itemId: map['itemId']?.toString() ?? '',
      qty: int.tryParse(map['qty']?.toString() ?? '0') ?? 0,
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      mobile: map['mobile']?.toString() ?? '',
      customerName: map['customerName']?.toString() ?? '',
      itemName: map['itemName']?.toString() ?? '',
      //date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// class Invoice {
//   final String pid;
//   final String productName;
//   final int qty;
//   final double price;
//   final String mobile;
//   //final DateTime date;
//
//   Invoice({
//     required this.pid,
//     required this.productName,
//     required this.qty,
//     required this.price,
//     required this.mobile,
//     //required this.date,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       "pid": pid,
//       "productName": productName,
//       "qty": qty,
//       "price": price,
//       "mobile": mobile,
//     //'date': date.toIso8601String(),
//     };
//   }
//
//   factory Invoice.fromJson(Map<String, dynamic> json) {
//     return Invoice(
//       pid: json["pid"] ?? "",
//       productName: json["productName"] ?? "",
//       qty: json["qty"] ?? 0,
//       price: (json["price"] ?? 0).toDouble(),
//       mobile: json["mobile"] ?? "",
//       //date: json["date"] ?? ""
//     );
//   }
//
//
//   Invoice copyWith({
//     String? pid,
//     String? productName,
//     int? qty,
//     double? price,
//     String? mobile,
//     //DateTime? date,
//   }) {
//     return Invoice(
//       pid: pid ?? this.pid,
//       productName: productName ?? this.productName,
//       qty: qty ?? this.qty,
//       price: price ?? this.price,
//       mobile: mobile ?? this.mobile,
//       ///date: date ?? this.date
//     );
//   }
// }
//
// class Item {
//   final String pid;
//   final String productName;
//   final double price;
//
//   Item({
//     required this.pid,
//     required this.productName,
//     required this.price,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'pid': pid,
//       'productName': productName,
//       'price': price,
//     };
//   }
//
//   factory Item.fromJson(Map<String, dynamic> json) {
//     return Item(
//       pid: json["pid"] ?? "",
//       productName: json["productName"] ?? "",
//       price: (json["price"] ?? 0).toDouble(),
//       //date: json["date"] ?? ""
//     );
//   }
// }
