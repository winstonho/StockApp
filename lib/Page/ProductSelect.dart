import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Page/stockInfoprice_selection.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int columnIndex = 0;

  bool isSort = true;
  List<ProductInfo> list;
  int selectedIndex = 0;

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
        (int index) => new DataRow(
                cells: [
                  DataCell(Text(list[index].id.toString(),
                      style: primaryFont(primaryFontColour, size: 15))),
                  DataCell(Text(list[index].productName.toString(),
                      style: primaryFont(primaryFontColour, size: 15))),
                  DataCell(Text(list[index].totalQuantity.toString(),
                      style: primaryFont(primaryFontColour, size: 15))),
                ]));
    return rows;
  }

  Widget generateProductTable() {
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
                columns: <DataColumn>[
                  DataColumn(
                    label: Text("Product ID"),
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
                    label: Text("Product Name"),
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
                ],
                rows: getProductRows()),
          );
        });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  int quantity = 1;
  TextStyle style_ = primaryFont(primaryFontColour, size: 13, weight: 0);
  String price;
  String remarks;

  Widget inputRemarks(BuildContext context) {
    return Container(
      width: 300,
      child: Card(
        color: HexColor.fromHex("#292929"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              leading: Text("Remarks:", style: style_),
              subtitle: Flexible(
                child: TextFormField(
                  style: style_,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    hintStyle: style_,
                  ),
                ),
              )),
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
              Icon(Icons.calendar_today,
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
              Icon(Icons.calendar_today,
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

  Future<void> showInformationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          DateFormat df = DateFormat("dd MMMM yyyy");
          String contentText = "Content of Dialog";
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: backgroundColor,
                title: Text("Title of Dialog"),
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
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2015, 8),
                                      lastDate: DateTime(2101));
                                  if (picked != null && picked != selectedDate)
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
                                          size: 15,
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
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        contentText = "Changed Content of Dialog";
                      });
                    },
                    child: Text("Change"),
                  ),
                ],
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
                  return generateProductTable();
                }),
          ),
        ));
  }
}
