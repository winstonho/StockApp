import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class ProductInfoSelect extends StatefulWidget {

  static const String route = '/productInfo';
  @override
  _ProductInfoSelectSelectState createState() => _ProductInfoSelectSelectState();
}

class _ProductInfoSelectSelectState extends State<ProductInfoSelect> {

  String companyName = "";
  Future addNewProduct() async
  {
    ProductInfo info = ProductInfo();
    info.id = Uuid().v4();
    info.company = companyName;
    info.productDate = DateTime.now();
    info.productName = getRandString(10);
    await DatabaseService().addProduct(info);
    print("testing");
  }

  Widget getAllProduct()
  {
    return StreamBuilder<List<ProductInfo>>(
        stream: DatabaseService().getAllProduct(companyName),
        builder: (context, snapshot) {
          if(snapshot.hasError)return Text(snapshot.error.toString());
          if(!snapshot.hasData)return Container();
          return GridView.count(
            childAspectRatio: 1,
            padding: EdgeInsets.only(left: 16, right: 16),
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 18,
            mainAxisSpacing: 10,
            children: snapshot.data.map((data) {
              return Material(
                  elevation: 10,
                  color: HexColor.fromHex("#352f44"),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    splashColor:
                    HexColor.fromHex("#352f44").withOpacity(0.2),
                    // splash color
                    onTap: () {},
                    child: Center(
                      child: Text(data.productName,
                          style: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: HexColor.fromHex("dbd8e3")))),
                    ),
                  ));
            }).toList(),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args =
    ModalRoute.of(context).settings.arguments as ScreenArguments;
    companyName = args.info;
    print(companyName);

    var size = MediaQuery.of(context).size;
    return Container(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Column(children: [
                Text("Select Product from company : "+ companyName ,
                    style: TextStyle(fontSize: 25,color: HexColor.fromHex("#121212"))),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: StreamBuilder<Object>(
                    stream: DatabaseService().productCollection.stream,
                    builder: (context, snapshot) {
                      return getAllProduct();
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
                        onTap: addNewProduct, // button pressed
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
