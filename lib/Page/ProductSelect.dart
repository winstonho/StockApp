import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Page/StockView.dart';

import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/model/StockInfo.dart';
import 'package:flutter_app/widgets/WithdrawForm.dart';
import 'package:flutter_app/widgets/AddForm.dart';
import 'package:flutter_app/widgets/constant.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:money2/money2.dart';

class ProductInfoSelect extends StatefulWidget {
  static const String route = '/productInfo';

  @override
  _ProductInfoSelectSelectState createState() =>
      _ProductInfoSelectSelectState();
}

class _ProductInfoSelectSelectState extends State<ProductInfoSelect> {
  String companyName = "";
  bool withPrices = false;
  int selectedIndex = 0;

  List<ProductInfo> list;
  int columnIndex = 0;

  bool isSort = true;
  ProductInfo productInfo;

  DateTime selectedDate = DateTime.now();
  int quantity = 0;
  int balance = 0;
  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);
  String price;
  String remarks;


  Future<void> viewStockRecord(ProductInfo productID) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: backgroundColor,
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: primaryFontColour),
                    borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(productID.id.toString(),
                        style: primaryFont(primaryFontColour,
                            size: 20, weight: 1)),
                  ),
                ),
                content: StockView(productID),
                actions: <Widget>[
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: HexColor.fromHex("#313131"),
                          // background
                          onPrimary: Colors.white),
                      label: Text("Add", style: primaryFont(primaryFontColour)),
                      icon: Icon(Icons.add, color: primaryFontColour, size: 13),
                      onPressed: () {
                        AddForm1(productID, context);
                      }),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: HexColor.fromHex("#313131"),
                          // background
                          onPrimary: Colors.white),
                      label: Text("Withdraw",
                          style: primaryFont(primaryFontColour)),
                      icon: Icon(Icons.remove,
                          color: primaryFontColour, size: 13),
                      onPressed: () {
                        WithdrawForm1(productID, context);
                      }),
                  renderButton(context, "Back", fn: () {
                    Navigator.pop(context);
                  }),
                ],
              );
            },
          );
        });
  }

  /************************* Product Stuff ************************************/
  Future addNewProduct() async {
    ProductInfo info = ProductInfo();
    info.id = Uuid().v4();
    info.company = companyName;
    info.productDate = DateTime.now();
    info.productName = getRandString(10);
    await DatabaseService().addProduct(info);
  }

  getProductRows() {
    final sgd = Currency.create('SGD', 2);
    final rows = List.generate(
        list.length,
        (int index) => new DataRow(selected: false, cells: [
              DataCell(Row(children: [
                Text(list[index].id.toString()),
                SizedBox(width: 20),
                IconButton(
                    splashRadius: 15,
                    onPressed: () {
                      viewStockRecord(list[index]);
                    },
                    icon: Icon(Icons.my_library_add_outlined),
                    iconSize: 15,
                    color: HexColor.fromHex("979798"))
              ])),
              DataCell(Text(list[index].productName.toString(),
                  style: primaryFont(primaryFontColour, size: 15))),
              DataCell(Text(list[index].totalQuantity.toString(),
                  style: primaryFont(primaryFontColour, size: 15))),
              DataCell( Text(list[index].totalQuantity == 0 ? "0.00" :
                  Money.fromInt(list[index].avgPrice,sgd).toString(),
                  style: primaryFont(primaryFontColour, size: 15))),
            ]));
    return rows;
  }

  Widget generateProductTable(BuildContext context) {
    return StreamBuilder<List<ProductInfo>>(
        stream: DatabaseService().getAllProduct(companyName),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (!snapshot.hasData) return Container();
          list = snapshot.data;
          return Center(
            child: DataTable(
                onSelectAll: (b) {},
                showCheckboxColumn: false,
                sortColumnIndex: columnIndex,
                sortAscending: isSort,
                horizontalMargin: MediaQuery.of(context).size.width * 0.1,
                headingTextStyle:
                    primaryFont(primaryFontColour, size: 15, weight: 1),
                dataTextStyle:
                    primaryFont(primaryFontColour, size: 15, weight: 0),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text("Product ID", textAlign: TextAlign.left),
                    onSort: (i, b) {
                      print("$i $b");
                      setState(() {
                        columnIndex = i;
                        isSort = !isSort;
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("Product Name"),
                    onSort: (i, b) {
                      print("$i $b");
                      setState(() {
                        columnIndex = i;
                        isSort = !isSort;
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("Quantity"),
                    numeric: true,
                    onSort: (i, b) {
                      print("$i $b");
                      setState(() {
                        columnIndex = i;
                        isSort = !isSort;
                      });
                    },
                  ),
                  DataColumn(
                    label: Text("Average Cost"),
                    numeric: true,
                    onSort: (i, b) {
                      print("$i $b");
                      setState(() {
                        columnIndex = i;
                        isSort = !isSort;
                      });
                    },
                  ),
                ],
                rows: getProductRows()),
          );
        });
  }


  Widget inputRemarks(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 600,
        child: Card(
          color: HexColor.fromHex("#292929"),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: style_,
              minLines: 1,
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(256),
              ],
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                hintText: 'Remarks:',
                hintStyle: style_,
              ),
            ),
          ),
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
              SizedBox(
                width: 500,
                child: TextFormField(
                  style: style_,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
    print("Quantity: " + quantity.toString());
    final sgd = Currency.create('SGD', 2);
    final unitPrice = sgd.parse(r'$10.25');

    return Container(
      height: 50,
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
              SizedBox(
                width: 500,
                child: TextFormField(
                  style: style_,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
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
                      print("Quantity is: " + quantity.toString());
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

  Future<void> WithdrawForm1(ProductInfo info, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return WithdrawForm(info: info.id);
        });
  }

  Future<void> AddForm1(ProductInfo info, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddForm(info: info);
        });
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args =
        ModalRoute.of(context).settings.arguments as ScreenArguments;
    companyName = args.info;
    TextStyle s = primaryFont(primaryFontColour, size: 15, weight: 0);
    TextStyle sBold = primaryFont(primaryFontColour, size: 22, weight: 1);
    //var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(companyName, style: sBold),
          backgroundColor: HexColor.fromHex("#292929"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: StreamBuilder<Object>(
                stream: DatabaseService().productCollection.stream,
                builder: (context, snapshot) {
                  return generateProductTable(context);
                }),
          ),
        ));
  }
}
