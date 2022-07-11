import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart'; 
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class JournalXlsx {
  Future<void> exportToExcel(List<JournalModel> dataList) async {
    var excel = Excel.createExcel();
    String title = "Journals";
    Sheet sheetObject = excel[title];
    sheetObject.insertRowIterables([
      "id",
      "numeroOperation",
      "libele",
      "compteDebit",
      "montantDebit",
      "compteCredit",
      "montantCredit",
      "tva",
      "remarque",
      "signature", 
      "created",
      "approbationDG",
      "motifDG",
      "signatureDG",
      "approbationDD",
      "motifDD",
      "signatureDD"
    ], 0);

    for (int i = 0; i < dataList.length; i++) {
      List<String> data = [
        dataList[i].id.toString(),
        dataList[i].numeroOperation,
        dataList[i].libele,
        dataList[i].compteDebit,
        dataList[i].montantDebit,
        dataList[i].compteCredit,
        dataList[i].montantCredit,
        dataList[i].tva,
        dataList[i].remarque,
        dataList[i].signature, 
        DateFormat("dd/MM/yy HH-mm").format(dataList[i].created),
        dataList[i].approbationDG,
        dataList[i].motifDG,
        dataList[i].signatureDG,
        dataList[i].approbationDD,
        dataList[i].motifDD,
        dataList[i].signatureDD
      ];

      sheetObject.insertRowIterables(data, i + 1);
    }
    excel.setDefaultSheet(title);
    final dir = await getApplicationDocumentsDirectory();
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);

    var onValue = excel.encode();
    File('${dir.path}/$title$date.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
  }
}
