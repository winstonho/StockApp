import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanySelect extends StatefulWidget {
  @override
  static const String company = '/company';

  _CompanySelectState createState() => _CompanySelectState();
}

class _CompanySelectState extends State<CompanySelect> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> companies = ["Trisome", "Trutorq", "Posiwell", "Trugears"];
    return Container(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: Column(children: [
              Text("Select Company",
                  style: TextStyle(color: HexColor.fromHex("#121212"))),
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: GridView.count(
                  childAspectRatio: 1,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 10,
                  children: companies.map((data) {
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
                            child: Text(data,
                                style: GoogleFonts.robotoCondensed(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        color: HexColor.fromHex("dbd8e3")))),
                          ),
                        ));
                  }).toList(),
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
                      onTap: () {}, // button pressed
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
            ])));
  }
}
