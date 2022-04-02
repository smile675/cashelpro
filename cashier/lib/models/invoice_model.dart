//import 'package:cloud_firestore/cloud_firestore.dart';

//import '../providers/cart_providers.dart';

// this code for firestore invoice. i just keep, in case...

// class Invoice {
//   final String id;
//   final double amount;
//   // final List<CartItem> products;
//   final DateTime dateTime;
//   final String branchName;
//   final String companyKey;
//   final String invDay;
//   final String invMonth;

//   Invoice({
//     required this.id,
//     required this.amount,
//     // required this.products,
//     required this.dateTime,
//     required this.branchName,
//     required this.companyKey,
//     required this.invDay,
//     required this.invMonth,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'amount': amount,
//         // 'products': products,
//         'dateTime': dateTime,
//         'branchName': branchName,
//         'companyKey': companyKey,
//         'invDay': invDay,
//         'invMonth': invMonth,
//       };
//   static Invoice fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;

//     return Invoice(
//       id: snapshot['id'],
//       amount: snapshot['amount'],
//       // products: snapshot['products'],
//       dateTime: snapshot['dateTime'],
//       branchName: snapshot['branchName'],
//       companyKey: snapshot['companyKey'],
//       invDay: snapshot['invDay'],
//       invMonth: snapshot['invMonth'],
//     );
//   }
// }

// in order to save invoices in local database.

class Invoice {
  // database information //
  static const String invTableName = 'invoice_table';
  static const String colId = 'id';
  static const String colAmount = 'inv_amount';
//const String colDateTime = 'inv_date';
  static const String colBranchName = 'branch_name';
  static const String colInvPrefix = 'inv_prefix';
  static const String colinvDay = 'inv_day';
  static const String colinvMonth = 'inv_month';
  static const String colinvRef = 'inv_ref';
  static const String colPaymentTerm = 'term';
  static const String colCardReference = 'card_reference';
  static const String colPaymentReference = 'payment_reference';
  static const String colPaidAmount = 'paid';
  static const String colChange = 'change';

  int? id;
  final double amount;
  // final List<CartItem> products;
  //final DateTime dateTime;
  final String branchName;
  final String invPrefix;
  final String invDay;
  final String invMonth;
  final String invRef;
  final String paymentTerm;
  final String cardReference;
  final String paymentReference;
  final double paidAmount;
  final double changeAmount;

  Invoice({
    this.id,
    required this.amount,
    // required this.products,
    //required this.dateTime,
    required this.branchName,
    required this.invPrefix,
    required this.invDay,
    required this.invMonth,
    required this.invRef,
    required this.paymentReference,
    required this.cardReference,
    required this.paymentTerm,
    required this.paidAmount,
    required this.changeAmount,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colAmount: amount,
      // 'products': products,
      //colDateTime: dateTime,
      colBranchName: branchName,
      colInvPrefix: invPrefix,
      colinvDay: invDay,
      colinvMonth: invMonth,
      colinvRef: invRef,
      colPaymentTerm: paymentTerm,
      colCardReference: cardReference,
      colPaymentReference: paymentReference,
      colPaidAmount: paidAmount,
      colChange: changeAmount,
    };
    if (id != null) {
      map[colId] = id;
    }

    return map;
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map[colId],
      amount: map[colAmount],
      // products: snapshot['products'],
      // dateTime: map['dateTime'],
      branchName: map[colBranchName],
      invPrefix: map[colInvPrefix],
      invDay: map[colinvDay],
      invMonth: map[colinvMonth],
      invRef: map[colinvRef],
      paymentTerm: map[colPaymentTerm],
      cardReference: map[colCardReference],
      paymentReference: map[colPaymentReference],
      paidAmount: map[colPaidAmount],
      changeAmount: map[colChange],
    );
  }

  String get foundRef => invRef;
}
