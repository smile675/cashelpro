import 'package:cashier/providers/company_provider.dart';
import 'package:cashier/providers/invoice_provider.dart';
import 'package:cashier/resourses/auth_method.dart';
import 'package:cashier/utils/global_variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Saving_Printing_Methods/pdf/pdf_api.dart';
import '../../Saving_Printing_Methods/pdf/pdf_invoice_api.dart';
import '../../models/branch_model.dart';
import '../../models/company_model.dart';
import '../../models/invoice_model.dart';
import '../../models/sales_statement_model.dart';
import '../../providers/branch_provider.dart';
import '../../utils/utils.dart';
import '../admin_screens/admin_main.dart';
import '../branch_screens/branch_main.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _value;
  int? _activityStatus;

  @override
  void initState() {
    super.initState();
    getBranchValue();
    addData();
  }

  void getBranchValue() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('branches')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _value = (snap.data() as Map<String, dynamic>)['value'];
      _activityStatus =
          (snap.data() as Map<String, dynamic>)['activity_status'];
    });
  }

  addData() async {
    BranchProvider _branchProvider = Provider.of(context, listen: false);
    await _branchProvider.refreshBranch();
    CompanyProvider _companyProvider = Provider.of(context, listen: false);
    await _companyProvider.getCurrentCompany();
    InvoiceProvider _dayInv = Provider.of(context, listen: false);
    await _dayInv.refreshDailyInvoices();
    InvoiceProvider _monthInv = Provider.of(context, listen: false);
    await _monthInv.refreshMonthlyInvoices();
  }

  // @override
  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          _user!.emailVerified
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(homeBackground), fit: BoxFit.cover),
                  ),
                  child: _value == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.teal),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BranchHome()));
                                },
                                icon: const Icon(Icons.store),
                                label: const Text('Open Branch'),
                              ),
                              _value == 1
                                  ? ElevatedButton.icon(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 10)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.teal),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AdminHome()));
                                      },
                                      icon: const Icon(
                                          Icons.admin_panel_settings_outlined),
                                      label: const Text('Admin Panel'),
                                    )
                                  : const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _saveStatementChoice(),
                                  const Text(
                                    'Save Statement',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                )
              : Container(
                  color: Colors.teal,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Email is not Verified yet!\n<Required\\> Click "Send Email Verification" to receive the verification email and follow the instructions there.\n<Reminder\\> App will logout in order to update your verification state.',
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.teal,
                        child: Container(
                          width: 250,
                          height: 50,
                          child: TextButton.icon(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            label: const Text('Send Email Verification'),
                            icon: const Icon(
                              Icons.mark_email_unread,
                            ),
                            onPressed: () async {
                              await _user.sendEmailVerification();
                              Authmethods().signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginBranch()),
                                  (route) => false);
                            },
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.teal,
                                Colors.teal,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                offset: const Offset(-22.6, -22.6),
                                blurRadius: 34,
                                spreadRadius: 0.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(22.6, 22.6),
                                blurRadius: 34,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 0, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const FittedBox(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                    onPressed: () {
                      Authmethods().signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginBranch()));
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    )),
                _activityStatus != null
                    ? _status(_activityStatus!)
                    : const Text('waiting...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _status(int code) {
    String status = 'some error';
    if (code == 0) {
      status = 'Account inactive';
    } else if (code == 1) {
      status = 'Account active';
    } else if (code == 2) {
      status = 'Active for limited time';
    }
    return Text(
      status,
      style: const TextStyle(color: Colors.teal),
    );
  }
}

Widget _saveStatementChoice() => PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(
            "Daily Statement",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          onTap: () async {
            // save pdf flie in device
            DateTime _today = DateTime.now();

            String _statementDay = DateFormat('dd-MM-yyyy').format(_today);
            String _fileNameprefix = DateFormat('ddMMyyyy').format(_today);
            String _fileName = 'DailySale_$_fileNameprefix';

            //retrieve company details
            Company _company =
                Provider.of<CompanyProvider>(context, listen: false).getCompany;

            Branch _branch =
                Provider.of<BranchProvider>(context, listen: false).getBranch;

            List<Invoice> _invoiceList =
                Provider.of<InvoiceProvider>(context, listen: false)
                    .getDailyInvoices;

            Statement _statement = Statement(
              statementInfo: StatementInfo(
                statementDate: _statementDay,
                statementType: 'Daily Sales Report',
              ),
              companyInfo: CompanyInfo(
                companyName: _company.companyName,
                email: _company.companyEmail,
                phone: _company.phoneNumber,
                fullAddress: _company.fullAddress,
              ),
              branchInfo: BranchInfo(
                branchName: _branch.branchName,
                email: _branch.email,
              ),
              invoiceList: _invoiceList,
            );

            if (_invoiceList.isNotEmpty) {
              final pdfFile = await PdfStatementApi.generate(
                  _statement, _fileName, _company.currencyCode);
              PdfApi.openfile(pdfFile);
            } else {
              showSnackBar('No Invoice Found!', context);
            }
          },
        ),
        PopupMenuItem(
          child: const Text(
            "Monthly Statement",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          onTap: () async {
            // save pdf flie in device
            DateTime _today = DateTime.now();

            String _statementDay = DateFormat('dd-MM-yyyy').format(_today);
            String _fileNameprefix = DateFormat('MMyyyy').format(_today);
            String _fileName = 'MontlySale_$_fileNameprefix';

            //retrieve company details
            Company _company =
                Provider.of<CompanyProvider>(context, listen: false).getCompany;

            Branch _branch =
                Provider.of<BranchProvider>(context, listen: false).getBranch;

            List<Invoice> _invoiceList =
                Provider.of<InvoiceProvider>(context, listen: false)
                    .getMonthInvoices;

            Statement _statement = Statement(
              statementInfo: StatementInfo(
                statementDate: _statementDay,
                statementType: 'Monthly Sales Report',
              ),
              companyInfo: CompanyInfo(
                companyName: _company.companyName,
                email: _company.companyEmail,
                phone: _company.phoneNumber,
                fullAddress: _company.fullAddress,
              ),
              branchInfo: BranchInfo(
                branchName: _branch.branchName,
                email: _branch.email,
              ),
              invoiceList: _invoiceList,
            );

            if (_invoiceList.isNotEmpty) {
              final pdfFile = await PdfStatementApi.generate(
                  _statement, _fileName, _company.currencyCode);
              PdfApi.openfile(pdfFile);
            } else {
              showSnackBar('No Invoice Found!', context);
            }
          },
        ),
      ],
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
    );

/*TODO: Need to solve this issue.
-> I think solved. but not 100% sure.  

Error: setState() called after dispose(): _HomePageState#12fbc(lifecycle state: defunct, not mounted)
This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
*/
