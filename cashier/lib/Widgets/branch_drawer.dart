import 'package:cashier/models/branch_model.dart';
import 'package:cashier/providers/branch_provider.dart';
import 'package:cashier/screens/branch_screens/search_invoices.dart';
import 'package:cashier/screens/common_screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/branch_screens/daily_reports.dart';
import '../screens/branch_screens/monthly_reports.dart.dart';
import 'package:intl/intl.dart';

import '../screens/common_screens/user_manual.dart';

class BranchDrawer extends StatelessWidget {
  const BranchDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Branch _branch = Provider.of<BranchProvider>(context).getBranch;
    DateTime now = DateTime.now();
    String toDay = DateFormat('dd-MM-yyyy').format(now);
    String thisMonth = DateFormat('MM-yyyy').format(now);
    return Drawer(
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: ListView(
              children: [
                const ListTile(
                  title: Text(
                      'In order to Close Branch go to\nHome> Save Statement and Logout!'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const HomePage())),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const ListTile(
                    title: Text('Home'),
                    leading: Icon(
                      Icons.home,
                      color: Colors.teal,
                    ),
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
                    leading: Icon(
                      Icons.note,
                      color: Colors.teal,
                    ),
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
                    leading: Icon(
                      Icons.receipt_long,
                      color: Colors.teal,
                    ),
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
                    leading: Icon(
                      Icons.search,
                      color: Colors.teal,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UserManual(
                              isAdmin: false,
                            )));
                  },
                  child: const ListTile(
                    title: Text('User Manual'),
                    leading: Icon(
                      Icons.menu_book,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.teal,
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.store_mall_directory_outlined),
                ),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heading('Branch Name'),
                    _notHeading(_branch.branchName),
                    _heading('Email'),
                    _notHeading(_branch.email),
                    _heading('Location'),
                    _notHeading(_branch.branchLocation),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _heading(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Text _notHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
      ),
    );
  }
}
