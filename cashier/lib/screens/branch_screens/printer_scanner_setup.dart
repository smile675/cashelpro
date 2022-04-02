// import 'dart:convert';

// import 'package:cashier/Widgets/branch_drawer.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SetupPrinter extends StatefulWidget {
//   const SetupPrinter({Key? key}) : super(key: key);

//   @override
//   State<SetupPrinter> createState() => _SetupPrinterState();
// }

// class _SetupPrinterState extends State<SetupPrinter> {
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _printers = [];
//   PrinterBluetooth? _myPrinter;
//   PaperSize _myPaperSize = PaperSize.mm58;

//   String? _myMacID;

//   @override
//   void initState() {
//     super.initState();
//     printerManager.scanResults.listen((devices) async {
//       setState(() {
//         _printers = devices;
//       });
//     });
//   }

//   void _startScan() {
//     setState(() {
//       _printers = [];
//     });

//     printerManager.startScan(Duration(seconds: 4));
//   }

//   void _stopScan() {
//     printerManager.stopScan();
//   }

//   void _savePrinterMacId(String _value) async {
//     final preferences = await SharedPreferences.getInstance();
//     preferences.setString('my_mac_id', _value);
//   }

//   void _savePaperSize(String key, _value) async {
//     final preferences = await SharedPreferences.getInstance();
//     preferences.setString(key, json.decode(_value));
//   }

//   Future<String?> getMacId() async {
//     final preferences = await SharedPreferences.getInstance();

//     String? gotMacId = preferences.getString('my_mac_id');
//     return gotMacId;
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     return Scaffold(
//       floatingActionButton: StreamBuilder<bool>(
//         stream: printerManager.isScanningStream,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data!) {
//             return FloatingActionButton(
//               child: Icon(Icons.stop),
//               onPressed: _stopScan,
//               backgroundColor: Colors.red,
//             );
//           } else {
//             return FloatingActionButton(
//               child: Icon(Icons.search),
//               onPressed: _startScan,
//             );
//           }
//         },
//       ),
//       drawer: const BranchDrawer(),
//       appBar: AppBar(
//         title: const Text('Setup Printer'),
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: _printers.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: _printers.length,
//                     itemBuilder: (contex, index) {
//                       return InkWell(
//                         onTap: () {
//                           setState(() {
//                             _myPrinter = _printers[index];
//                             _myMacID = _printers[index].address;
//                           });
//                         },
//                         child: Container(
//                             height: 60,
//                             child: ListTile(
//                                 leading: const Icon(Icons.print),
//                                 title: Text(_printers[index].name!),
//                                 subtitle: Text(_printers[index].address!),
//                                 trailing: const Icon(
//                                   Icons.playlist_add_check_circle_outlined,
//                                   color: Colors.teal,
//                                 ))),
//                       );
//                     })
//                 : Center(
//                     child: Text('No Printer'),
//                   ),
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(15),
//               color: Colors.teal,
//               child: _myPrinter != null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Card(
//                           color: Colors.white,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                   child: Icon(Icons.print),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(_myPrinter!.name!),
//                                       Text(_myPrinter!.address!),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: _myPaperSize == PaperSize.mm58
//                                       ? const Text('mm58')
//                                       : const Text('mm80'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             const Text(
//                               'Paper Size?',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   _myPaperSize = PaperSize.mm58;
//                                 });
//                               },
//                               child: Container(
//                                 color: _myPaperSize == PaperSize.mm58
//                                     ? Colors.blue
//                                     : Colors.white,
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text('mm58'),
//                                 ),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   _myPaperSize = PaperSize.mm80;
//                                 });
//                               },
//                               child: Container(
//                                 color: _myPaperSize == PaperSize.mm80
//                                     ? Colors.blue
//                                     : Colors.white,
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text('mm80'),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         ElevatedButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.save),
//                             label: Text('Save'))
//                       ],
//                     )
//                   : const Center(
//                       child: Text('No Printer Selected!'),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
