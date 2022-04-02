// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../Widgets/request_card.dart';

// class StockRequest extends StatelessWidget {
//   const StockRequest({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final companyKey = FirebaseAuth.instance.currentUser!.uid;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Stock Request',
//         ),
//       ),
//       body: Center(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('stockRequirement')
//               .where('companyKey', isEqualTo: companyKey)
//               .snapshots(),
//           builder: (context,
//               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.data!.docs.isEmpty) {
//               return const Center(
//                 child: Text('No request received from branches.'),
//               );
//             }
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) => RequestCard(
//                 snap: snapshot.data!.docs[index].data(),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
