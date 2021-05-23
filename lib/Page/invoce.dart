import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_app/model/StockInfo.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat,StockInfo stockInfo,WithdrawInfo withdrawInfo) async {
  final lorem = pw.LoremText();


  var temp = withdrawInfo.signature.split(',');
  Uint8List temp1 = Uint8List(temp.length);
  for(int i = 0; i< temp.length; i++)
  {
    if(i == 0)
      temp1[i] = int.parse(temp[i].substring(1));
    else if(i == temp.length -1)
      temp1[i] = int.parse(temp[i].substring(0,temp[i].length-1));
    else
      temp1[i] = int.parse(temp[i]);
  }

  final products = <Product>[
    Product('19874', lorem.sentence(4), 3.99, 2),
    Product('98452', lorem.sentence(6), 15, 2),
  ];

  final invoice = Invoice(
    invoiceNumber: stockInfo.id,
    products: products,
    tax: .15,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
    image: temp1,
    sInfo: stockInfo,
    wInfo: withdrawInfo
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
     this.products,
     this.invoiceNumber,
     this.tax,
     this.baseColor,
     this.accentColor,
     this.image,
     this.wInfo,
     this.sInfo
  });

  final List<Product> products;
  final String invoiceNumber;
  final double tax;
  final Uint8List image;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final StockInfo sInfo;
  final WithdrawInfo wInfo;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor =>  _lightColor;

  PdfColor get _accentTextColor =>  _lightColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  //String _logo;

  //String _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();
    print("test");
    final signImage = pw.MemoryImage(image);
    print("hello");
    final font1 = await rootBundle.load('assets/Montserrat-Regular.ttf');
    final font2 = await rootBundle.load('assets/Montserrat-Regular.ttf');
    final font3 = await rootBundle.load('assets/Montserrat-Regular.ttf');

    //_logo = await rootBundle.loadString('assets/logo.svg');
   // _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          pw.Font.ttf(font1),
          pw.Font.ttf(font2),
          pw.Font.ttf(font3),
        ),
        header: _buildHeader,
        //footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context,signImage),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 100,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 11,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #',style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text(invoiceNumber,style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text('Date:',style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text(_formatDate(sInfo.stockDate),style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text('Draw By:',style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text(wInfo.drawBy,style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text('Received By:',style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                          pw.Text(wInfo.received,style: pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${_formatCurrency(_grandTotal)}',
                style: pw.TextStyle(
                  color: baseColor,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context , image) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Signature',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Image(image,height: 100,width: 100),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(_total)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'SKU#',
      'Item Description',
      'Price',
      'Quantity',
      'Total'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

class Product {
  const Product(
      this.sku,
      this.productName,
      this.price,
      this.quantity,
      );

  final String sku;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return _formatCurrency(total);
    }
    return '';
  }
}