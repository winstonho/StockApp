import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'invoce.dart';


const examples = <Example>[
  Example('signature', 'resume.dart', generateInvoice),
  Example('pdf', 'document.dart', generateInvoice),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}