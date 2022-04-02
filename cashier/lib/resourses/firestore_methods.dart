import 'package:cashier/models/category.dart';
import 'package:cashier/models/invoice_model.dart';
import 'package:cashier/models/need_stock.dart';
import 'package:cashier/models/products_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final companyKey = FirebaseAuth.instance.currentUser!.uid;

  Future<String> uploadProduct({
    required String title,
    required String subTitle,
    required double price,
    required String categoryName,
    required String categoryID,
  }) async {
    String res = 'Some Error Occurred';
    try {
      String productID = const Uuid().v1();
      Products product = Products(
        id: productID,
        title: title,
        subTitle: subTitle,
        price: price,
        categoryName: categoryName,
        companyKey: companyKey,
        categoryID: categoryID,
      );

      _firestore.collection('products').doc(productID).set(product.toJson());

      _firestore
          .collection('category')
          .doc(categoryID)
          .update({'itemCount': FieldValue.increment(1)});

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadCategory(String categoryTitle) async {
    String res = 'Some error occured';
    try {
      String categoryId = const Uuid().v1();
      Category category = Category(
        categoryId: categoryId,
        categoryTitle: categoryTitle,
        companyKey: companyKey,
        itemCount: 0,
      );
      _firestore.collection('category').doc(categoryId).set(category.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<Category>> getCategoryList(String companyKey) async {
    final _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> _categoryList = await _firestore
        .collection('category')
        .where('companyKey', isEqualTo: companyKey)
        .get();

    return _categoryList.docs.isNotEmpty
        ? _categoryList.docs.map((e) => Category.fromSnap(e)).toList()
        : [];
  }

  Future<List<Products>> getProductList(String companyKey) async {
    final _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> _productList = await _firestore
        .collection('products')
        .where('companyKey', isEqualTo: companyKey)
        .get();

    return _productList.docs.isNotEmpty
        ? _productList.docs.map((e) => Products.fromSnap(e)).toList()
        : [];
  }

  // in branch home page, I need to show product according to choosen category.

  Future<List<Products>> getProductListAsCategory(
      String companyKey, String categoryId) async {
    final _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> _productList = await _firestore
        .collection('products')
        .where('companyKey', isEqualTo: companyKey)
        .where('categoryID', isEqualTo: categoryId)
        .get();

    return _productList.docs.isNotEmpty
        ? _productList.docs.map((e) => Products.fromSnap(e)).toList()
        : [];
  }
}
