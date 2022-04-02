import 'package:cashier/models/invoice_model.dart';

class Statement {
  final StatementInfo statementInfo;
  final CompanyInfo companyInfo;
  final BranchInfo branchInfo;
  final List<Invoice> invoiceList;

  const Statement(
      {required this.statementInfo,
      required this.companyInfo,
      required this.branchInfo,
      required this.invoiceList});
}

// class InvoiceList {
//   final String invPrefix;
//   final int id;
//   final String invDay;
//   final String branchName;
//   final double amount;

//   InvoiceList({
//     required this.invPrefix,
//     required this.id,
//     required this.invDay,
//     required this.branchName,
//     required this.amount,
//   });
// }

class BranchInfo {
  final String branchName;
  final String email;

  BranchInfo({required this.branchName, required this.email});
}

class CompanyInfo {
  final String companyName;
  final String fullAddress;
  final String phone;
  final String email;

  CompanyInfo({
    required this.companyName,
    required this.fullAddress,
    required this.phone,
    required this.email,
  });
}

class StatementInfo {
  final String statementDate;

  final String statementType;

  const StatementInfo({
    required this.statementDate,
    required this.statementType,
  });
}
