import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Page/StockView.dart';

import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
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
  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);
  String price;
  String remarks;

  /************************* Stock Stuff ************************************/

  List<StockInfo> stockList;
  int stockColumnIndex = 0;
  bool isStockSort = true;
  int selectedStockIndex = 0;
  StockInfo stockInfo;

  DataCell makeStockCell(String value) {
    if (value == null) value = "-";

    return DataCell(
        Text(value, style: primaryFont(primaryFontColour, size: 15)));
  }

  getStockRows() {
    DateFormat df = DateFormat("dd MMMM yyyy");
    print(stockList[0].remake);
    final rows = List.generate(
        stockList.length,
        (int index) => new DataRow(selected: false, cells: [
              makeStockCell(df.format(stockList[index].stockDate).toString()),
              (stockList[index].action)
                  ? makeStockCell(stockList[index].quantity.toString())
                  : makeStockCell(""),
              (stockList[index].action)
                  ? makeStockCell("")
                  : makeStockCell(stockList[index].quantity.toString()),
              makeStockCell(stockList[index].balance.toString()),
              makeStockCell(stockList[index].unitPrice.toString()),
              makeStockCell(stockList[index].totalPrice.toString()),
              (stockList[index].remake == null)
                  ? makeStockCell(stockList[index].remake)
                  : makeStockCell(""),
            ]));

    print(stockList);
    return rows;
  }

  Widget generateStockTable(String id) {
    print("ID is: " + id);
    return StreamBuilder<List<StockInfo>>(
        stream: DatabaseService().getAllStock(id),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (!snapshot.hasData) return Container();
          stockList = snapshot.data;

          return DataTable(
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
                  label: Text("Date", textAlign: TextAlign.left),
                ),
                DataColumn(
                  label: Text("In"),
                ),
                DataColumn(
                  label: Text("Out"),
                ),
                DataColumn(
                  label: Text("Balance"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Unit Price"),
                  numeric: false,
                ),
                DataColumn(
                  label: Text("Total"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Remarks"),
                ),
              ],
              rows: getStockRows());
        });
  }

  Future<void> viewStockRecord(ProductInfo productID) {
    return showDialog(
        context: context,
        builder: (context) {
          String contentText = "Content of Dialog";
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
                    child: Text(productID.toString(),
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
                        WithdrawForm1(productID.id, context);
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
              DataCell(Text(list[index].avgPrice.toString(),
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








  Future<void> WithdrawForm1(String info, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return WithdrawForm(info: info);
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
