import 'package:cashier/models/invoice_model.dart';
import 'package:cashier/resourses/local_database_methods.dart';
import 'package:cashier/screens/branch_screens/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/company_model.dart';
import '../../providers/company_provider.dart';

class DailyReports extends StatelessWidget {
  final String toDay;
  const DailyReports({Key? key, required this.toDay}) : super(key: key);

  void printStatement() {}

  @override
  Widget build(BuildContext context) {
    Company _company = Provider.of<CompanyProvider>(context).getCompany;
    final _dbhelper = LocalDatabase.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Sale'),
      ),
      body: FutureBuilder(
        future: _dbhelper.fetchInvoices(toDay),
        builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {
          double _total = 0.0;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Invoices to Show'),
            );
          }
          for (var i in snapshot.data!) {
            _total += i.amount;
          }

          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      String _refKey = snapshot.data![index].invRef;
                      String _invNum =
                          '${snapshot.data![index].invPrefix} ${(snapshot.data![index].id).toString()}';
                      String _invDate = snapshot.data![index].invDay;
                      double _invAmount = (snapshot.data![index].amount);
                      String _brancName = snapshot.data![index].branchName;
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black26))),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                  refKey: _refKey,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            child: Text(
                              (index + 1).toString(),
                            ),
                          ),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Invoice Number:'),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(_invNum)
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Invoice Date'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(_invDate),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Branch'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(_brancName)
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                              '${_company.currencyCode} ${(_invAmount).toStringAsFixed(2)}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                width: double.infinity,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Sale: ${_company.currencyCode} ${_total.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
