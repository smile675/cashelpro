import 'package:cashier/resourses/auth_method.dart';
import 'package:cashier/screens/common_screens/home.dart';
import 'package:cashier/screens/common_screens/register_company.dart';
import 'package:cashier/screens/common_screens/reset_password.dart';
import 'package:cashier/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/global_variable.dart';
import 'register_screen.dart';

class LoginBranch extends StatefulWidget {
  const LoginBranch({Key? key}) : super(key: key);

  @override
  _LoginBranchState createState() => _LoginBranchState();
}

class _LoginBranchState extends State<LoginBranch> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _emailreset = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailreset.dispose();

    super.dispose();
  }

  void loginbranch() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().loginUser(
      email: _email.text,
      password: _password.text,
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

  void gotToRegister() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterBranch()));
  }

  void createNewCompany() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterCompany()));
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login Here_',
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
                      Align(
                        alignment: const Alignment(1, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ResetPassword()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'To create additional branches..',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  gotToRegister();
                                },
                                child: const Text(
                                  '<Create Branch\\>',
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
              loginbranch();
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
                      'Login',
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
