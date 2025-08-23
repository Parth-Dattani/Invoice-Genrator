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

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId']?.toString() ?? '',
      itemName: json['itemName']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }

}

class Invoice {
  final String pid;
  final String productName;
  final int qty;
  final double price;
  final String mobile;
  final String userName;
  final DateTime date;

  Invoice({
    required this.pid,
    required this.productName,
    required this.qty,
    required this.price,
    required this.mobile,
    required this.userName,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'productName': productName,
      'qty': qty,
      'price': price,
      'mobile': mobile,
      'userName': userName,
      'date': date.toIso8601String(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      pid: map['pid']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      qty: int.tryParse(map['qty']?.toString() ?? '1') ?? 1,
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      mobile: map['mobile']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
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
