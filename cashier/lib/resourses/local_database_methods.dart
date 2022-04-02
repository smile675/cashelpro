import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/invoice_model.dart';
import '../models/order_items_model.dart';

class LocalDatabase {
  static const _databaseName = 'InvoiceData.db';
  static const _databaseVersion = 1;

  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _createDatabase);
  }

  _createDatabase(Database db, int version) async {
    await db.execute(''' 

    CREATE TABLE ${Invoice.invTableName}(


      ${Invoice.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Invoice.colAmount} DOUBLE NOT NULL,
      ${Invoice.colBranchName} TEXT NOT NULL,
      ${Invoice.colInvPrefix} TEXT NOT NULL,
      ${Invoice.colinvDay} TEXT NOT NULL,
      ${Invoice.colinvMonth} TEXT NOT NULL,
      ${Invoice.colinvRef} TEXT NOT NULL,
      ${Invoice.colPaymentTerm} TEXT NOT NULL,
      ${Invoice.colCardReference} TEXT NOT NULL,
      ${Invoice.colPaymentReference} TEXT NOT NULL,
      ${Invoice.colPaidAmount} DOUBLE NOT NULL,
      ${Invoice.colChange} DOUBLE NOT NULL
         


    )
   
    ''');

    await db.execute(''' 

   
    CREATE TABLE ${OrderItems.orderItemsTableName}(


      ${OrderItems.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${OrderItems.colItemName} TEXT NOT NULL,
      ${OrderItems.colItemQty} INTEGER NOT NULL,
      ${OrderItems.colItemPrice} DOUBLE NOT NULL,
      ${OrderItems.colItemAmount} DOUBLE NOT NULL,
      ${OrderItems.colItemRef} TEXT NOT NULL
         


    )

    ''');
  }

  //insertInvoise

  Future<String> insertInvoice({
    required double amount,
    required String branchName,
    required String invPrefix,
    required String invDay,
    required String invMonth,
    required String ref,
    required String paymentTerm,
    required String cardRef,
    required String paymentRef,
    required double paidAmount,
    required double changeAmount,
  }) async {
    final db = await database;
    String res = 'Some error occured';
    try {
      Invoice invoice = Invoice(
        amount: amount,
        invRef: ref,
        branchName: branchName,
        invPrefix: invPrefix,
        invDay: invDay,
        invMonth: invMonth,
        paymentTerm: paymentTerm,
        cardReference: cardRef,
        paymentReference: paymentRef,
        paidAmount: paidAmount,
        changeAmount: changeAmount,
      );
      db!.insert(Invoice.invTableName, invoice.toMap());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // insert items into order items table.....
  Future<String> insertOrderItems({
    required String itemName,
    required int itemQty,
    required double itemPrice,
    required double itemAmount,
    required String ref,
  }) async {
    final db = await database;
    String res = 'Some error occured';
    try {
      OrderItems orderItems = OrderItems(
          itemRef: ref,
          itemName: itemName,
          itemQty: itemQty,
          itemPrice: itemPrice,
          itemAmount: itemAmount);

      db!.insert(OrderItems.orderItemsTableName, orderItems.toMap());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //receive Daily Invoice
  Future<List<Invoice>> fetchInvoices(String queryDurationDay) async {
    final db = await database;

    List<Map<String, Object?>> invoices = await db!.query(Invoice.invTableName,
        where: '${Invoice.colinvDay} = ?', whereArgs: [queryDurationDay]);
    return invoices.isNotEmpty
        ? invoices.map((e) => Invoice.fromMap(e)).toList()
        : [];
  }

  //receive Daily Invoice
  Future<List<Invoice>> fetchMonthlyInvoices(String queryDurationDay) async {
    final db = await database;
    List<Map<String, Object?>> invoices = await db!.query(Invoice.invTableName,
        where: '${Invoice.colinvMonth} = ?', whereArgs: [queryDurationDay]);
    return invoices.isNotEmpty
        ? invoices.map((e) => Invoice.fromMap(e)).toList()
        : [];
  }

  // receive invoice by refCode

  Future<List<Invoice>> fetchRefInvoices(String ref) async {
    final db = await database;
    List<Map<String, Object?>> invoices = await db!.query(Invoice.invTableName,
        where: '${Invoice.colinvRef} = ?', whereArgs: [ref], limit: 1);
    return invoices.isNotEmpty
        ? invoices.map((e) => Invoice.fromMap(e)).toList()
        : [];
  }

  // Search by Invoice ID
  Future<List<Invoice>> searchInvoices(int id) async {
    final db = await database;
    List<Map<String, Object?>> invoices = await db!.query(Invoice.invTableName,
        where: '${Invoice.colId} = ?', whereArgs: [id]);
    return invoices.isNotEmpty
        ? invoices.map((e) => Invoice.fromMap(e)).toList()
        : [];
  }

  // receive all invoices
  Future<List<Invoice>> allInvoices() async {
    final db = await database;
    List<Map<String, Object?>> invoices =
        await db!.query(Invoice.invTableName, orderBy: '${Invoice.colId} DESC');
    return invoices.isNotEmpty
        ? invoices.map((e) => Invoice.fromMap(e)).toList()
        : [];
  }

  Future<List<OrderItems>> fetchOrderItems(String refKey) async {
    final db = await database;
    List<Map<String, Object?>> orderItems = await db!.query(
        OrderItems.orderItemsTableName,
        where: '${OrderItems.colItemRef} = ?',
        whereArgs: [refKey]);
    return orderItems.isNotEmpty
        ? orderItems.map((e) => OrderItems.fromMap(e)).toList()
        : [];
  }
}
