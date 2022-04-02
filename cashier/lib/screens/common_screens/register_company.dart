import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resourses/auth_method.dart';
import '../../utils/global_variable.dart';
import '../../utils/utils.dart';
import 'home.dart';
import 'login_screen.dart';

class RegisterCompany extends StatefulWidget {
  const RegisterCompany({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterCompany> createState() => _RegisterCompanyState();
}

class _RegisterCompanyState extends State<RegisterCompany> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _hqLocation = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _fullAddress = TextEditingController();
  final TextEditingController _currency = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _companyName.dispose();
    _hqLocation.dispose();
    _phoneNumber.dispose();
    _fullAddress.dispose();
    _currency.dispose();

    super.dispose();
  }

  void createCompany() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().createCompany(
        email: _email.text,
        password: _password.text,
        companyName: _companyName.text,
        currencyCode: _currency.text,
        phoneNumber: _phoneNumber.text,
        fullAddress: _fullAddress.text,
        hqLocation: _hqLocation.text);

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Register a Company_',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                        maxLength: 3,
                        controller: _currency,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white54,
                            labelStyle: const TextStyle(color: Colors.white),
                            hintText: 'USD, MYR, EUR...',
                            label: Row(
                              children: const [
                                Icon(
                                  Icons.currency_exchange,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Currency Code'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _companyName,
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
                                  Icons.business_center,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Company Name'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _hqLocation,
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
                                  Icons.location_city,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('HQ City'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumber,
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
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Phone Number'),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        maxLines: 2,
                        controller: _fullAddress,
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
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Full Address'),
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
                              'Already Registered?',
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              createCompany();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),

              alignment: Alignment.center,
              // height: 30,
              width: double.infinity,
              color: Colors.teal,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Company'),
            ),
          )
        ],
      ),
    );
  }
}
