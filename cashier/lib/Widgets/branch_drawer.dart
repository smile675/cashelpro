import 'package:cashier/screens/branch_screens/search_invoices.dart';
import 'package:cashier/screens/common_screens/home.dart';
import 'package:flutter/material.dart';

import '../screens/branch_screens/create_stock_request.dart';
import '../screens/branch_screens/daily_reports.dart';
import '../screens/branch_screens/monthly_reports.dart.dart';
import 'package:intl/intl.dart';

import '../screens/branch_screens/printer_scanner_setup.dart';

class BranchDrawer extends StatelessWidget {
  const BranchDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String toDay = DateFormat('dd-MM-yyyy').format(now);
    String thisMonth = DateFormat('MM-yyyy').format(now);
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text(
                'In order to Close Branch go to\nHome> Save Statement and Logout!'),
          ),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: ((context) => const HomePage())),
                (Route<dynamic> route) => false,
              );
            },
            child: const ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => DailyReports(
                            toDay: toDay,
                          ))));
            },
            child: const ListTile(
              title: Text(' Daily Reports'),
              leading: Icon(Icons.note),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => MonthlyReports(
                            thisMonth: thisMonth,
                          ))));
            },
            child: const ListTile(
              title: Text('Monthly Reports'),
              leading: Icon(Icons.receipt_long),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const SearchInvoice())));
            },
            child: const ListTile(
              title: Text('Search Invoice'),
              leading: Icon(Icons.search),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const SetupPrinter()));
          //   },
          //   child: const ListTile(
          //       title: Text('Printer Setup'),
          //       leading: Icon(Icons.print_rounded)),
          // ),
        ],
      ),
    );
  }
}
