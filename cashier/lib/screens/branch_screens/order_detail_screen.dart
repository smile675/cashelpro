import 'package:cashier/models/branch_model.dart';
import 'package:cashier/models/order_items_model.dart';
import 'package:cashier/providers/branch_provider.dart';
import 'package:cashier/resourses/local_database_methods.dart';
//import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../Saving_Printing_Methods/thermalprint/printing_page_create.dart';
import '../../models/company_model.dart';
import '../../models/invoice_model.dart';
import '../../providers/company_provider.dart';
//import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'package:drago_pos_printer/drago_pos_printer.dart';

class OrderDetails extends StatefulWidget {
  final String refKey;

  const OrderDetails({
    Key? key,
    required this.refKey,
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  // PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  late List<Invoice> _invoice;
  late List<OrderItems> _orderItems;
  bool loading = false;

  // PaperSize _myPaperSize = PaperSize.mm58;
  // PrinterBluetooth? _myPrinter;

  // List<PrinterBluetooth> _printers = [];
  bool _printerCalled = false;

  List<BluetoothPrinter> _printers = [];
  int paperWidth = PaperSizeWidth.mm58;
  int charPerLine = PaperSizeMaxPerLine.mm58;
  BluetoothPrinterManager? _manager;

  @override
  void initState() {
    refreshOnceInvoice();
    super.initState();
  }

  Future<void> refreshOnceInvoice() async {
    final _dbHelper = LocalDatabase.instance;
    List<Invoice> invoice = (await _dbHelper.fetchRefInvoices(widget.refKey));
    List<OrderItems> items = (await _dbHelper.fetchOrderItems(widget.refKey));

    setState(() {
      _invoice = invoice;
      _orderItems = items;
      loading = true;
    });
  }

  void _scan() async {
    setState(() {
      _printers = [];
    });

    var printers = await BluetoothPrinterManager.discover();

    setState(() {
      _printers = printers;
      _printerCalled = true;
    });
  }

  Future _connect(BluetoothPrinter printer) async {
    var profile = await CapabilityProfile.load();
    var manager =
        BluetoothPrinterManager(printer, paperWidth, charPerLine, profile);
    print('--------------connected----------------');

    setState(() {
      _manager = manager;
      printer.connected = true;
    });
  }

  void _startPrint(BluetoothPrinter printer) async {
    print(printer.address);
    await _connect(printer);
    late List<int> data;
    Branch _branch =
        Provider.of<BranchProvider>(context, listen: false).getBranch;
    Company _company =
        Provider.of<CompanyProvider>(context, listen: false).getCompany;
    data = await PrintInvoice().getInvoicePosBuyte(
        paperSize: _manager!.paperSizeWidthMM,
        maxperLine: _manager!.maxPerLine,
        profile: _manager!.profile,
        companyName: _company.companyName,
        companyEmail: _company.companyEmail,
        branchName: _branch.branchName,
        branchEmail: _branch.email,
        invPrefix: _invoice[0].invPrefix,
        invID: _invoice[0].id as int,
        invDate: _invoice[0].invDay,
        invAmount: _invoice[0].amount,
        currencyCode: _company.currencyCode,
        orderItems: _orderItems,
        fullAddress: _company.fullAddress,
        paymentTerm: _invoice[0].paymentTerm,
        paidAmount: _invoice[0].paidAmount,
        changeAmount: _invoice[0].changeAmount,
        cardRef: _invoice[0].cardReference,
        paymentRef: _invoice[0].paymentReference);

    if (_manager != null) {
      if (!await _manager!.checkConnected()) await _manager!.connect();
      print("isConnected ${_manager!.isConnected}");
      _manager!.writeBytes(data, isDisconnect: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Branch _branch = Provider.of<BranchProvider>(context).getBranch;
    Company _company = Provider.of<CompanyProvider>(context).getCompany;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          _printerCalled
              ? TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _printerCalled = false;
                    });
                  },
                  icon: const Icon(
                    Icons.print_disabled,
                    color: Color.fromARGB(255, 131, 40, 4),
                  ),
                  label: const Text(
                    'Cancel Print',
                    style: TextStyle(color: Color.fromARGB(255, 131, 40, 4)),
                  ),
                )
              : TextButton.icon(
                  onPressed: () {
                    _scan();
                  },
                  icon: const Icon(
                    Icons.print_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Print Order',
                    style: TextStyle(color: Colors.white),
                  ))
        ],
      ),
      body: loading
          ? Row(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                    _company.companyName,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _company.companyEmail,
                                  ),
                                  Text(
                                    _company.fullAddress,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Invoice Number: ${_invoice[0].invPrefix} ${_invoice[0].id}',
                                ),
                                Text('Invoice Date: ${_invoice[0].invDay}'),
                                Text('Payment Term: ${_invoice[0].paymentTerm}')
                              ],
                            ),
                            const Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Text('No'),
                                ),
                                Expanded(flex: 10, child: Text('Item & Qty')),
                                Expanded(
                                  flex: 3,
                                  child: Text('Price'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('Amount'),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _orderItems.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text((index + 1).toString())),
                                    Expanded(
                                        flex: 10,
                                        child: Text(
                                            '${_orderItems[index].itemName} X ${_orderItems[index].itemQty}')),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                            (_orderItems[index].itemPrice)
                                                .toStringAsFixed(2))),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                            (_orderItems[index].itemAmount)
                                                .toStringAsFixed(2))),
                                  ],
                                );
                              },
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 0.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('Total: '),
                                Text('${_company.currencyCode} '),
                                Text((_invoice[0].amount).toStringAsFixed(2)),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('Paid: '),
                                Text(
                                    '${_company.currencyCode} ${(_invoice[0].paidAmount).toStringAsFixed(2)}'),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('Change: '),
                                Text(
                                    '${_company.currencyCode} ${(_invoice[0].changeAmount).toStringAsFixed(2)}'),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 0.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Reference: '),
                                Text(
                                    '${_invoice[0].cardReference} ## ${_invoice[0].paymentReference}'),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '<Thank You\\>',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Branch Name: ${_branch.branchName}'),
                            Text('Branch Email: ${_branch.email}')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _printerCalled
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Paper Size?',
                                  style: TextStyle(color: Colors.black),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      paperWidth = PaperSizeWidth.mm58;
                                      charPerLine = PaperSizeMaxPerLine.mm58;
                                    });
                                  },
                                  child: Container(
                                    color: paperWidth == PaperSizeWidth.mm58
                                        ? Colors.teal
                                        : Colors.grey,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('mm58'),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      paperWidth = PaperSizeWidth.mm80;
                                      charPerLine = PaperSizeMaxPerLine.mm80;
                                    });
                                  },
                                  child: Container(
                                    color: paperWidth == PaperSizeWidth.mm80
                                        ? Colors.teal
                                        : Colors.grey,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('mm80'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: _printers.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: _printers.length,
                                      itemBuilder: (contex, index) {
                                        return InkWell(
                                          onTap: () {
                                            _startPrint(_printers[index]);
                                          },
                                          child: ListTile(
                                            title: Text(_printers[index].name!),
                                            subtitle:
                                                Text(_printers[index].address!),
                                            trailing: const Icon(
                                              Icons.print,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        );
                                      })
                                  : const Center(
                                      child: Text('No Printer'),
                                    ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
