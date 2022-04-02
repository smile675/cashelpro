// import 'package:cashier/providers/branch_provider.dart';
// import 'package:cashier/utils/global_variable.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ResponsiveLayout extends StatefulWidget {
//   final Widget tabScreenLayout;
//   final Widget mobileScreenLayout;
//   const ResponsiveLayout({
//     Key? key,
//     required this.tabScreenLayout,
//     required this.mobileScreenLayout,
//   }) : super(key: key);

//   @override
//   State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
// }

// class _ResponsiveLayoutState extends State<ResponsiveLayout> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     addData();
//   }

//   addData() async {
//     BranchProvider _branchProvider = Provider.of(context, listen: false);
//     await _branchProvider.refreshBranch();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       if (constraints.maxWidth > tabScreenSize) {
//         //tab Screen
//         return widget.tabScreenLayout;
//       }
//       return widget.mobileScreenLayout;
//     });
//   }
// }
