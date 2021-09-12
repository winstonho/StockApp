import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/StockInfo.dart';

import 'package:flutter_app/widgets/constant.dart';
import 'package:intl/intl.dart';

import 'package:money2/money2.dart';
import 'package:nanoid/nanoid.dart';
import 'package:uuid/uuid.dart';

class AddProductForm extends StatefulWidget {
  final String comapnyName;

  AddProductForm({this.comapnyName});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  DateTime selectedDate = DateTime.now();

  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);

  String id = "";
  String name = "";

  bool idValid = false;
  bool nameValid = false;
  bool checkID = false;

  Future addNewStock() async {
    ProductInfo info = new ProductInfo();
    //info.id = Uuid().v4();
    info.id = id;
    info.company = widget.comapnyName;
    info.productDate = selectedDate;
    info.productName = name;
    await DatabaseService().addProduct(info);
    MasterData.instance.callSetState("productUpdate");
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget inputName(BuildContext context) {
    return Container(
      height: 65,
      child: Card(
        color: HexColor.fromHex("#292929"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  style: style_,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.length < 1) return 'name must not be empty';
                    return "";
                  },

                  onChanged: (value) {
                    setState(() {
                      if (value.length < 1) {
                        nameValid = false;
                      } else {
                        nameValid = true;
                        name = value;
                      }
                    });
                  },
                  decoration: formDecoration('Name'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputID(BuildContext context) {
    return Container(
      height: 65,
      child: Card(
        color: HexColor.fromHex("#292929"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  style: style_,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.length < 1) return 'name must not be empty';
                    else if(checkID) return 'id has been use';
                    return "";
                  },
                  onChanged: (value) async{
                    var temp  = await DatabaseService().checkProductGotUse(value);
                    this.checkID = temp.length > 0;
                    setState(() {
                      if (value.length < 1 || checkID) {
                        idValid = false;
                      } else {
                        idValid = true;
                        id = value;
                      }
                    });
                  },
                  decoration: formDecoration(id.length > 0 ? id : 'id'),
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
        title: Text("Add product",
            style: primaryFont(primaryFontColour, size: 15, weight: 1)),
        content: Text("Are you sure you want to add the following product?",
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
    String contentText = "Add " + widget.comapnyName;
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
                  inputName(context),
                  inputID(context),
                  Container(
                    height: 40.0,
                    child: GestureDetector(
                      onTap: () {
                        print("test");
                        setState(() {
                        id =  customAlphabet('1234567890abcdef', 10);;
                      });},
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        shadowColor: Color(0xff1a1a1c),
                        color: Color(0xff454b53),
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            'CREATE id',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            (this.nameValid && this.idValid)
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
