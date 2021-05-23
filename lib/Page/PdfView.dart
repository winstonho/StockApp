import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/StockInfo.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'invoce.dart';


class PdfView extends StatefulWidget {
  static const String route = '/pdfView';
  final StockInfo sInfo;
  final WithdrawInfo wInfo;

  PdfView({this.sInfo,this.wInfo});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<PdfView> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {

  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
      BuildContext context,
      build,
      PdfPageFormat pageFormat,
      ) async {

    final bytes = await build(pageFormat);
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Widget pdfView()
  {
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];
   return  PdfPreview(
      maxPageWidth: 700,
      build: (format) => generateInvoice(format,widget.sInfo,widget.wInfo),
      actions: actions,
      onPrinted: _showPrintedToast,
      onShared: _showSharedToast,
     canChangePageFormat: true,
     canChangeOrientation: true,
     useActions: true,
     allowPrinting: true,
     allowSharing: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF REVIEW'),
      ),
      body:  pdfView()
    );
  }

}