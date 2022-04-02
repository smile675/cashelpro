import 'package:cashier/models/branch_model.dart';
import 'package:cashier/resourses/auth_method.dart';
import 'package:flutter/material.dart';

class BranchProvider with ChangeNotifier {
  Branch? _branch;
  final Authmethods _authmethods = Authmethods();

  Branch get getBranch => _branch!;

  Future<void> refreshBranch() async {
    Branch branch = await _authmethods.getBranchDetails();
    _branch = branch;
    notifyListeners();
  }
}
