import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Page/Login.dart';
import 'package:flutter_app/Page/ProductSelect.dart';
import 'package:flutter_app/Service/AuthService.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/Util/Random.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/Route/ScreenArguments.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

  Future logout() async
  {
    await AuthServiceDesktop().signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginPage.route, (Route<dynamic> route) => false);
  }


  @override
  void initState() {
    MasterData.instance.init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // List<String> companies = ["Trisome", "Trutorq", "Posiwell", "Trugears"];
    return Container(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Select Company",
                      style:
                          primaryFont(primaryFontColour, size: 40, weight: 1)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: StreamBuilder<List<CompanyInfo>>(
                      stream: DatabaseService().getAllCompany(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        return AnimationLimiter(
                          child: GridView.count(
                            childAspectRatio: 1,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            crossAxisSpacing: 70,
                            mainAxisSpacing: 30,
                            children: snapshot.data.map((data) {
                              print(snapshot.data.indexOf(data));
                               int delay  = snapshot.data.indexOf(data) * 100;
                              return AnimationConfiguration.staggeredGrid(
                                position: 4,
                                duration: const Duration(milliseconds: 500),
                                delay:   Duration(milliseconds: delay),
                                columnCount: 4,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: Card(
                                      color: HexColor.fromHex("#252525"),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(data.name,
                                                  style: primaryFont(
                                                      primaryFontColour,
                                                      size: 15)),
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: HexColor
                                                                  .fromHex(
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
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                            primary:
                                                                HexColor.fromHex(
                                                                    "#313131"),
                                                            // background
                                                            onPrimary:
                                                                Colors.white),
                                                    child: Text(
                                                        "Stock (w prices)",
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
                                                        )
                                                        ,
                                                      );
                                                    })
                                              ])
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 8.0, top: 50, bottom: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: HexColor.fromHex("#313131"),
                          // background
                          onPrimary: Colors.white),
                      label:
                          Text('Logout', style: primaryFont(primaryFontColour)),
                      icon: Icon(Icons.arrow_back_ios,
                          size: 15, color: primaryFontColour),
                      onPressed: () {
                        displayDialog(context, "Confirm Logout",
                            "Are you sure you want to Logout?",fn:logout);
                      },
                    ),
                  ),
                )
              ]),
            )));
  }
}
