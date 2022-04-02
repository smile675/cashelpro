import '../screens/admin_screens/companyProfilePage.dart';

import '../screens/admin_screens/branch_list.dart';
import '../screens/admin_screens/category_list.dart';
import '../screens/admin_screens/products_list.dart';
import '../screens/admin_screens/stock_request.dart';

const tabScreenSize = 600;
const homeBackground = 'assets/images/cashelpro.jpg';
const background = 'assets/images/background.jpg';

const adminHomeItems = [
  ProductListAdmin(),
  CategoryList(),
  AdminHomePage(),
  BranchList(),
  // StockRequest(),
];
