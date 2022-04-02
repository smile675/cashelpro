import 'package:cashier/utils/global_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Widgets/admin_drawer.dart';

class BranchList extends StatefulWidget {
  const BranchList({Key? key}) : super(key: key);

  @override
  _BranchListState createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  final companyKey = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Branches'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('branches')
            .where('companyKey', isEqualTo: companyKey)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Flexible(child: Text('There are no Branch to Show..')),
              ],
            );
          }

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(background), fit: BoxFit.cover),
            ),
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Stack(
                alignment: Alignment.topRight,
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.store_mall_directory_outlined,
                        size: 50.0,
                        color: Colors.teal,
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 30,
                        bottom: 5,
                        left: 5,
                        right: 5,
                      ),
                      title: Text(
                        'Branch Name: ${snapshot.data!.docs[index]['branchName']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(snapshot.data!.docs[index]['branchLocation'])
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(snapshot.data!.docs[index]['email'])
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.teal,
                    child: Text((index + 1).toString()),
                  ),
                ],
              ),
            ),
          );
          // return Container(
          //   padding: const EdgeInsets.all(20),
          //   child: GridView.builder(
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 15,
          //     ),
          //     itemCount: snapshot.data!.docs.length,
          //     itemBuilder: (context, index) => Card(
          //       child: Container(
          //         padding: const EdgeInsets.all(20),
          //         child: GridTile(
          //           header: TextButton.icon(
          //             icon: const Icon(Icons.location_pin),
          //             onPressed: null,
          //             label: Text(
          //               snapshot.data!.docs[index]['branchLocation'],
          //             ),
          //           ),
          //           child: Center(
          //             child: Text(
          //               snapshot.data!.docs[index]['branchName'],
          //               style: const TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20,
          //               ),
          //             ),
          //           ),
          //           footer: Column(
          //             children: [
          //               TextButton.icon(
          //                 icon: const Icon(Icons.email_outlined),
          //                 onPressed: null,
          //                 label: FittedBox(
          //                   child: Text(
          //                     snapshot.data!.docs[index]['email'],
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(height: 10),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: const [
          //                   Icon(Icons.phone),
          //                   Icon(Icons.whatsapp),
          //                 ],
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
