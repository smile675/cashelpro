import 'package:cashier/models/products_model.dart';
import 'package:cashier/resourses/firestore_methods.dart';
import 'package:cashier/resourses/firestore_update_delete_method.dart';
import 'package:cashier/screens/admin_screens/add_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/admin_drawer.dart';
import '../../models/company_model.dart';
import '../../providers/company_provider.dart';
import '../../utils/global_variable.dart';

class ProductListAdmin extends StatefulWidget {
  const ProductListAdmin({Key? key}) : super(key: key);

  @override
  _ProductListAdminState createState() => _ProductListAdminState();
}

class _ProductListAdminState extends State<ProductListAdmin> {
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newSubtitleController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();

  @override
  void initState() {
    refreshProducts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _newTitleController.dispose();
    _newSubtitleController.dispose();
    _newPriceController.dispose();
  }

  void goAddProductScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AddProducts()));
  }

  //final companyKey = FirebaseAuth.instance.currentUser!.uid;

  bool _productLoaded = false;
  late List<Products> _products;
  late int _branchStatus;

  Future<void> refreshProducts() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('branches')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final _branchCompanyKey =
        (snap.data() as Map<String, dynamic>)['companyKey'];
    int _gotBranchStatus =
        (snap.data() as Map<String, dynamic>)['activity_status'];

    List<Products> _dataProductList =
        await FireStoreMethods().getProductList(_branchCompanyKey);
    setState(() {
      _products = _dataProductList;
      _productLoaded = true;
      _branchStatus = _gotBranchStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Company _company = Provider.of<CompanyProvider>(context).getCompany;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: refreshProducts,
        child: const Icon(Icons.refresh),
      ),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
        actions: [
          _productLoaded
              ? IconButton(
                  onPressed: _branchStatus == 0 ? null : goAddProductScreen,
                  icon: const Icon(Icons.add))
              : const Text('')
        ],
      ),
      body: _productLoaded
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover),
              ),
              padding: const EdgeInsets.all(20),
              child: _branchStatus == 0
                  ? ListView.builder(
                      itemCount: demoProducts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white.withOpacity(0.8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 15,
                              child: Text((index + 1).toString()),
                            ),
                            title: Text(demoProducts[index]['Title']),
                            subtitle: Text(
                                'Category: ${demoProducts[index]['category']}'),
                            trailing: Text(
                                '${_company.currencyCode} ${(demoProducts[index]['Price']).toStringAsFixed(2)}'),
                          ),
                        );
                      })
                  : _products.isNotEmpty
                      ? ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            String _productTitle = _products[index].title;
                            String _productSubTitle = _products[index].subTitle;
                            String _productCategory =
                                _products[index].categoryName;
                            String _productPrice =
                                '${_company.currencyCode} ${(_products[index].price).toStringAsFixed(2)}';
                            String _productId = _products[index].id;
                            String _productCategoryID =
                                _products[index].categoryID;

                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 15,
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black,
                                        child: Text(
                                          (index + 1).toString(),
                                        ),
                                      ),
                                      title: Text(
                                        _productTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      trailing: Text(_productPrice),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_productSubTitle),
                                          Text('Category: $_productCategory'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              title: Text(_productTitle),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(_productSubTitle),
                                                  Text(
                                                      'Category: $_productCategory'),
                                                  Text('Price: $_productPrice')
                                                ],
                                              ),
                                              actions: [
                                                ElevatedButton.icon(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .red)),
                                                    onPressed: () {
                                                      FireStoreUpdateDeleteMethods()
                                                          .deleteProduct(
                                                              _productId,
                                                              _productCategoryID);

                                                      Navigator.pop(context);
                                                      refreshProducts();
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    label:
                                                        const Text('Delete')),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      updateProductBottomSheet(
                                                          context,
                                                          _productTitle,
                                                          _productId,
                                                          _productSubTitle,
                                                          _productPrice);
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    label: const Text('Edit')),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon:
                                                        const Icon(Icons.close))
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.more_horiz))
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'Note Products Added Yet!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
            )
          : Center(
              child: ElevatedButton.icon(
                  onPressed: refreshProducts,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Products')),
            ),
    );
  }

  Future<dynamic> updateProductBottomSheet(
      BuildContext context,
      String _productTitle,
      String _productId,
      String _productSubTitle,
      String _productPrice) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Update Product Detail',
                      style: TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newTitleController,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: _productTitle,
                            label: const Text('New Title'),
                          ),
                        ),
                      ),
                      (_newTitleController.text.isNotEmpty)
                          ? IconButton(
                              onPressed: () {
                                if (_newTitleController.text.isNotEmpty) {
                                  FireStoreUpdateDeleteMethods()
                                      .updateProductTitle(
                                          _productId, _newTitleController.text);
                                  _newTitleController.clear();
                                } else {
                                  // do nothing
                                }
                              },
                              icon: const Icon(
                                Icons.update,
                                color: Colors.teal,
                              ),
                            )
                          : const Icon(
                              Icons.pending,
                              color: Colors.black,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newSubtitleController,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: _productSubTitle,
                            label: const Text('New Sub Title'),
                          ),
                        ),
                      ),
                      (_newSubtitleController.text.isNotEmpty)
                          ? IconButton(
                              onPressed: () {
                                if (_newSubtitleController.text.isNotEmpty) {
                                  FireStoreUpdateDeleteMethods()
                                      .updateProductSubTitle(_productId,
                                          _newSubtitleController.text);
                                  _newSubtitleController.clear();
                                } else {
                                  // do nothing
                                }
                              },
                              icon: const Icon(
                                Icons.update,
                                color: Colors.teal,
                              ),
                            )
                          : const Icon(
                              Icons.pending,
                              color: Colors.black,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          controller: _newPriceController,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: _productPrice,
                            label: const Text('New Price'),
                          ),
                        ),
                      ),
                      (_newPriceController.text.isNotEmpty)
                          ? IconButton(
                              onPressed: () {
                                if (_newPriceController.text.isNotEmpty) {
                                  FireStoreUpdateDeleteMethods()
                                      .updateProductPrice(
                                          _productId,
                                          double.parse(
                                              _newPriceController.text));
                                  _newPriceController.clear();
                                } else {
                                  // do nothing
                                }
                              },
                              icon: const Icon(
                                Icons.update,
                                color: Colors.teal,
                              ),
                            )
                          : const Icon(
                              Icons.pending,
                              color: Colors.black,
                            ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}
