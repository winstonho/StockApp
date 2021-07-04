import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app/Page/PdfView.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/model/StockInfo.dart';


import 'package:flutter_app/widgets/constant.dart';
import 'package:intl/intl.dart';


//import 'package:flutter_app/Service/DatabaseService.dart';
//import 'package:flutter_app/Util/Random.dart';
//import 'package:flutter_app/model/ProductInfo.dart';
//import 'package:flutter_app/model/Route/ScreenArguments.dart';
//import 'package:flutter_app/model/StockInfo.dart';
//import 'package:flutter_app/widgets/constant.dart';
//import 'package:uuid/uuid.dart';

import 'package:money2/money2.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';



class WithdrawForm extends StatefulWidget {
  final String info;

  WithdrawForm({this.info});
  @override
  _WithdrawFormState createState() => _WithdrawFormState();
}

class _WithdrawFormState extends State<WithdrawForm> {

  DateTime selectedDate = DateTime.now();

  int quantity = 0;
  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);
  String price;
  TextEditingController remarks = TextEditingController();
  TextEditingController drawBy = TextEditingController();
  TextEditingController received = TextEditingController();
  String curretnId = "";




  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );


Widget testIconCheck()
  {
        return      IconButton(
          icon: const Icon(Icons.check),
          color: Colors.blue,
          onPressed: () async {
            if (_controller.isNotEmpty) {
              final  data =
              await _controller.toPngBytes();
              if (data != null) {

                data.toString();

                var temp = data.toString().split(',');
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
                            color: Colors.white,
                            child: Image.memory(temp1),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
          },
        );
  }

  Widget signature()
  {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //SIGNATURE CANVAS
          Signature(
            controller: _controller,
            height: 100,
            backgroundColor: Colors.white,
          ),
          //OK AND CLEAR BUTTONS
          SizedBox(height: 10),
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
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


  Widget inputText(String label,TextEditingController value,int maxLine,BuildContext context) {
    return Card(
      color: HexColor.fromHex("#292929"),
      child: TextFormField(
        controller: value,
        style: style_,
        maxLines: maxLine,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: label,
          hintStyle: style_,
        ),
      ),
    );
  }
  
  
  Widget inputRemarks(BuildContext context) {
    return Card(
      color: HexColor.fromHex("#292929"),
      child: TextFormField(
        style: style_,
        maxLines: null,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: 'Remarks:',
          hintStyle: style_,
        ),
      ),
    );
  }

  Widget inputPrice(BuildContext context) {
    return Container(
      height: 50,
      child: Card(
        color: HexColor.fromHex("#292929"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.attach_money,
                  color: HexColor.fromHex("#979798"), size: 15),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  style: style_,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    hintText: 'Unit Price',
                    hintStyle: style_,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputTotalPrice(BuildContext context) {

    print("Quantity is: "  + quantity.toString());
    return StreamBuilder<ProductInfo>(
      stream: DatabaseService().getProduct(widget.info).asStream(),
      builder: (context, snapshot) {
        final sgd = Currency.create('SGD', 2);
        final unitPrice = Money.fromInt(snapshot.data.avgPrice, sgd);
        
        return Container(
          height: 50,
          child: Card(
            color: HexColor.fromHex("#292929"),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Total Price:", style: style_),
                  Spacer(),
                  Text((unitPrice * quantity).toString(), style: style_)
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget inputQuantity(BuildContext context) {
    return Container(
      height: 50,
      child: Card(
        color: HexColor.fromHex("#292929"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.account_balance,
                  color: HexColor.fromHex("#979798"), size: 15),
              SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  style: style_,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  // Only numbers can be entered
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      hintText: 'Quantity',
                      hintStyle: style_,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                  onChanged: (value) {
                    setState(() {
                      quantity = int.parse(value);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  Future addNewStock() async {
    StockInfo info = StockInfo();
    info.id = Uuid().v4();
    curretnId =  info.id;
    info.productID = widget.info;
    info.stockDate = selectedDate;
    info.balance = quantity;
    info.quantity = quantity;
    info.remake = remarks.text;
    info.action = false;


    //Assume we get the latest data.
    ProductInfo temp = await DatabaseService().getProduct(widget.info);

    info.unitPrice = (temp.avgPrice.toDouble() / 100.0).toString();
    info.totalPrice = ((temp.avgPrice * quantity).toDouble() / 100.0).toString();

    //await DatabaseService().addProduct(widget.info);
    await DatabaseService().addStock(info);
    MasterData.instance.callSetState("stockUpdate");
    //Navigator.pop(context);
    //info.unitPrice = test.toString();
    //Money test = Money.fromInt(1000, Currency.create('USD', 2));
    //print(test.toString());
    //Money test1 = Money.parse(test.toString(), Currency.create('USD', 2));
    //print(test1.toString());
    //info.unitPrice = ;

    var temp1 = await _controller.toPngBytes();
    WithdrawInfo wInfo = WithdrawInfo(id: info.id );
    wInfo.signature = temp1.toString();
    wInfo.received = this.received.text;
    wInfo.drawBy = this.drawBy.text;

    await DatabaseService().addStock2(info,wInfo);

  }

  Future<void> pdfView(BuildContext context) async {


    StockInfo sInfo = await DatabaseService().getStockByID(curretnId);
    WithdrawInfo wInfo = await DatabaseService().getWinfoByStockID(sInfo.id);
    return showDialog(
        context: context,
        builder: (context) {
          return PdfView(sInfo: sInfo,wInfo: wInfo,);
        });
  }




  @override
  Widget build(BuildContext context) {


    DateFormat df = DateFormat("dd MMMM yyyy");
    String contentText = "Withdraw " + widget.info;

    return Container(
      width: 500,
      height: 300,
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 50),
        backgroundColor: backgroundColor,
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: primaryFontColour),
              borderRadius: BorderRadius.all(Radius.circular(
                  5.0) //                 <--- border radius here
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(contentText,
                  style: primaryFont(primaryFontColour,
                      size: 13, weight: 1)),
            )),
        content: SingleChildScrollView(
          child: Container(
            width: 500,
            height: 600,
            child: Column(
              children: [
                Card(
                  color: HexColor.fromHex("#292929"),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today,
                            color: HexColor.fromHex("#979798"), size: 15),
                        SizedBox(width: 20),
                        TextButton(
                            onPressed: () async {
                              final DateTime picked =
                              await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101));
                              if (picked != null &&
                                  picked != selectedDate)
                                setState(() {
                                  selectedDate = picked;
                                  print("selectedDate is: " +
                                      selectedDate.toString());
                                });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Text(
                                  df.format(selectedDate).toString(),
                                  style: primaryFont(
                                      HexColor.fromHex("#979798"),
                                      size: 13,
                                      weight: 0)),
                            ))
                      ],
                    ),
                  ),
                ),
                inputQuantity(context),
                //inputPrice(context),
                Divider(
                  color: HexColor.fromHex("#979798"),
                ),
                inputText("Withdrawn by:", this.drawBy,1, context),
                inputText("Received by :", this.received,1, context),
                Divider(
                  color: HexColor.fromHex("#979798"),
                ),
                inputTotalPrice(context),
                inputText("Remark: ",this.remarks,2,context),
                signature(),
              ],
            ),
          ),
        ),
        actions: <Widget>
        [
            TextButton(onPressed:() async{
              //pdfView(context);
             await addNewStock();
             await pdfView(context);
              Navigator.pop(context);
            }, child: Text("PdfPreview"))
        ],
      ),
    );
  }
}
