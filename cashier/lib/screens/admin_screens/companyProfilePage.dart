import 'package:cashier/models/company_model.dart';
import 'package:cashier/providers/company_provider.dart';

import 'package:cashier/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Widgets/admin_drawer.dart';
import 'update_company.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    const double contentSize = 18;
    const double detaiSize = 15;
    Company _company = Provider.of<CompanyProvider>(context).getCompany;
    const snackbarText = 'Company Key Copied!';

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Company Profile'),
        centerTitle: true,
        actions: [
          TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => UpdateCompanyProfile(
                              company: _company,
                            )),
                    (route) => false);
              },
              icon: const Icon(Icons.update),
              label: const Text('Update'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _company.companyName,
                  style: const TextStyle(
                    fontSize: detaiSize,
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _company.companyEmail,
                  style: const TextStyle(
                    fontSize: detaiSize,
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _company.phoneNumber,
                  style: const TextStyle(
                    fontSize: detaiSize,
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Currency Code',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _company.currencyCode,
                  style: const TextStyle(
                    fontSize: detaiSize,
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'HQ Location',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _company.hqLocation,
                  style: const TextStyle(
                    fontSize: detaiSize,
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _company.fullAddress,
                  style: const TextStyle(
                    fontSize: detaiSize,
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Company Key',
                  style: TextStyle(
                    fontSize: contentSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _company.companyKey,
                          style: const TextStyle(
                            fontSize: detaiSize,
                            color: Color.fromARGB(255, 54, 54, 54),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: _company.companyKey));
                            showSnackBar(snackbarText, context);
                          },
                        ),
                      ],
                    ),
                    const Text(
                      'Note: Do not share company key with anybody else. This key is compolsory only when you create Brances for your company.',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
