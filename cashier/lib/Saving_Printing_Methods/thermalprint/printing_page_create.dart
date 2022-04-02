import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';

import '../../models/order_items_model.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrintInvoice {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  void print({
    required PrinterBluetooth printer,
    required String companyName,
    required String companyEmail,
    required String branchName,
    required String branchEmail,
    required String invPrefix,
    required int invID,
    required String invDate,
    required double invAmount,
    required String currencyCode,
    required List<OrderItems> orderItems,
    required String fullAddress,
    required String paymentTerm,
    required double paidAmount,
    required double changeAmount,
    required String cardRef,
    required String paymentRef,
    required PaperSize paperSize,
  }) async {
    printerManager.selectPrinter(printer);
    PaperSize paper = paperSize;
    final profile = await CapabilityProfile.load();

    await printerManager.printTicket((await receipt(
      paper: paper,
      profile: profile,
      branchEmail: branchEmail,
      branchName: branchName,
      currencyCode: currencyCode,
      invDate: invDate,
      companyEmail: companyEmail,
      companyName: companyName,
      invAmount: invAmount,
      invID: invID,
      invPrefix: invPrefix,
      orderItems: orderItems,
      fullAddress: fullAddress,
      paidAmount: paidAmount,
      changeAmount: changeAmount,
      paymentTerm: paymentTerm,
      cardRef: cardRef,
      paymentRef: paymentRef,
    )));
  }

  Future<List<int>> receipt({
    required PaperSize paper,
    required CapabilityProfile profile,
    required String companyName,
    required String companyEmail,
    required String branchName,
    required String branchEmail,
    required String invPrefix,
    required int invID,
    required String invDate,
    required double invAmount,
    required String currencyCode,
    required List<OrderItems> orderItems,
    required String fullAddress,
    required String paymentTerm,
    required double paidAmount,
    required double changeAmount,
    required String cardRef,
    required String paymentRef,
  }) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];

    bytes += ticket.text(companyName,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += ticket.text(companyEmail,
        styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.text(fullAddress,
        styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.hr();
    bytes += ticket.text('Inv Num: $invPrefix$invID',
        styles: const PosStyles(align: PosAlign.left));
    bytes += ticket.text('Date: $invDate',
        styles: const PosStyles(align: PosAlign.left));
    bytes += ticket.text('Term: $paymentTerm',
        styles: const PosStyles(align: PosAlign.left));

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(text: 'Item', width: 6),
      PosColumn(
          text: 'Price',
          width: 3,
          styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total',
          width: 3,
          styles: const PosStyles(align: PosAlign.right)),
    ]);

    for (var i = 0; i < orderItems.length; i++) {
      bytes += ticket.row([
        PosColumn(
          text: '${orderItems[i].itemQty} X ${orderItems[i].itemName}',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: orderItems[i].itemPrice.toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: orderItems[i].itemAmount.toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += ticket.hr();

    bytes += ticket.text('Total: $currencyCode${invAmount.toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.right));
    bytes += ticket.text('Paid: $currencyCode${paidAmount.toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.right));
    bytes += ticket.text(
        'Change: $currencyCode${changeAmount.toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.right));

    bytes += ticket.hr();

    bytes += ticket.text('Reference: # $cardRef\n ## $paymentRef',
        styles: const PosStyles(align: PosAlign.right));

    bytes += ticket.hr(ch: '=', linesAfter: 1);

    bytes += ticket.feed(1);
    bytes += ticket.text('<Thank you\\>',
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += ticket.text(branchName,
        styles: const PosStyles(align: PosAlign.center), linesAfter: 2);

    ticket.feed(2);
    ticket.cut();

    return bytes;
  }
}
