import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/StockInfo.dart';

import 'package:flutter_app/widgets/constant.dart';
import 'package:intl/intl.dart';

import 'package:money2/money2.dart';
import 'package:uuid/uuid.dart';

class AddForm extends StatefulWidget {
  final ProductInfo info;

  AddForm({this.info});

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  DateTime selectedDate = DateTime.now();

  int quantity = 0;
  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);
  String price;
  TextEditingController remarks = TextEditingController();
  TextEditingController drawBy = TextEditingController();
  TextEditingController received = TextEditingController();
  String unitPrice = '0.00';
  bool priceValid = true;
  bool quantityValid = true;
  Money unitPrice_m;
  String newString = r'10.25';

  Future addNewStock() async {
    StockInfo info = StockInfo();
    info.id = Uuid().v4();
    info.productID = widget.info.id;
    info.stockDate = selectedDate;
    info.balance = quantity;
    info.quantity = quantity;
    info.remake = remarks.text;
    info.action = true;
    info.unitPrice = unitPrice;

    //Assume we get the latest data.
    ProductInfo temp = await DatabaseService().getProduct(widget.info.id);


    await DatabaseService().addProduct(widget.info);
    await DatabaseService().addStock(info);
    MasterData.instance.callSetState("stockUpdate");
    Navigator.pop(context);
    Navigator.pop(context);
    //info.unitPrice = test.toString();
    //Money test = Money.fromInt(1000, Currency.create('USD', 2));
    //print(test.toString());
    //Money test1 = Money.parse(test.toString(), Currency.create('USD', 2));
    //print(test1.toString());
    //info.unitPrice = ;


    await DatabaseService().addStock(info);

  }

  Widget inputText(String label, TextEditingController value, int maxLine,
      BuildContext context) {
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
        minLines: 5,
        maxLines: 10,
        inputFormatters: [
          new LengthLimitingTextInputFormatter(512),
        ],
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
      height: 65,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (!RegExp(r'[0-9]+.[0-9][0-9]$').hasMatch(value))
                      return 'Invalid formatting';
                  },
                  onChanged: (value) {
                    setState(() {
                      if (!RegExp(r'[0-9]+.[0-9][0-9]$').hasMatch(value)) {
                        priceValid = false;
                      } else {
                        priceValid = true;
                        unitPrice = value;
                      }
                    });
                  },
                  decoration: formDecoration('Unit Price'),
                  initialValue: '0.00',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputTotalPrice(BuildContext context) {
    final sgd = Currency.create('SGD', 2);

    if (priceValid) {
      unitPrice_m = sgd.parse(r'$' + unitPrice);
    }
    return Container(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text("Total Price:", style: style_),
            Spacer(),
            Text((unitPrice_m * quantity).toString(), style: style_)
          ],
        ),
      ),
    );
  }

  Widget inputQuantity(BuildContext context) {
    return Container(
      height: 60,
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
                  decoration: formDecoration('Quantity'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == '' || int.parse(value) <= 0)
                      return 'Please input a value more than 0';
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value == '')
                        quantityValid = false;
                      else {
                        int v = int.parse(value);
                        if (v > 0) {
                          quantityValid = true;
                          quantity = int.parse(value);
                        } else
                          quantityValid = false;
                      }
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

  Widget confirmAddStock(BuildContext context) {
    AlertDialog dialog = AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 50),
        backgroundColor: backgroundColor,
        title: Text("Add stock",
            style: primaryFont(primaryFontColour, size: 15, weight: 1)),
        content: Text("Are you sure you want to add the following stock?",
            style: primaryFont(primaryFontColour, size: 13, weight: 0)),
        actions: [
          renderButton(context, "Add", fn: addNewStock),
          renderButton(context, "Cancel", fn: () {
            Navigator.pop(context);
          })
        ]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat df = DateFormat("dd MMMM yyyy");
    String contentText = "Add " + widget.info.id;

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
                    style: primaryFont(primaryFontColour, size: 13, weight: 1)),
              )),
          content: SingleChildScrollView(
            child: Container(
              width: 500,
              height: 400,
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
                                final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101));
                                if (picked != null && picked != selectedDate)
                                  setState(() {
                                    selectedDate = picked;
                                  });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Text(df.format(selectedDate).toString(),
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
                  inputPrice(context),
                  Divider(
                    color: HexColor.fromHex("#979798"),
                  ),
                  inputTotalPrice(context),
                  inputRemarks(context),
                ],
              ),
            ),
          ),
          actions: [
            (priceValid && quantityValid)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor.fromHex("#313131"),
                        // background
                        onPrimary: Colors.white),
                    child: Text("Add", style: primaryFont(primaryFontColour)),
                    onPressed: () {
                      confirmAddStock(context);
                    },
                  )
                : Text("Add", style: primaryFont(primaryFontColour)),
            renderButton(context, "Back", fn: () {
              Navigator.pop(context);
            }),
          ],
        ));
  }
}
