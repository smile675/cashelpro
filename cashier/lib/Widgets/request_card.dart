// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../resourses/firestore_update_delete_method.dart';

// class RequestCard extends StatefulWidget {
//   final snap;
//   const RequestCard({Key? key, required this.snap}) : super(key: key);

//   @override
//   State<RequestCard> createState() => _RequestCardState();
// }

// class _RequestCardState extends State<RequestCard> {
//   @override
//   Widget build(BuildContext context) {
//     DateTime reqDate = widget.snap['date'].toDate();
//     final displayDate = DateFormat('dd-MM-yyyy').format(reqDate);
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               leading: Card(
//                 child: Container(
//                     width: 60,
//                     color: Colors.black,
//                     child: Center(
//                       child: Text(
//                         widget.snap['stockName'],
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     )),
//               ),
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Quantity: ${widget.snap['quantity']}'),
//                   Text('Branch: ${widget.snap['branchName']}'),
//                   Text('Requested Date: $displayDate'),
//                 ],
//               ),
//               trailing: IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) => AlertDialog(
//                         titleTextStyle: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                         title: const Text('Supply Confirmation'),
//                         contentTextStyle: const TextStyle(
//                           color: Colors.black,
//                         ),
//                         content: const Text(
//                           'If Completed tap "YES", Otherwise tap "NO". ',
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () async {
//                               FireStoreUpdateDeleteMethods()
//                                   .deleteReqStock(widget.snap['id']);
//                               Navigator.pop(context);
//                             },
//                             child: const Text('YES'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text('NO'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.done_rounded)),
//             ),
//             Text('Message: ${widget.snap['reqmessage']}')
//           ],
//         ),
//       ),
//     );
//   }
// }
