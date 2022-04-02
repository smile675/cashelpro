import 'package:cashier/models/invoice_model.dart';
import 'package:cashier/resourses/local_database_methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceProvider with ChangeNotifier {
  String invDay = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String invMonth = DateFormat('MM-yyyy').format(DateTime.now());
  final _dbHelper = LocalDatabase.instance;
  List<Invoice>? _dailyInvoiceList;
  List<Invoice>? _monthInvoiceList;

  List<Invoice> get getDailyInvoices => _dailyInvoiceList!;
  List<Invoice> get getMonthInvoices => _monthInvoiceList!;

  Future<void> refreshDailyInvoices() async {
    List<Invoice> invoice = (await _dbHelper.fetchInvoices(invDay));
    _dailyInvoiceList = invoice;
    notifyListeners();
  }

  Future<void> refreshMonthlyInvoices() async {
    List<Invoice> invoice = (await _dbHelper.fetchMonthlyInvoices(invMonth));
    _monthInvoiceList = invoice;
    notifyListeners();
  }
}
