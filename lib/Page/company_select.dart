import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Page/ProuductSelect.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class CompanySelect extends StatefulWidget {

  static const String company = '/company';

  @override
  _CompanySelectState createState() => _CompanySelectState();
}

class _CompanySelectState extends State<CompanySelect> {

  Future addNewCompany() async
  {
    CompanyInfo info = CompanyInfo();
    info.id = Uuid().v4();
    info.location = "city-hall";
    info.companyStartDate = DateTime.now();
    info.name = getRandString(10);
    await DatabaseService().addCompany(info);
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> companies = ["Trisome", "Trutorq", "Posiwell", "Trugears"];
    return Container(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Column(children: [
                Text("Select Company",
                    style: TextStyle(fontSize: 50 ,color: HexColor.fromHex("#121212"))),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: StreamBuilder<List<CompanyInfo>>(
                    stream: DatabaseService().getAllCompany(),
                    builder: (context, snapshot) {
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
                                onTap: () { Navigator.pushNamed(
                                  context,
                                  ProductInfoSelect.route,
                                  arguments: ScreenArguments(
                                    data.name,
                                  ),
                                );},
                                child: Center(
                                  child: Text(data.name,
                                      style: GoogleFonts.robotoCondensed(
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              color: HexColor.fromHex("dbd8e3")))),
                                ),
                              ));
                        }).toList(),
                      );
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
                        onTap:addNewCompany, // button pressed
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
              ]),
            )));
  }
}
