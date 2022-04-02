import 'package:cashier/models/invoice_model.dart';
import 'package:cashier/resourses/local_database_methods.dart';
import 'package:cashier/screens/branch_screens/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/company_model.dart';
import '../../providers/company_provider.dart';

class SearchInvoice extends StatefulWidget {
  const SearchInvoice({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchInvoice> createState() => _SearchInvoiceState();
}

class _SearchInvoiceState extends State<SearchInvoice> {
  final TextEditingController _searchController = TextEditingController();

  bool isShowInvoice = false;
  int? invID;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Company _company = Provider.of<CompanyProvider>(context).getCompany;
    final _dbhelper = LocalDatabase.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Search Invoice')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: isShowInvoice
                  ? _dbhelper.searchInvoices(invID!)
                  : _dbhelper.allInvoices(),
              builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Invoices to Show'),
                  );
                }

                return Container(
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
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _searchController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: 'Search With Invoice unique ID',
                  icon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
              onFieldSubmitted: (String _) {
                setState(() {
                  if (_searchController.text.isNotEmpty) {
                    invID = int.parse(_searchController.text);
                    invID! > 0 ? isShowInvoice = true : isShowInvoice = false;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
