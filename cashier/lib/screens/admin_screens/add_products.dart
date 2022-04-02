import 'package:cashier/models/category.dart';
import 'package:cashier/resourses/firestore_methods.dart';
import 'package:cashier/screens/admin_screens/admin_main.dart';
import 'package:cashier/screens/admin_screens/category_list.dart';
import 'package:cashier/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Widgets/admin_drawer.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  bool _isLoading = false;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _subTitle = TextEditingController();
  final TextEditingController _price = TextEditingController();
  String _categoryName = '';
  String _categoryID = '';

  late List<Category> _category;

  bool _categoryLoaded = false;

  @override
  void initState() {
    super.initState();
    refreshCategory();
  }

  Future<void> refreshCategory() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('branches')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final _brachCompanyKey =
        (snap.data() as Map<String, dynamic>)['companyKey'];

    List<Category> _dataCategoryList =
        await FireStoreMethods().getCategoryList(_brachCompanyKey);
    setState(() {
      _category = _dataCategoryList;
      _categoryLoaded = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _subTitle.dispose();
    _price.dispose();
  }

  void goBackHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminHome()));
  }

  void goAddCategory() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CategoryList()));
  }

  void createProducts() async {
    setState(() {
      _isLoading = true;
    });
    String res = await FireStoreMethods().uploadProduct(
      title: _title.text,
      subTitle: _subTitle.text,
      price: double.parse(_price.text),
      categoryName: _categoryName,
      categoryID: _categoryID,
    );

    if (res == 'success') {
      goBackHome();
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  String? _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBackHome,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Add Products'),
      ),
      body: _categoryLoaded
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: _category.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: _category.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      _categoryID =
                                                          _category[index]
                                                              .categoryId;
                                                      _categoryName =
                                                          _category[index]
                                                              .categoryTitle;
                                                      _value = _category[index]
                                                          .categoryTitle;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  title: Text(
                                                    _category[index]
                                                        .categoryTitle,
                                                    textAlign: TextAlign.center,
                                                  ));
                                            })
                                        : const Center(
                                            child:
                                                Text('No Category Added yet!',
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                    )),
                                          ),
                                  );
                                },
                              );
                            },
                            icon: Icon(_value == null
                                ? Icons.inventory_2
                                : Icons.inventory_sharp),
                            label: Text(_value ?? 'Choose Category'),
                          ),
                          TextField(
                            controller: _title,
                            autocorrect: false,
                            decoration:
                                const InputDecoration(label: Text('Title')),
                          ),
                          TextField(
                            controller: _subTitle,
                            autocorrect: false,
                            decoration:
                                const InputDecoration(label: Text('Sub-Title')),
                          ),
                          TextField(
                            controller: _price,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            autocorrect: false,
                            decoration:
                                const InputDecoration(label: Text('Price')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    (_categoryName.isEmpty ||
                            _price.text.isEmpty ||
                            double.parse(_price.text) <= 0.00 ||
                            _title.text.isEmpty)
                        ? showSnackBar('Input All Information', context)
                        : createProducts();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),

                    alignment: Alignment.center,
                    // height: 30,
                    width: double.infinity,
                    color: Colors.teal,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '<Add Product\\>',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
