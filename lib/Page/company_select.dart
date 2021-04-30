import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Page/ProuductSelect.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';

import 'package:uuid/uuid.dart';

class CompanySelect extends StatefulWidget {
  static const String company = '/company';

  @override
  _CompanySelectState createState() => _CompanySelectState();
}

class _CompanySelectState extends State<CompanySelect> {
  Future addNewCompany() async {
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
                    style: TextStyle(
                        fontSize: 50, color: HexColor.fromHex("#121212"))),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: StreamBuilder<List<CompanyInfo>>(
                      stream: DatabaseService().getAllCompany(),
                      builder: (context, snapshot) {
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
                              elevation: 5,
                                color: HexColor.fromHex("#212121"),
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(data.name,
                                          style:
                                              primaryFont(primaryFontColour)),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style:
                                                    ElevatedButton.styleFrom(
                                                        primary:
                                                            HexColor.fromHex(
                                                                "#313131"),
                                                        // background
                                                        onPrimary:
                                                            Colors.white),
                                                child: Text("Stock",
                                                    style: primaryFont(
                                                        primaryFontColour,
                                                        size: 12)),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    ProductInfoSelect.route,
                                                    arguments:
                                                        ScreenArguments(
                                                      data.name,
                                                    ),
                                                  );
                                                }),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: HexColor.fromHex(
                                                      "#313131"), // background
                                                  onPrimary: Colors.white),
                                              child: Text("Stock (w prices)",
                                                  style: primaryFont(
                                                      primaryFontColour,
                                                      size: 12)),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  ProductInfoSelect.route,
                                                  arguments: ScreenArguments(
                                                    data.name,
                                                  ),
                                                );
                                              })
                                        ])
                                  ],
                                ));
                          }).toList(),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 100,
                    height: 30,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor.fromHex("#272727"), // button color
                      child: InkWell(
                        splashColor: HexColor.fromHex("#352f44")
                            .withOpacity(0.2), // splash color
                        onTap: addNewCompany, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios_outlined,
                                size: 10, color: HexColor.fromHex("dbd8e3")),
                            // icon
                            Text("Logout",
                                style: primaryFont(primaryFontColour)),
                            // text
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
