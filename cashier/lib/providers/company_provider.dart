import 'package:cashier/models/company_model.dart';
import 'package:cashier/resourses/auth_method.dart';
import 'package:flutter/material.dart';

class CompanyProvider with ChangeNotifier {
  Company? _company;

  final Authmethods _authmethods = Authmethods();
  Company get getCompany => _company!;

  Future<void> getCurrentCompany() async {
    Company currentCompany = await _authmethods.getCompamy();

    if (currentCompany.companyKey.isNotEmpty) {
      _company = currentCompany;
    }

    notifyListeners();
  }
}
