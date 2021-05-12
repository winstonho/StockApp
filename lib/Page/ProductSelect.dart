import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/model/StockInfo.dart';
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
    print(stockList[0].remake);
    final rows = List.generate(
        stockList.length,
        (int index) => new DataRow(selected: false, cells: [
              makeStockCell(stockList[index].stockDate.toString()),
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
                  numeric: true,
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

  Future<void> viewStockRecord(String productID) {
    return showDialog(
        context: context,
        builder: (context) {
          DateFormat df = DateFormat("dd MMMM yyyy");
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
                content: generateStockTable(productID),
                actions: <Widget>[
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: HexColor.fromHex("#313131"),
                          // background
                          onPrimary: Colors.white),
                      label: Text("Add", style: primaryFont(primaryFontColour)),
                      icon: Icon(Icons.add, color: primaryFontColour, size: 13),
                      onPressed: () {
                        AddForm(productID, context);
                      }),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: HexColor.fromHex("#313131"),
                          // background
                          onPrimary: Colors.white),
                      label: Text("Withdraw",
                          style: primaryFont(primaryFontColour)),
                      icon: Icon(Icons.remove,
                          color: primaryFontColour, size: 13)),
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
                      viewStockRecord(list[index].id.toString());
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  int quantity = 0;
  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);
  String price;
  String remarks;

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
    final sgd = Currency.create('SGD', 2);
    final unitPrice = sgd.parse(r'$10.25');

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

  Future<void> AddForm(String productID, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          DateFormat df = DateFormat("dd MMMM yyyy");
          String contentText = "Add " + productID;
          return StatefulBuilder(
            builder: (context, setState) {
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
                  content: Column(
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
                      inputPrice(context),
                      Divider(
                        color: HexColor.fromHex("#979798"),
                      ),
                      inputTotalPrice(context),
                      inputRemarks(context),
                    ],
                  ),
                  actions: <Widget>[],
                ),
              );
            },
          );
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
