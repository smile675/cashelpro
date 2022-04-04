import 'package:flutter/material.dart';

class UserManual extends StatefulWidget {
  final bool isAdmin;
  const UserManual({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  bool _adminManual = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Manual'),
        actions: [
          widget.isAdmin
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      _adminManual = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                  title: Text('Admin User Manual'),
                                ),
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      _adminManual = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                  title: Text('Branch User Manual'),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.menu_open_sharp,
                  ))
              : const Text(''),
        ],
      ),
      body: _adminManual
          ? Column(
              children: [Text('admin manual')],
            )
          : Column(
              children: [Text('branch Manual')],
            ),
    );
  }
}
