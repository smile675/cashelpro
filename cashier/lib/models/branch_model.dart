import 'package:cloud_firestore/cloud_firestore.dart';

class Branch {
  final String email;
  final int value;
  final String uid;

  final String branchName;
  final String branchLocation;
  final String companyKey;

  Branch({
    required this.email,
    required this.branchName,
    required this.branchLocation,
    required this.value,
    required this.uid,
    required this.companyKey,
  });

  static Branch fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Branch(
      email: snapshot['email'],
      branchName: snapshot['branchName'],
      branchLocation: snapshot['branchLocation'],
      value: snapshot['value'],
      uid: snapshot['uid'],
      companyKey: snapshot['companyKey'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'branchName': branchName,
        'branchLocation': branchLocation,
        'value': value,
        'uid': uid,
        'companyKey': companyKey,
      };
}
