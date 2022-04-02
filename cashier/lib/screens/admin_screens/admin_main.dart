import 'package:cashier/utils/global_variable.dart';

import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTab(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: adminHomeItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed, // Fixed

        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warehouse,
              color: _page == 0 ? Colors.teal : Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: _page == 1 ? Colors.teal : Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.verified_user_outlined,
              color: _page == 2 ? Colors.teal : Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.store_outlined,
              color: _page == 3 ? Colors.teal : Colors.black,
            ),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.request_page_outlined,
          //     color: _page == 4 ? Colors.teal : Colors.black,
          //   ),
          //   label: '',
          // ),
        ],
        onTap: navigationTab,
      ),
    );
  }
}
