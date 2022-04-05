// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ManageUsers extends StatelessWidget {
//   const ManageUsers({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Users'),
//       ),
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('branches').snapshots(),
//           builder: (context,
//               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.data!.docs.isEmpty) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Flexible(child: Text('There are no Branch to Show..')),
//                 ],
//               );
//             }

//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 return Text(snapshot.data!.docs[index]['email']);
//               },
//             );
//           }),
//     );
//   }
// }
