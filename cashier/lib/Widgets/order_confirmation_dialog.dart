import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/branch_model.dart';
import '../models/company_model.dart';
import '../providers/branch_provider.dart';
import '../providers/cart_providers.dart';
import '../resourses/local_database_methods.dart';
import '../screens/branch_screens/order_detail_screen.dart';
import '../utils/utils.dart';

class OrderConfirmationDialog extends StatefulWidget {
  const OrderConfirmationDialog({
    Key? key,
    required this.cart,
    required Company company,
    required LocalDatabase dbHelper,
    required this.invDay,
    required this.invMonth,
    required String invPrefix,
    required String ref,
  })  : _company = company,
        _dbHelper = dbHelper,
        _invPrefix = invPrefix,
        _ref = ref,
        super(key: key);

  final CartProvide cart;
  final Company _company;
  final LocalDatabase _dbHelper;
  final String invDay;
  final String invMonth;
  final String _invPrefix;
  final String _ref;

  @override
  State<OrderConfirmationDialog> createState() =>
      _OrderConfirmationDialogState();
}

class _OrderConfirmationDialogState extends State<OrderConfirmationDialog> {
  final TextEditingController _amountInput = TextEditingController();
  final TextEditingController _paymentReference = TextEditingController();
  final TextEditingController _cardReference = TextEditingController();
  final TextEditingController _otherPaymentTypeName = TextEditingController();

  bool _isCash = false;
  bool _isCard = false;
  bool _other = false;
  bool _readyToSubmit = false;
  double _paidAmount = 0.00;
  double _changeAmount = 0.00;
  String _paymentTerm = 'Not required';
  String _paymentreference = 'Not required';
  String _cardreference = 'Not required';

  @override
  void dispose() {
    _amountInput.dispose();
    _paymentReference.dispose();
    _cardReference.dispose();
    _otherPaymentTypeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      actionsAlignment: MainAxisAlignment.spaceAround,
      // title: const Text('Payment'),
      scrollable: true,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Term?'),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCash = true;
                            _isCard = false;
                            _other = false;
                            _paymentTerm = 'Cash';
                            _readyToSubmit = false;
                            _paidAmount = 0.00;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          color: _isCash ? Colors.teal : Colors.grey,
                          child: const Text(
                            'Cash',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCash = false;
                            _isCard = true;
                            _other = false;
                            _paymentTerm = 'Card';
                            _readyToSubmit = false;
                            _paidAmount = 0.00;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          color: _isCard ? Colors.teal : Colors.grey,
                          child: const Text(
                            'Card',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCash = false;
                            _isCard = false;
                            _other = true;
                            _paymentTerm = 'Other';
                            _readyToSubmit = false;
                            _paidAmount = 0.00;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          color: _other ? Colors.teal : Colors.grey,
                          child: const Text(
                            'Other',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.teal,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Total: ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  '${widget._company.currencyCode} ${widget.cart.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.teal,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Paid : ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  _paidAmount == 0.00
                                      ? '<paid\\> '
                                      : '${widget._company.currencyCode} ${_paidAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.teal,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'change: ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  '${widget._company.currencyCode} ${(_changeAmount).toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      //  Color(0xFF3366FF),
                      //  Color(0xFF00CCFF),
                      Colors.teal,
                      Colors.deepPurple,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                // color: Colors.black87,
                child: paymentMethod(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        _readyToSubmit
            ? IconButton(
                onPressed: () async {
                  Branch _branch =
                      Provider.of<BranchProvider>(context, listen: false)
                          .getBranch;

                  String res = await widget._dbHelper.insertInvoice(
                    amount: widget.cart.totalAmount,
                    invDay: widget.invDay,
                    invMonth: widget.invMonth,
                    branchName: _branch.branchName,
                    invPrefix: widget._invPrefix,
                    ref: widget._ref,
                    paymentTerm: _paymentTerm,
                    cardRef: _cardreference,
                    paymentRef: _paymentreference,
                    paidAmount: _paidAmount,
                    changeAmount: _changeAmount,
                  );

                  if (res == 'success') {
                    //Add items into oreder items table

                    for (var i = 0; i < widget.cart.items.length; i++) {
                      String res = await widget._dbHelper.insertOrderItems(
                          itemName: widget.cart.items.values.toList()[i].title,
                          itemQty:
                              widget.cart.items.values.toList()[i].quantity,
                          itemPrice: widget.cart.items.values.toList()[i].price,
                          itemAmount:
                              widget.cart.items.values.toList()[i].quantity *
                                  widget.cart.items.values.toList()[i].price,
                          ref: widget._ref);
                      if (res == 'success') {
                        // do nothing for now
                      } else {
                        showSnackBar(res, context);
                      }
                    }

                    //added items into order items table

                    widget.cart.clearCart();
                  } else {
                    showSnackBar(res, context);
                  }

                  // printing page
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => OrderDetails(refKey: widget._ref)));
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.teal,
                ),
              )
            : const Icon(
                Icons.square_outlined,
                color: Colors.red,
              ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ))
      ],
    );
  }

  Widget paymentMethod() {
    if (_isCash == true) {
      return cashPayment();
    } else if (_isCard == true) {
      return cardPayment();
    } else if (_other == true) {
      return otherPayment();
    } else {
      return const Center(
          child: Text(
        'Choose a Payment Method',
        style: TextStyle(color: Colors.white),
      ));
    }
  }

  Widget otherPayment() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            onSubmitted: (value) {
              setState(() {
                _cardreference = _otherPaymentTypeName.text;
              });
            },
            controller: _otherPaymentTypeName,
            autocorrect: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white54,
                labelStyle: const TextStyle(color: Colors.white),
                label: const Text('Payment Type')),
          ),
          TextField(
            onSubmitted: ((value) {
              _paidAmount = widget.cart.totalAmount;
              setState(() {
                _paymentreference = _paymentReference.text;
                _changeAmount = 0.00;
                _readyToSubmit = true;
              });
            }),
            controller: _paymentReference,
            autocorrect: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white54,
                labelStyle: const TextStyle(color: Colors.white),
                label: const Text('Payment Reference')),
          ),
        ],
      );

  Widget cardPayment() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            onSubmitted: (value) {
              setState(() {
                _cardreference = _cardReference.text;
              });
            },
            controller: _cardReference,
            autocorrect: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white54,
                labelStyle: const TextStyle(color: Colors.white),
                label: const Text('Card Number <Last 4 Digit>')),
          ),
          TextField(
            onSubmitted: ((value) {
              _paidAmount = widget.cart.totalAmount;
              setState(() {
                _paymentreference = _paymentReference.text;
                _changeAmount = 0.00;
                _readyToSubmit = true;
              });
            }),
            controller: _paymentReference,
            autocorrect: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white54,
                labelStyle: const TextStyle(color: Colors.white),
                label: const Text('Payment Reference')),
          ),
        ],
      );

  Widget cashPayment() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    amountBox(10.00),
                    amountBox(20.00),
                    amountBox(50.00),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    amountBox(100.00),
                    amountBox(500.00),
                    amountBox(1000.00),
                  ],
                ),
              ],
            ),
          ),
          TextField(
            onSubmitted: ((value) {
              _paidAmount = double.parse(value);
              setState(() {
                _changeAmount = _paidAmount - widget.cart.totalAmount;
                if (_changeAmount >= 0) {
                  _readyToSubmit = true;
                }
              });
            }),
            controller: _amountInput,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autocorrect: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white54,
                labelStyle: const TextStyle(color: Colors.white),
                label: Row(
                  children: const [
                    Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Other Amount'),
                  ],
                )),
          ),
        ],
      );

  InkWell amountBox(double _inputAmount) {
    return InkWell(
      onTap: () {
        setState(() {
          _paidAmount = _inputAmount;
          _changeAmount = _paidAmount - widget.cart.totalAmount;
          if (_changeAmount >= 0) {
            _readyToSubmit = true;
          }
        });
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Center(child: Text(_inputAmount.toStringAsFixed(2))),
      ),
    );
  }
}
