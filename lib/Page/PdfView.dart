import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';


import 'example.dart';

class PdfView extends StatefulWidget {
  static const String route = '/pdfView';
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<PdfView> with SingleTickerProviderStateMixin {
  int _tab = 0;
  TabController _tabController;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );


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

    _tabController = TabController(
      vsync: this,
      length: examples.length,
      initialIndex: _tab,
    );
    _tabController.addListener(() {
      if (_tab != _tabController.index) {
        setState(() {
          _tab = _tabController.index;
        });
      }
    });

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
      build: (format) => examples[_tab].builder(format),
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

  Widget signature()
  {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          //SIGNATURE CANVAS
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: backgroundColor,
          ),
          //OK AND CLEAR BUTTONS
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SHOW EXPORTED IMAGE IN NEW ROUTE
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final  data =
                      await _controller.toPngBytes();
                      if (data != null) {


                        //final appDocDir = await getApplicationDocumentsDirectory();
                        //final appDocPath = appDocDir.path;
                       // final file = File(appDocPath + '/' + 'filename.png');
                        //print('Save as file ${file.path} ...');
                        //await file.writeAsBytesSync(data.buffer.asInt8List());
                        //await OpenFile.open(file.path);

                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(),
                                body: Center(
                                  child: Container(
                                    color: backgroundColor,
                                    child: Image.memory(data),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
                //CLEAR CANVAS
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }




    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: examples.map<Tab>((e) => Tab(text: e.name)).toList(),
          isScrollable: true,
        ),
      ),
      body: _tab == 0 ? signature() : pdfView()
    );
  }

}