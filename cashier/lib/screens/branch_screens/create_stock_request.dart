// import 'package:cashier/resourses/firestore_methods.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../utils/utils.dart';

// class CreateStockRequest extends StatefulWidget {
//   const CreateStockRequest({Key? key}) : super(key: key);

//   @override
//   State<CreateStockRequest> createState() => _CreateStockRequestState();
// }

// class _CreateStockRequestState extends State<CreateStockRequest> {
//   late final TextEditingController _stockName;
//   late final TextEditingController _quantity;
//   late final TextEditingController _reqMessage;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     _stockName = TextEditingController();
//     _quantity = TextEditingController();
//     _reqMessage = TextEditingController();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _stockName.dispose();
//     _quantity.dispose();
//     _reqMessage.dispose();

//     super.dispose();
//   }

//   void stockReq() async {
//     setState(() {
//       _isLoading = true;
//     });
//     DocumentSnapshot snap = await FirebaseFirestore.instance
//         .collection('branches')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     final _currentBranch = (snap.data() as Map<String, dynamic>)['branchName'];
//     final _companyKey = (snap.data() as Map<String, dynamic>)['companyKey'];

//     String res = await FireStoreMethods().createStockReq(
//       stockName: _stockName.text,
//       quantity: _quantity.text,
//       reqmessage: _reqMessage.text,
//       branchName: _currentBranch,
//       branchCompanyKey: _companyKey,
//     );

//     if (res == 'success') {
//       Navigator.of(context).pop();
//     } else {
//       showSnackBar(res, context);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stock Request Form'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 80),
//           child: Column(
//             children: [
//               TextField(
//                 autocorrect: false,
//                 keyboardType: TextInputType.emailAddress,
//                 controller: _stockName,
//                 decoration: const InputDecoration(
//                   label: Text('What Do you Need? '),
//                 ),
//               ),
//               TextField(
//                 controller: _quantity,
//                 autocorrect: false,
//                 decoration: const InputDecoration(label: Text('Quantity.....')),
//               ),
//               TextField(
//                 maxLines: 2,
//                 controller: _reqMessage,
//                 decoration: const InputDecoration(
//                   label: Text('Request Note(Optional)...'),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   (_stockName.text.isEmpty || _quantity.text.isEmpty)
//                       ? null
//                       : stockReq();
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 10),

//                   alignment: Alignment.center,
//                   // height: 30,
//                   width: double.infinity,
//                   color: Colors.blue,
//                   child: _isLoading
//                       ? const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Text('Submit Request'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
