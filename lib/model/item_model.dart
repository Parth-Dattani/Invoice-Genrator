class Item {
  final String itemId;
  final String itemName;
  final double price;

  Item({
    required this.itemId,
    required this.itemName,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'price': price,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemId: map['itemId']?.toString() ?? '',
      itemName: map['itemName']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
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
