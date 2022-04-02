import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final bytes = await pdf.save();
    final file = File('${dir.path}/$name.pdf');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openfile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
