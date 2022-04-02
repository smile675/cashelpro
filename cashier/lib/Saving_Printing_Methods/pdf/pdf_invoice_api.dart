import 'dart:io';

import 'package:cashier/models/sales_statement_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'pdf_api.dart';

class PdfStatementApi {
  static Future<File> generate(
      Statement statement, String pdfName, String _currency) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        // Container(child: Center(child: Text('Hello World')))
        buildHeader(statement),
        buildBody(statement, _currency),
        Divider(),
        buildTotal(statement, _currency),
      ],
    ));

    return PdfApi.saveDocument(name: pdfName, pdf: pdf);
  }

  static Widget buildHeader(Statement statement) => Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          buildCompanyDetails(statement.companyInfo),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildBranchDetails(statement.branchInfo),
              buildStatementInfo(statement.statementInfo),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'SALES STATEMENT',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 5),
        ],
      ));

  static Widget buildCompanyDetails(CompanyInfo company) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company.companyName),
            Text(company.email),
            Text(company.phone),
            Text(company.fullAddress),
          ],
        ),
      );

  static Widget buildBranchDetails(BranchInfo branch) => Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Branch: ${branch.branchName}'),
          Text('Email: ${branch.email}'),
        ],
      ));

  static Widget buildStatementInfo(StatementInfo info) {
    final titles = <String>['Date:', 'Type:'];
    final data = <String>[
      info.statementDate,
      info.statementType,
    ];

    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    ));
  }

  static Widget buildBody(Statement statement, String gotCurrency) {
    final headers = [
      'INVOICE NUMBER',
      'DATE',
      'BRANCH',
      'AMOUNT',
    ];
    final data = statement.invoiceList.map((item) {
      return [
        '${item.invPrefix} ${item.id}',
        item.invDay,
        item.branchName,
        '$gotCurrency ${item.amount.toStringAsFixed(2)}'
      ];
    }).toList();
    return Container(
        child: Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    ));
  }

  static Widget buildTotal(Statement statement, String gotCurrency) {
    final total =
        statement.invoiceList.map((e) => e.amount).reduce((e1, e2) => e1 + e2);

    final totalInvoices = statement.invoiceList.length;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: buildText(
              title: 'Number of Invoices: ',
              value: totalInvoices.toString(),
            ),
          ),
          Expanded(
            flex: 1,
            child: buildText(
                title: 'Total Sales: ',
                value: '$gotCurrency ${total.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Text(title, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
