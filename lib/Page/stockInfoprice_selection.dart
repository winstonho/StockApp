import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/model/StockInfo.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class StockInfoPriceSelect extends StatefulWidget {

  static const String route = '/stockinfoprice';
  @override
  _ProductInfoSelectSelectState createState() => _ProductInfoSelectSelectState();
}

class _ProductInfoSelectSelectState extends State<StockInfoPriceSelect> {

  ProductInfo productInfo;
  bool isSort = true;
  int coloumIndex = 0;
  List<StockInfo> list;
  int selectedIndex = 0;
  Future addNewStock() async
  {

    StockInfo info = StockInfo();
    info.id = Uuid().v4();
    info.productID = productInfo.id;
    info.stockDate = DateTime.now();
    info.balance = Random.secure().nextInt(10);
    info.quantity = Random.secure().nextInt(10);
    info.unitPrice = Random.secure().nextDouble() * 100;
    await DatabaseService().addStock(info);
    print("testing");
  }

  getRowsStock() {
    final rows2 = new List.generate(list.length, (int index) => new DataRow(
        onSelectChanged: (val) {
          print("temp");
          setState(() {
            if(selectedIndex != index)
          selectedIndex = index;
            else
              selectedIndex = -1;
        });},
        selected: selectedIndex == index,
        cells: [
          new DataCell(new Text(list[index].stockDate.toString(), style: new TextStyle(color: Colors.white))),
          new DataCell(new Text(list[index].balance.toString(), style: new TextStyle(color: Colors.white))),
          new DataCell(new Text(list[index].quantity.toString(), style: new TextStyle(color: Colors.white))),
        ]));
    return rows2;
  }

  void sort()
  {
    switch (coloumIndex)
    {
      case 0:
        if(isSort){
          list.sort((a, b) => b.stockDate.compareTo(a.stockDate));
        } else {
          list.sort((a, b) => a.stockDate.compareTo(b.stockDate));
        }
        break;
      case 1:
        if(isSort){
          list.sort((a, b) => b.balance.compareTo(a.balance));
        } else {
          list.sort((a, b) => a.balance.compareTo(b.balance));
        }
        break;
      case 2:
        if(isSort){
          list.sort((a, b) => b.quantity.compareTo(a.quantity));
        } else {
          list.sort((a, b) => a.quantity.compareTo(b.quantity));
        }
        break;

      default:
        break;

    }
  }

  Widget getStockView()
  {
    return Center(
        child: DataTable(
            onSelectAll: (b) {},
            showCheckboxColumn :true,
            sortColumnIndex: coloumIndex,
            sortAscending: isSort,
            columns: <DataColumn>[
              DataColumn(
                label: Text("Date"),
                numeric: true,
                onSort: (i, b) {
                  print("$i $b");
                  setState(() {
                    coloumIndex = i;
                    isSort = !isSort;

                  });
                },
              ),
              DataColumn(
                label: Text("balance"),
                numeric: true,
                onSort: (i, b) {
                  print("$i $b");
                  setState(() {
                    coloumIndex = i;
                    isSort = !isSort;
                  });
                },
              ),
              DataColumn(
                label: Text("quantity"),
                numeric: true,
                onSort: (i, b) {
                  print("$i $b");
                  setState(() {
                    coloumIndex = i;
                    isSort = !isSort;

                  });
                },
              ),
            ],
            rows: getRowsStock()),
    );
  }

  Widget getAllStock()
  {
    return StreamBuilder<List<StockInfo>>(
        stream: DatabaseService().getAllStock(productInfo.id),
        builder: (context, snapshot) {
          if(snapshot.hasError)return Text(snapshot.error.toString());
          if(!snapshot.hasData)return Container();
          list = snapshot.data;
          sort();
          print(isSort);
          return getStockView();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductInfo args =
    ModalRoute.of(context).settings.arguments as ProductInfo;
    productInfo = args;

    var size = MediaQuery.of(context).size;
    return Container(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Column(children: [
                Text("Select stock from product : "+  productInfo.productName,
                  style: primaryFont(primaryFontColour, size: 40, weight: 1)),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: StreamBuilder<Object>(
                      stream: DatabaseService().stockCollection.stream,
                      builder: (context, snapshot) {
                        return getAllStock();
                      }
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 100,
                    height: 30,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor.fromHex("#352f44"), // button color
                      child: InkWell(
                        splashColor:HexColor.fromHex("#352f44").withOpacity(0.2), // splash color
                        onTap: addNewStock, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios_outlined, size: 10,
                                color: HexColor.fromHex("dbd8e3")), // icon
                            Text("Add",
                                style: GoogleFonts.robotoCondensed(
                                    textStyle: TextStyle(fontSize: 15, color: HexColor.fromHex("dbd8e3")))), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 100,
                    height: 30,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor.fromHex("#352f44"), // button color
                      child: InkWell(
                        splashColor:HexColor.fromHex("#352f44").withOpacity(0.2), // splash color
                        onTap:(){Navigator.pop(context);}, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios_outlined, size: 10,
                                color: HexColor.fromHex("dbd8e3")), // icon
                            Text("Back",
                                style: GoogleFonts.robotoCondensed(
                                    textStyle: TextStyle(fontSize: 15, color: HexColor.fromHex("dbd8e3")))), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            )));
  }
}
