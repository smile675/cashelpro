import 'package:cashier/utils/global_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/company_model.dart';
import '../models/products_model.dart';
import '../providers/cart_providers.dart';
import '../providers/company_provider.dart';
import '../resourses/firestore_methods.dart';
import 'branch_drawer.dart';

class SelectProduct extends StatefulWidget {
  const SelectProduct({Key? key}) : super(key: key);

  @override
  State<SelectProduct> createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  String? chosenCategory;
  bool _categoryLoaded = false;
  String? chosenCategoryName;
  bool _productsLoaded = false;

  late List<Category> _category;
  List<Products> _products = [];
  late String _gotCompanyKey;
  late int _branchStatus;

  String _subTitle = '';

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
    int _gotBranchStatus =
        (snap.data() as Map<String, dynamic>)['activity_status'];

    List<Category> _dataCategoryList =
        await FireStoreMethods().getCategoryList(_brachCompanyKey);

    setState(() {
      _gotCompanyKey = _brachCompanyKey;
      _category = _dataCategoryList;
      _branchStatus = _gotBranchStatus;
      _productsLoaded = true;

      _categoryLoaded = true;
    });
  }

  Future<void> refreshProductsAccordingtoCategory() async {
    List<Products> _dataProductList = await FireStoreMethods()
        .getProductListAsCategory(_gotCompanyKey, chosenCategory!);
    setState(() {
      _products = _dataProductList;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return const BranchDrawer();
              },
            );
          },
          child: const Icon(Icons.menu)),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            color: Colors.teal,
            child: _categoryLoaded
                ? Container(
                    padding: const EdgeInsets.all(5),
                    height: 60,
                    child: _branchStatus == 0
                        ? ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: democategory.length,
                            itemBuilder: (BuildContext context, int index) =>
                                InkWell(
                              onTap: () {
                                setState(() {
                                  chosenCategoryName =
                                      democategory[index]['categoryTitle'];
                                });
                              },
                              child: Card(
                                elevation: 1,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Colors.black.withOpacity(0.6),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Center(
                                    child: Text(
                                      democategory[index]['categoryTitle'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : _category.isNotEmpty
                            ? ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _category.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        InkWell(
                                  onTap: () {
                                    setState(() {
                                      chosenCategory =
                                          _category[index].categoryId;
                                      chosenCategoryName =
                                          _category[index].categoryTitle;
                                    });
                                    refreshProductsAccordingtoCategory();
                                  },
                                  child: Card(
                                    elevation: 1,
                                    shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.6),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Center(
                                        child: Text(
                                          _category[index].categoryTitle,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No Category To Show!',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No Category To Show',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton.icon(
                            onPressed: refreshCategory,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'))
                      ],
                    ),
                  ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                _productsLoaded
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.black87,
                        child: _branchStatus == 0
                            ? GridView.builder(
                                itemCount: demoProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 5,
                                ),
                                itemBuilder: (context, index) {
                                  String _demoId = demoProducts[index]['id'];
                                  double _demoPrice =
                                      demoProducts[index]['Price'];
                                  String _demoTitle =
                                      demoProducts[index]['Title'];

                                  Company _company =
                                      Provider.of<CompanyProvider>(context)
                                          .getCompany;
                                  final cart =
                                      Provider.of<CartProvide>(context);

                                  return InkWell(
                                    onTap: () {
                                      cart.addItem(
                                          _demoId, _demoPrice, _demoTitle);
                                    },
                                    child: GridTile(
                                      child: Card(
                                        elevation: 0.00,
                                        color: Colors.white.withOpacity(0.8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    _demoTitle,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                  child: Text(
                                                '${_company.currencyCode.toUpperCase()} ${(_demoPrice).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    color: Colors.teal,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : _products.isNotEmpty
                                ? GridView.builder(
                                    itemCount: _products.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      crossAxisCount: 5,
                                    ),
                                    itemBuilder: (context, index) {
                                      String _productTitle =
                                          _products[index].title;
                                      String _productSubTitle =
                                          _products[index].subTitle;
                                      String _productId = _products[index].id;
                                      double _productPrice =
                                          _products[index].price;

                                      Company _company =
                                          Provider.of<CompanyProvider>(context)
                                              .getCompany;
                                      final cart =
                                          Provider.of<CartProvide>(context);

                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _subTitle = _productSubTitle;
                                          });
                                          cart.addItem(_productId,
                                              _productPrice, _productTitle);
                                        },
                                        child: GridTile(
                                          child: Card(
                                            elevation: 0.00,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        _productTitle,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                      child: Text(
                                                    '${_company.currencyCode.toUpperCase()} ${(_productPrice).toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                        color: Colors.teal,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      'No Products in this Category!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _subTitle,
                        style: const TextStyle(color: Colors.teal),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        'Category: $chosenCategoryName',
                        style: const TextStyle(color: Colors.teal),
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          /* I separated product display widget. for that I had to pass a list of
          of products through the constructor. 
          problem, when i choose a category, compiler--->
          1. come back to category dispaly
          2. check which category is chosen
          3. according to the category create a list of products
          4. pass to product list to product display widget
          5. then display the grid accordint to the product list
          This was taking long time to load products. 
          threfore, I changed the coding and instead of creating another
          stateful widget for product display and brough it in the same stateful 
          widget with category display.  hopefully this will work fine. 
          */

          // Products loading very slow ----->
          // Expanded(
          //   flex: 2,
          //   child: (chosenCategory != null)
          //       ? ProductsGrid(
          //           //chosenCategory: chosenCategory,
          //           products: _products,
          //           categoryName: chosenCategoryName!,
          //         )
          //       : Container(
          //           color: Colors.black87,
          //           child: const Center(
          //             child: Text(
          //               'Choose a Category',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //           ),
          //         ),
          // ),
        ],
      ),
    );
  }
}
