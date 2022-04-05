import 'package:cloud_firestore/cloud_firestore.dart';

class Branch {
  final String email;
  final int value;
  final String uid;

  final String branchName;
  final String branchLocation;
  final String companyKey;
  final int activityStatus;

  Branch({
    required this.email,
    required this.branchName,
    required this.branchLocation,
    required this.value,
    required this.uid,
    required this.companyKey,
    required this.activityStatus,
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
      activityStatus: snapshot['activity_status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'branchName': branchName,
        'branchLocation': branchLocation,
        'value': value,
        'uid': uid,
        'companyKey': companyKey,
        'activity_status': activityStatus,
      };
}


/*
activity status: 0 : deactivate branch.
activity status: 1 : active branch.
activity status: 2 : payment pending [1 week] branch.

 */
