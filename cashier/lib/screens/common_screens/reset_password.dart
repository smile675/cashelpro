import 'package:cashier/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resourses/auth_method.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailreset = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailreset.dispose();
    super.dispose();
  }

  void _resetPassowrd() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().resetPassword(email: _emailreset.text);
    if (res == 'success') {
      Navigator.of(context).pop();
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: _emailreset,
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
            const Text(
                'Let us send an Email containing a <password reset link\\>. Follow the link to reset your password.'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _resetPassowrd();
                  },
                  icon: const Icon(Icons.email_sharp),
                  label: Text(_isLoading ? 'Submiting' : 'Get Email'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
