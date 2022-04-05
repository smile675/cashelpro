import 'package:cashier/resourses/firestore_update_delete_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Widgets/admin_drawer.dart';
import '../../models/category.dart';
import '../../resourses/firestore_methods.dart';
import '../../utils/global_variable.dart';
import '../../utils/utils.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final TextEditingController _categoryTitle = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    refreshCategory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _categoryTitle.dispose();
  }

  void createCategory() async {
    setState(() {
      _isLoading = true;
    });
    String res = await FireStoreMethods().uploadCategory(_categoryTitle.text);

    if (res == 'success') {
      Navigator.pop(context);
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _categoryLoaded = false;

  late List<Category> _category;
  late int _branchStatus;

  Future<void> refreshCategory() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('branches')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final _branchCompanyKey =
        (snap.data() as Map<String, dynamic>)['companyKey'];
    int _gotbranchStatus =
        (snap.data() as Map<String, dynamic>)['activity_status'];

    List<Category> _dataCategoryList =
        await FireStoreMethods().getCategoryList(_branchCompanyKey);
    setState(() {
      _category = _dataCategoryList;
      _branchStatus = _gotbranchStatus;
      _categoryLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories'),
        actions: [
          _categoryLoaded
              ? IconButton(
                  onPressed: () {
                    _branchStatus == 0
                        ? null
                        : showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: TextField(
                                            controller: _categoryTitle,
                                            autocorrect: false,
                                            decoration: const InputDecoration(
                                              label: Text('Category Title'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _categoryTitle.text.isEmpty
                                                ? null
                                                : createCategory();
                                            refreshCategory();
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            color: Colors.teal,
                                            padding: const EdgeInsets.all(15),
                                            child: _isLoading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : const Text(
                                                    '<Add Category\\>',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
              : const Text('')
        ],
      ),
      body: _categoryLoaded
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover),
              ),
              padding: const EdgeInsets.all(20),
              child: _branchStatus == 0
                  ? ListView.builder(
                      itemCount: democategory.length,
                      itemBuilder: (context, index) {
                        return Card(
                            color: Colors.white.withOpacity(0.8),
                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  radius: 15,
                                  child: Text((index + 1).toString()),
                                ),
                                subtitle: Text(
                                    'Product count: ${democategory[index]['itemCount']}'),
                                title: Text(
                                    democategory[index]['categoryTitle'])));
                      })
                  : _category.isNotEmpty
                      ? ListView.builder(
                          itemCount: _category.length,
                          itemBuilder: (context, index) {
                            String _categoryName =
                                _category[index].categoryTitle;
                            int _itemCount = _category[index].itemCount;
                            String _categoryID = _category[index].categoryId;
                            return Card(
                              color: Colors.white.withOpacity(0.8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  radius: 15,
                                  child: Text((index + 1).toString()),
                                ),
                                title: Text(_categoryName),
                                subtitle: Text('Product Count: $_itemCount'),
                                trailing: _itemCount > 0
                                    ? const Icon(Icons.lock)
                                    : IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  title: const Text(
                                                      'Confirmation of Action!'),
                                                  content: const Text(
                                                      'Are you sure about deleting this category??'),
                                                  actions: [
                                                    ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        FireStoreUpdateDeleteMethods()
                                                            .deleteCategory(
                                                                _categoryID);
                                                        Navigator.pop(context);
                                                        refreshCategory();
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      label: const Text('Yes'),
                                                    ),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(
                                                          Icons.cancel),
                                                      label: const Text('No'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No Category Added Yet!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
            )
          : Center(
              child: ElevatedButton.icon(
                  onPressed: refreshCategory,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Category')),
            ),
    );
  }
}

// StreamBuilder is great but I want to change it.
// Plan: I will get data from firestore and then save it in a List.
// then i will show in a list view builder.

// body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('category')
//             .where('companyKey', isEqualTo: companyKey)
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Flexible(child: Text('No Category Created Yet! ')),
//             );
//           }
//           return Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage(background), fit: BoxFit.cover),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 String _categoryID = snapshot.data!.docs[index]['categoryId'];
//                 return Card(
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       radius: 15,
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.black,
//                       child: Text(
//                         (index + 1).toString(),
//                       ),
//                     ),
//                     title: Text(
//                       snapshot.data!.docs[index]['categoryTitle'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     trailing: StreamBuilder(
//                       stream: FirebaseFirestore.instance
//                           .collection('products')
//                           .where('categoryID',
//                               isEqualTo: snapshot.data!.docs[index]
//                                   ['categoryId'])
//                           .where('companyKey', isEqualTo: companyKey)
//                           .snapshots(),
//                       builder: (context,
//                           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                               itemsnap) {
//                         if (itemsnap.connectionState ==
//                             ConnectionState.waiting) {
//                           return const CircularProgressIndicator();
//                         } else if (itemsnap.data!.docs.isEmpty) {
//                           return Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               const Text('Empty Category'),
//                               IconButton(
//                                   onPressed: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return AlertDialog(
//                                             actionsAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             title: const Text(
//                                                 'Confirmation of Action!'),
//                                             content: const Text(
//                                                 'Are you sure about deleting this category??'),
//                                             actions: [
//                                               ElevatedButton.icon(
//                                                 style: ButtonStyle(
//                                                   backgroundColor:
//                                                       MaterialStateProperty.all(
//                                                           Colors.red),
//                                                 ),
//                                                 onPressed: () {
//                                                   FireStoreUpdateDeleteMethods()
//                                                       .deleteCategory(
//                                                           _categoryID);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 icon: const Icon(Icons.delete),
//                                                 label: const Text('Yes'),
//                                               ),
//                                               ElevatedButton.icon(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 icon: const Icon(Icons.cancel),
//                                                 label: const Text('No'),
//                                               ),
//                                             ],
//                                           );
//                                         });
//                                   },
//                                   icon: const Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                   )),
//                             ],
//                           );
//                         } else {
//                           return Text(
//                               'Products: ${itemsnap.data!.docs.length}');
//                         }
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
