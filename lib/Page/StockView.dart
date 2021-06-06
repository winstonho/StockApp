import 'package:flutter/material.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/StockInfo.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:intl/intl.dart';


class StockView extends StatefulWidget {
  final ProductInfo info;

  StockView(this.info);
  @override
  _StockViewState createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {

  int columnIndex = 0;
  List<StockInfo> stockList;
  int stockColumnIndex = 0;
  bool isStockSort = true;
  int selectedStockIndex = 0;
  StockInfo stockInfo;
  bool isSort = true;
  var ref;

  void refrash()
  {
    updateProduct();
    setState(() {});
  }

  void updateProduct() async
  {
    print("testing update");
    int total = 0;
    List<StockInfo> info = await DatabaseService().getAllStock(widget.info.id).first;
   // ref.stream.listen((document){});
    info.forEach((element) { total += element.balance;});

    widget.info.totalQuantity = total;
    await DatabaseService().addProduct(widget.info);

    //ref.stream.listen(updateProduct);
  }

  @override
  void initState() {
    //print("testing");
    //print(widget.info.id);
    //ref  = DatabaseService().productCollection.document(widget.info.id);
    //ref.stream.listen(updateProduct);
    MasterData.instance.addSetState("stockUpdate", refrash);
    super.initState();
  }

  @override
  void dispose() {
    print("destory");
    MasterData.instance.removeSetState("stockUpdate");
    super.dispose();
  }


  DataCell makeStockCell(String value) {
    if (value == null) value = "-";

    return DataCell(
        Text(value, style: primaryFont(primaryFontColour, size: 15)));
  }

  getStockRows() {
    DateFormat df = DateFormat("dd MMMM yyyy");
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

  @override
  Widget build(BuildContext context) {
    return generateStockTable(widget.info.id);
  }
}
