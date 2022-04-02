// import 'package:cashier/models/company_model.dart';
// import 'package:cashier/models/products_model.dart';
// import 'package:cashier/providers/cart_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/company_provider.dart';

// class ProductsGrid extends StatefulWidget {
//   final List<Products> products;
//   final String categoryName;
//   const ProductsGrid(
//       {Key? key, required this.products, required this.categoryName})
//       : super(key: key);

//   @override
//   State<ProductsGrid> createState() => _ProductsGridState();
// }

// class _ProductsGridState extends State<ProductsGrid> {
//   String _subTitle = '';
//   @override
//   Widget build(BuildContext context) {
//     Company _company = Provider.of<CompanyProvider>(context).getCompany;
//     final cart = Provider.of<CartProvide>(context);

//     return Stack(
//       alignment: Alignment.bottomRight,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           color: Colors.black87,
//           child: widget.products.isNotEmpty
//               ? GridView.builder(
//                   itemCount: widget.products.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     crossAxisCount: 5,
//                   ),
//                   itemBuilder: (context, index) {
//                     String _productTitle = widget.products[index].title;
//                     String _productSubTitle = widget.products[index].subTitle;
//                     String _productId = widget.products[index].id;
//                     double _productPrice = widget.products[index].price;
//                     Color _textColor = Colors.black87;

//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           _subTitle = _productSubTitle;
//                         });
//                         cart.addItem(_productId, _productPrice, _productTitle);
//                       },
//                       child: GridTile(
//                         child: Card(
//                           elevation: 0.00,
//                           color: Colors.white.withOpacity(0.8),
//                           child: Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Column(
//                               children: [
//                                 FittedBox(
//                                     child: Text(
//                                   '${_company.currencyCode.toUpperCase()} ${(_productPrice).toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                       color: _textColor,
//                                       fontWeight: FontWeight.bold),
//                                 )),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       _productTitle,
//                                       style: TextStyle(
//                                         color: _textColor,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                       overflow: TextOverflow.fade,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 )
//               : const Center(
//                   child: Text(
//                     'No Products in this Category!',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 _subTitle,
//                 style: const TextStyle(color: Colors.teal),
//                 textAlign: TextAlign.end,
//               ),
//               Text(
//                 'Category: ${widget.categoryName}',
//                 style: const TextStyle(color: Colors.teal),
//                 textAlign: TextAlign.end,
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
