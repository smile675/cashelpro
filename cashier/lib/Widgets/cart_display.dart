// cartscreen > will go to different place later
import 'package:cashier/Widgets/cart_item.dart';

import 'package:cashier/providers/cart_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/company_model.dart';
import '../providers/company_provider.dart';
import '../resourses/local_database_methods.dart';
import 'order_confirmation_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Company _company = Provider.of<CompanyProvider>(context).getCompany;
    String _ref = const Uuid().v1();
    final _dbHelper = LocalDatabase.instance;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String invDay = DateFormat('dd-MM-yyyy').format(now);
    String invMonth = DateFormat('MM-yyyy').format(now);
    String _invPrefix = DateFormat('yyyyMMdd').format(now);
    final cart = Provider.of<CartProvide>(context);
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(253, 246, 227, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      child: Text(
                    'Invoice: $_invPrefix __',
                  )),
                  FittedBox(child: Text('Date: $formattedDate')),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, i) => CartShow(
                  id: cart.items.values.toList()[i].id,
                  productID: cart.items.keys.toList()[i],
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  title: cart.items.values.toList()[i].title,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              color: const Color.fromRGBO(253, 246, 227, 1),
              child: Column(
                children: [
                  const Divider(
                    color: Colors.black,
                    height: 5,
                  ),
                  FittedBox(
                      child: Text(
                          'Total: ${_company.currencyCode} ${(cart.totalAmount.toStringAsFixed(2))}')),
                  (cart.items.isEmpty)
                      ? const ElevatedButton(
                          onPressed: null, child: Text('Invoice Empty'))
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return OrderConfirmationDialog(
                                      cart: cart,
                                      company: _company,
                                      dbHelper: _dbHelper,
                                      invDay: invDay,
                                      invMonth: invMonth,
                                      invPrefix: _invPrefix,
                                      ref: _ref);
                                });
                          },
                          child: const Text('Order'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
