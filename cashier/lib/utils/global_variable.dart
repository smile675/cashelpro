import 'package:cashier/models/category.dart';

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
  {
    'categoryId': 1,
    'categoryTitle': 'Demo 01',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 2,
    'categoryTitle': 'Demo 02',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 3,
    'categoryTitle': 'Demo 03',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 4,
    'categoryTitle': 'Demo 04',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 6,
    'categoryTitle': 'Demo 05',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 7,
    'categoryTitle': 'Demo 06',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 8,
    'categoryTitle': 'Demo 07',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 9,
    'categoryTitle': 'Demo 08',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 10,
    'categoryTitle': 'Demo 09',
    'companyKey': '',
    'itemCount': 12,
  },
  {
    'categoryId': 5,
    'categoryTitle': 'Demo 10',
    'companyKey': '',
    'itemCount': 12,
  },
];

const List demoProducts = [
  {'id': '01', 'Price': 8.00, 'Title': 'Product One', 'category': 'demo'},
  {'id': '02', 'Price': 10.00, 'Title': 'Product Two', 'category': 'demo'},
  {'id': '03', 'Price': 15.35, 'Title': 'Product Three', 'category': 'demo'},
  {'id': '04', 'Price': 12.60, 'Title': 'Product Four', 'category': 'demo'},
  {'id': '05', 'Price': 14.80, 'Title': 'Product Five', 'category': 'demo'},
  {'id': '06', 'Price': 18.90, 'Title': 'Product Six', 'category': 'demo'},
  {'id': '07', 'Price': 50.60, 'Title': 'Product Seven', 'category': 'demo'},
  {'id': '08', 'Price': 16.80, 'Title': 'Product Eight', 'category': 'demo'},
  {'id': '09', 'Price': 10.60, 'Title': 'Product Nine', 'category': 'demo'},
  {'id': '10', 'Price': 15.30, 'Title': 'Product Ten', 'category': 'demo'},
  {'id': '12', 'Price': 2.80, 'Title': 'Product Eleven', 'category': 'demo'},
  {'id': '12', 'Price': 15.60, 'Title': 'Product Tweleve', 'category': 'demo'},
  {'id': '13', 'Price': 60.90, 'Title': 'Product Thirteen', 'category': 'demo'},
];
