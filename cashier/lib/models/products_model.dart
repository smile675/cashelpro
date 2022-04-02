import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String id;

  final String title;
  final String subTitle;
  final double price;
  final String categoryName;
  final String companyKey;
  final String categoryID;

  Products({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.categoryName,
    required this.companyKey,
    required this.categoryID,
  });

  static Products fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Products(
      id: snapshot['id'],
      title: snapshot['title'],
      subTitle: snapshot['subtitle'],
      price: snapshot['price'],
      categoryName: snapshot['categoryName'],
      companyKey: snapshot['companyKey'],
      categoryID: snapshot['categoryID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subTitle,
        'price': price,
        'categoryName': categoryName,
        'companyKey': companyKey,
        'categoryID': categoryID,
      };
}
