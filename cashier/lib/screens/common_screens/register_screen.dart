import 'package:cashier/resourses/auth_method.dart';
import 'package:cashier/screens/common_screens/home.dart';
import 'package:cashier/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/global_variable.dart';
import 'login_screen.dart';
import 'register_company.dart';

class RegisterBranch extends StatefulWidget {
  const RegisterBranch({Key? key}) : super(key: key);

  @override
  _RegisterBranchState createState() => _RegisterBranchState();
}

class _RegisterBranchState extends State<RegisterBranch> {
  late final TextEditingController _typeCompanyKey;

  @override
  void initState() {
    _typeCompanyKey = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _typeCompanyKey.dispose();

    super.dispose();
  }

  final snackbarText = 'Wrong Key!?';

  checkCompanyID(String key) async {
    QuerySnapshot cheker = await FirebaseFirestore.instance
        .collection('company')
        .where('companyKey', isEqualTo: key)
        .get();
    // for (var doc in cheker.docs) {
    //   if (doc.exists) {
    //     final gotCompanyKey = _typeCompanyKey.text;

    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //           builder: ((context) =>
    //               RegistrationForm(companyKey: gotCompanyKey))),
    //     );
    //   } else {
    //     showSnackBar(snackbarText, context);
    //   }
    // }
    if (cheker.docs.isNotEmpty) {
      final gotCompanyKey = _typeCompanyKey.text;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: ((context) =>
                RegistrationForm(companyKey: gotCompanyKey))),
      );
    } else {
      showSnackBar(snackbarText, context);
    }
  }

  void gotToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginBranch()));
  }

  void createNewCompany() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterCompany()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Card(
                        child: ListTile(
                          title: Text('Caution!'),
                          subtitle: Text(
                              'Company key is compulsory to open a new Branch. If you do not have a company, first create one.'),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        autocorrect: false,
                        controller: _typeCompanyKey,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white54,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: Row(
                              children: const [
                                Icon(
                                  Icons.key,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Company Key'),
                              ],
                            )),
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Already have a branch?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  gotToLogin();
                                },
                                child: const Text(
                                  '<Login\\>',
                                  style: TextStyle(color: Colors.teal),
                                ))
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Do not have a company yet?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  createNewCompany();
                                },
                                child: const Text(
                                  '<Register a Company\\>',
                                  style: TextStyle(color: Colors.teal),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              checkCompanyID(_typeCompanyKey.text);
            },
            child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: const Text(
                  'Check Key',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  final String companyKey;
  const RegistrationForm({
    Key? key,
    required this.companyKey,
  }) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _brancName = TextEditingController();
  final TextEditingController _branchLocation = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _brancName.dispose();
    _branchLocation.dispose();

    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().signUpUser(
      email: _email.text,
      companyKey: widget.companyKey,
      password: _password.text,
      branchName: _brancName.text,
      branchLocation: _branchLocation.text,
    );

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void createNewCompany() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterCompany()));
  }

  void gotToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginBranch()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create a Branch_',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white54,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: Row(
                              children: const [
                                Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Email Address'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white54,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: Row(
                              children: const [
                                Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Password'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _brancName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white54,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: Row(
                              children: const [
                                Icon(
                                  Icons.warehouse,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Branch Name'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _branchLocation,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Name of City or Area, Not full address',
                            filled: true,
                            fillColor: Colors.white54,
                            labelStyle: const TextStyle(color: Colors.white),
                            label: Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Branch Location'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Already have a branch?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  gotToLogin();
                                },
                                child: const Text(
                                  '<Login\\>',
                                  style: TextStyle(color: Colors.teal),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              signUpUser();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              width: double.infinity,
              color: Colors.teal,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
