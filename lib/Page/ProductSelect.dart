import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:flutter_app/widgets/form.dart';
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

  Future addNewProduct() async {
    ProductInfo info = ProductInfo();
    info.id = Uuid().v4();
    info.company = companyName;
    info.productDate = DateTime.now();
    info.productName = getRandString(10);
    await DatabaseService().addProduct(info);
    print("testing");
  }

  //Form Date

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
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Product ID", style: s),
      )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Product Name", style: s),
      )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Quantity", style: s),
      )),
      (withPrices)
          ? TableCell(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Average Cost", style: s),
            ))
          : null
    ]);
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
              subtitle:
              Flexible(
                child: TextFormField(
                  style: style_,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    hintStyle: style_,
                  ),
                ),
              )
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
                          borderSide: BorderSide(
                              color: Colors.red
                          )
                      )
                  ),
                  onChanged: (value)
                  {
                    setState(() {
                      quantity = int.parse(value);
                    });
                  }
                  ,
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

  TableRow GenerateRow(BuildContext context, bool withPrices) {
    TextStyle s = primaryFont(primaryFontColour, size: 15, weight: 0);
    TextStyle sBold = primaryFont(primaryFontColour, size: 15, weight: 1);

    ProductInfo p = ProductInfo();
    p.id = "A001";
    p.productName = "Apples";
    p.totalQuantity = 5;

    final sgd = Currency.create('SGD', 2);
    final averagePrice  = sgd.parse(r'$10.25');
    return TableRow(children: [
      TableCell(
          child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(p.id, style: sBold),
        ),
        Spacer(),
        Container(
          height: 30,
          child: IconButton(
            onPressed: () {
              showInformationDialog(context);
            },
            splashColor: Colors.white,
            splashRadius: 15,
            icon: Icon(Icons.my_library_add_outlined,
                size: 15, color: primaryFontColour),
          ),
        )
      ])),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(p.productName, style: s),
      )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(p.totalQuantity.toString(), style: s),
      )),
      (withPrices)
          ? TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((averagePrice /4).toString(), style: s),
              ),
            )
          : null
    ]);
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
            child: Table(
              border: TableBorder.symmetric(
                  inside: BorderSide(width: 2, color: primaryFontColour),
                  outside: BorderSide(width: 3, color: primaryFontColour)),
              children: [
                GenerateHeader(true),
                for (int i = 0; i < 3; ++i) GenerateRow(context, true)
              ],
            ),
          ),
        ));
  }
}
