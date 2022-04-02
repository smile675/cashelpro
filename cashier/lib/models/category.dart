import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String categoryId;
  final String categoryTitle;
  final String companyKey;
  final int itemCount;

  Category({
    required this.categoryId,
    required this.categoryTitle,
    required this.companyKey,
    required this.itemCount,
  });

  static Category fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Category(
        itemCount: snapshot['itemCount'],
        categoryId: snapshot['categoryId'],
        categoryTitle: snapshot['categoryTitle'],
        companyKey: snapshot['companyKey']);
  }

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'categoryTitle': categoryTitle,
        'companyKey': companyKey,
        'itemCount': itemCount,
      };
}
