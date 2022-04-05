import 'package:cashier/screens/common_screens/home.dart';
import 'package:cashier/screens/common_screens/user_manual.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Branch _branch = Provider.of<BranchProvider>(context).getBranch;
    return Drawer(
      child: ListView(
        children: [
          InkWell(
            onTap: (() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: ((context) => const HomePage())),
                (Route<dynamic> route) => false,
              );
            }),
            child: const ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Get Support'),
                      content: const Text(
                          'Please send an email to us explaining what support you need. If you face any issues using the app please explain briefly.\nThank you.\nSupport Email: angred.ismail@gmail.com'),
                      actions: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Close'),
                        ),
                      ],
                    );
                  });
            },
            child: const ListTile(
              title: Text('Get Support'),
              leading: Icon(Icons.info_outline),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserManual(
                        isAdmin: true,
                      )));
            },
            child: const ListTile(
              title: Text('User Manual'),
              leading: Icon(Icons.menu_book),
            ),
          ),
          // _branch.email == 'angred.ismail@gmail.com'
          //     ? InkWell(
          //         onTap: () {
          //           Navigator.of(context).push(MaterialPageRoute(
          //               builder: (context) => const ManageUsers()));
          //         },
          //         child: const ListTile(
          //             title: Text('Manage User'),
          //             leading: Icon(Icons.precision_manufacturing_outlined)),
          //       )
          //     : const Text(''),
        ],
      ),
    );
  }
}
