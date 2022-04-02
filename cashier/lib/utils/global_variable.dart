import '../screens/admin_screens/companyProfilePage.dart';

import '../screens/admin_screens/branch_list.dart';
import '../screens/admin_screens/category_list.dart';
import '../screens/admin_screens/products_list.dart';

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

const List democategory = [
  'Category 1',
  'Category 2',
  'Category 3',
  'Category 4',
  'Category 5',
  'Category 6',
  'Category 7',
  'Category 8',
  'Category 9',
];

const List demoProducts = [
  {'Price': 8.00, 'Title': 'Product One'},
  {'Price': 10.00, 'Title': 'Product Two'},
  {'Price': 15.35, 'Title': 'Product Three'},
  {'Price': 12.60, 'Title': 'Product Four'},
  {'Price': 14.80, 'Title': 'Product Five'},
  {'Price': 18.90, 'Title': 'Product Six'},
  {'Price': 50.60, 'Title': 'Product Seven'},
  {'Price': 16.80, 'Title': 'Product Eight'},
  {'Price': 10.60, 'Title': 'Product Nine'},
  {'Price': 15.30, 'Title': 'Product Ten'},
  {'Price': 2.80, 'Title': 'Product Eleven'},
  {'Price': 15.60, 'Title': 'Product Tweleve'},
  {'Price': 60.90, 'Title': 'Product Thirteen'},
];
