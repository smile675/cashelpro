import 'package:cashier/providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/company_model.dart';
import '../providers/company_provider.dart';

class CartShow extends StatelessWidget {
  final String id;
  final String productID;
  final double price;
  final int quantity;
  final String title;
  const CartShow({
    Key? key,
    required this.id,
    required this.productID,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Company _company = Provider.of<CompanyProvider>(context).getCompany;
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: const Text(
          'Delete?',
          style: TextStyle(color: Colors.white),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvide>(context, listen: false).removeItem(productID);
      },

      // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text('$quantity x'),
            ),
            Expanded(
              flex: 3,
              child: Text(title),
            ),
            Expanded(
              flex: 2,
              child: FittedBox(
                  child: Text(
                      '${_company.currencyCode} ${(price * quantity).toStringAsFixed(2)}')),
            ),
          ],
        ),
      ),
    );
  }
}
