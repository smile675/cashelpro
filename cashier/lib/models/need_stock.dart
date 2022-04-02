import 'package:cloud_firestore/cloud_firestore.dart';

class NeedStock {
  String id;
  final String branchName;
  final String stockName;
  final String reqmessage;
  final String quantity;
  final DateTime reqDate;
  final String companyKey;

  NeedStock({
    required this.id,
    required this.branchName,
    required this.stockName,
    required this.reqmessage,
    required this.quantity,
    required this.reqDate,
    required this.companyKey,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'branchName': branchName,
        'stockName': stockName,
        'reqmessage': reqmessage,
        'quantity': quantity,
        'date': reqDate,
        'companyKey': companyKey,
      };

  static NeedStock fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return NeedStock(
        id: snapshot['id'],
        branchName: snapshot['branchName'],
        stockName: snapshot['stockName'],
        reqmessage: snapshot['reqmessage'],
        quantity: snapshot['quantity'],
        reqDate: snapshot['date'],
        companyKey: snapshot['companyKey']);
  }
}
