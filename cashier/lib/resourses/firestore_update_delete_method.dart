import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreUpdateDeleteMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final companyKey = FirebaseAuth.instance.currentUser!.uid;

  // Future<void> deleteReqStock(String id) async {
  //   try {
  //     await _firestore.collection('stockRequirement').doc(id).delete();
  //   } catch (err) {
  //     // nothing important

  //   }
  // }

// delte a product using product Id----->
  Future<void> deleteProduct(String id, String categoryID) async {
    try {
      await _firestore
          .collection('company')
          .doc(companyKey)
          .collection('products')
          .doc(id)
          .delete();
      // await _firestore.collection('products').doc(id).delete();
      _firestore
          .collection('company')
          .doc(companyKey)
          .collection('categories')
          .doc(categoryID)
          .update({'itemCount': FieldValue.increment(-1)});
    } catch (e) {
      // nothing to do for now
    }
  }

  // delete a category using category Id ----->
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore
          .collection('company')
          .doc(companyKey)
          .collection('categories')
          .doc(id)
          .delete();
    } catch (e) {
      // nothing to do for now
    }
  }

  // update a product using product Id ----->
  // Can update: title, subtitle, price.
  // Cannot update: categoryID, categoryName, companyKey, id

  Future<void> updateProductTitle(
    String id,
    String newTitle,
  ) async {
    try {
      await _firestore
          .collection('company')
          .doc(companyKey)
          .collection('products')
          .doc(id)
          .update({
        'title': newTitle,
      });
    } catch (e) {
      // noting to do for now
    }
  }

  Future<void> updateProductSubTitle(
    String id,
    String newSubtitle,
  ) async {
    try {
      await _firestore
          .collection('company')
          .doc(companyKey)
          .collection('products')
          .doc(id)
          .update({
        'subtitle': newSubtitle,
      });
    } catch (e) {
      // noting to do for now
    }
  }

  Future<void> updateProductPrice(
    String id,
    double newPrice,
  ) async {
    try {
      await _firestore
          .collection('company')
          .doc(companyKey)
          .collection('products')
          .doc(id)
          .update({
        'price': newPrice,
      });
    } catch (e) {
      // noting to do for now
    }
  }

  // updating company profile ------->

  // Update Company name:
  Future<void> updateCompanyName(String id, String newName) async {
    try {
      await _firestore
          .collection('company')
          .doc(id)
          .update({'companyName': newName});
    } catch (e) {
      // do nothing
    }
  }

  // Update Company phone
  Future<void> updateCompanyPhone(String id, String newPhone) async {
    try {
      await _firestore
          .collection('company')
          .doc(id)
          .update({'phoneNumber': newPhone});
    } catch (e) {
      // do nothing
    }
  }

  // update currency code:

  Future<void> updateCompanyCurrencyCode(String id, String newCurrency) async {
    try {
      await _firestore
          .collection('company')
          .doc(id)
          .update({'currencyCode': newCurrency});
    } catch (e) {
      // do nothing
    }
  }

  // update hqCity:

  Future<void> updateCompanyHQcity(String id, String newhqCity) async {
    try {
      await _firestore
          .collection('company')
          .doc(id)
          .update({'hqLocation': newhqCity});
    } catch (e) {
      // do nothing
    }
  }

  // update full address:

  Future<void> updateCompanyFullAddress(
      String id, String newfullAddress) async {
    try {
      await _firestore
          .collection('company')
          .doc(id)
          .update({'fullAddress': newfullAddress});
    } catch (e) {
      // do nothing
    }
  }
}
