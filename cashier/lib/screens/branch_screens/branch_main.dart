import 'package:flutter/material.dart';

import '../../Widgets/cart_display.dart';
import '../../Widgets/category_display.dart';

class BranchHome extends StatelessWidget {
  const BranchHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: const [
          Expanded(flex: 2, child: SelectProduct()),
          Expanded(flex: 1, child: CartScreen())
        ],
      ),
    );
  }
}
