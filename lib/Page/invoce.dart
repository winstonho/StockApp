import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
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



  final invoice = Invoice(
    invoiceNumber: stockInfo.id,
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
     this.invoiceNumber,
     this.tax,
     this.baseColor,
     this.accentColor,
     this.image,
     this.wInfo,
     this.sInfo
  });

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
          pw.SizedBox(height: 20),
          _contentAdminTable1(context,signImage),
          pw.SizedBox(height: 20),
          _contentTableStoreMen(context),
          _contentTableLastInfo(context),
          pw.SizedBox(height: 20),
          _contentFooter(context,signImage),
          pw.SizedBox(height: 20),
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
                          pw.Text('No 9A Koon Crescent Singapore 629023',style: pw.TextStyle(fontSize: 10,color: PdfColors.black)),
                          pw.Text('Tel   :   (65)68622270  Fax:   (65)68622317',style: pw.TextStyle(fontSize: 10,color: PdfColors.black)),
                          pw.Text('Website: www.trisome.com.sg',style: pw.TextStyle(fontSize: 10,color: PdfColors.black)),
                          pw.Text('Email:   daiseylim@trisome.com.sg',style: pw.TextStyle(fontSize: 10,color: PdfColors.black)),
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
  pw.Widget _contentFooter(pw.Context context , image) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'REMARKS: ',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                sInfo.remake,
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }



  pw.TextStyle pwTableHeadingTextStyle() =>
      pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold,);

  pw.BoxDecoration pwTableHeadingDecoration() =>
  pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(100)),

  );

  pw.Padding paddedTextCell(String textContent) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(4),
      child:
      pw.Column(crossAxisAlignment:pw.CrossAxisAlignment.center, children: [
        pw.Text(textContent,style:pwTableHeadingTextStyle() , textAlign: pw.TextAlign.left ),
      ]),
    );
  }

  pw.Padding paddedCell( content) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(4),
      child:
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [content]),
    );
  }

  pw.Padding paddedHeadingTextCell(String textContent) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(4),
      child: pw.Column(children: [
        pw.Text(
          textContent,
          style: pwTableHeadingTextStyle(),
        ),
      ]),
    );
  }

  pw.Widget _contentAdminTable1(pw.Context context,image) {
    return pw.Table(
        border: pw.TableBorder.all(width: 1, color: baseColor), children: [
      pw.TableRow(
        repeat: true,
        decoration: pwTableHeadingDecoration(),
        children: [
          paddedHeadingTextCell('QTY'),
          paddedHeadingTextCell('Description'),
          paddedHeadingTextCell('Bal QTY'),
          paddedHeadingTextCell('INITIAL BY WITHDRAWAL'),
          paddedHeadingTextCell('SIGNED BY COLLECTOR'),
        ],
      ),
      pw.TableRow(
        repeat: true,
        decoration: pwTableHeadingDecoration(),
        children: [
          paddedTextCell(sInfo.quantity.toString()),
          paddedHeadingTextCell(sInfo.remake.toString()),
          paddedHeadingTextCell(sInfo.balance.toString()),
          paddedHeadingTextCell(wInfo.drawBy),
          //paddedHeadingTextCell('SIGNED BY COLLECTOR'),
          paddedCell(pw.Image(image,height: 40,width: 40))
        ],
      ),
    ]);
  }


  pw.Widget _contentTableStoreMen(pw.Context context) {
    return pw.Table(
        border: pw.TableBorder.all(width: 1, color: baseColor), children: [
      pw.TableRow(
        repeat: true,
        decoration: pwTableHeadingDecoration(),
        children: [
          paddedHeadingTextCell('Rack'),
          paddedHeadingTextCell('BATCH'),
          paddedHeadingTextCell('SERIAL.NO(if any)'),
          paddedHeadingTextCell('INITIAL'),
          paddedHeadingTextCell('DATE'),
        ],
      ),
      pw.TableRow(
        repeat: true,
        decoration: pwTableHeadingDecoration(),
        children: [
          paddedTextCell(""),
          paddedHeadingTextCell(""),
          paddedHeadingTextCell(sInfo.id),
          paddedHeadingTextCell(wInfo.drawBy),
          paddedHeadingTextCell(_formatDate(sInfo.stockDate))
        ],
      ),
    ]);
  }


  pw.Widget _contentTableLastInfo(pw.Context context) {
    return pw.Table(
        border: pw.TableBorder.all(width: 1, color: baseColor), children: [
      pw.TableRow(
        repeat: true,
        decoration: pwTableHeadingDecoration(),
        children: [
          paddedHeadingTextCell('Received by: ' + wInfo.received),
          paddedHeadingTextCell('Initial by: '+ wInfo.drawBy),
          paddedHeadingTextCell('Date: '+ _formatDate(sInfo.stockDate)),
        ],
      ),
    ]);
  }

}




String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

