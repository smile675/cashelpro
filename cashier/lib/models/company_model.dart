import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String companyName;
  final String currencyCode;
  final String companyKey;
  final String uid;

  final String companyEmail;

  final String fullAddress;
  final String hqLocation;
  final String phoneNumber;

  Company({
    required this.companyName,
    required this.currencyCode,
    required this.companyKey,
    required this.companyEmail,
    required this.phoneNumber,
    required this.fullAddress,
    required this.hqLocation,
    required this.uid,
  });

  static Company fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Company(
      companyName: snapshot['companyName'],
      currencyCode: snapshot['currencyCode'],
      companyKey: snapshot['companyKey'],
      companyEmail: snapshot['companyEmail'],
      phoneNumber: snapshot['phoneNumber'],
      fullAddress: snapshot['fullAddress'],
      hqLocation: snapshot['hqLocation'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'currencyCode': currencyCode,
        'companyKey': companyKey,
        'companyEmail': companyEmail,
        'phoneNumber': phoneNumber,
        'fullAddress': fullAddress,
        'hqLocation': hqLocation,
        'uid': uid,
      };
}
