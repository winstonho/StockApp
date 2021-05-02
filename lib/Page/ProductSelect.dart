import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future addNewProduct() async {
    ProductInfo info = ProductInfo();
    info.id = Uuid().v4();
    info.company = companyName;
    info.productDate = DateTime.now();
    info.productName = getRandString(10);
    await DatabaseService().addProduct(info);
    print("testing");
  }

  Widget getAllProduct() {
    return StreamBuilder<List<ProductInfo>>(
        stream: DatabaseService().getAllProduct(companyName),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (!snapshot.hasData) return Container();
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
                    splashColor: HexColor.fromHex("#352f44").withOpacity(0.2),
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
        });
  }

  TableRow GenerateHeader(bool withPrices) {
    TextStyle s = primaryFont(primaryFontColour, size: 15, weight: 1);
    return TableRow(children: [
      TableCell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Product ID", style: s),
      )),
      TableCell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Product Name", style: s),
      )),
      TableCell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Quantity", style: s),
      )),
      (withPrices)
          ? TableCell(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Average Cost", style: s),
          ))
          : null
    ]);
  }

  TableRow GenerateRow(bool withPrices) {
    TextStyle s = primaryFont(primaryFontColour, size: 15, weight: 0);


    ProductInfo p = ProductInfo();
    p.id = "A001";
    p.productName = "Apples";
    p.totalQuantity = 5;

    final sgd = Currency.create('SGD', 2);
    final averagePrice = sgd.parse(r'$10.25');
    print("Average Cost: " + (averagePrice /4).toString());

    return TableRow(
        children: [
      TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(p.id, style: s),
          )),
      TableCell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(p.productName, style: s),
      )),
      TableCell(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(p.totalQuantity.toString(), style: s),
      )),
      (withPrices) ? TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("AverageCost", style: s),
        ),
      ) : null
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args =
        ModalRoute.of(context).settings.arguments as ScreenArguments;
    companyName = args.info;
    print(companyName);

    //var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
      padding: EdgeInsets.all(50),
      child: Table(
          border: TableBorder.symmetric(
              inside: BorderSide(width: 2, color: primaryFontColour),
              outside: BorderSide(width: 3, color:primaryFontColour)),
          children: [
            GenerateHeader(true),
            GenerateRow(true),
          ],
      ),
    ),
        ));
  }
}
