import 'package:cashier/screens/common_screens/home.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onTap: () {},
            child: const ListTile(
              title: Text('Get Support'),
              leading: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }
}
