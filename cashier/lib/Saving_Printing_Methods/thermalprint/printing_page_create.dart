import 'package:drago_pos_printer/drago_pos_printer.dart';

import '../../models/order_items_model.dart';

class PrintInvoice {
  int? _paperSizeWidthMM;
  int? _maxPerLine;
  CapabilityProfile? _profile;
  Future<List<int>> getInvoicePosBuyte({
    required int paperSize,
    required int maxperLine,
    CapabilityProfile? profile,
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
    String name = 'default',
  }) async {
    List<int> bytes = [];
    _profile = profile ?? (await CapabilityProfile.load(name: name));
    _paperSizeWidthMM = paperSize;
    _maxPerLine = maxperLine;
    Generator ticket = Generator(_paperSizeWidthMM!, _maxPerLine!, _profile!);
    bytes += ticket.reset();

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
