import 'package:flutter/material.dart';
import 'package:flutter_app/Page/CompanySelect.dart';

import 'package:flutter_app/Service/AuthService.dart';
import 'package:flutter_app/Service/DatabaseService.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/Myuser.dart';
import 'package:flutter_app/widgets/constant.dart';
import 'package:flutter_app/widgets/widgets.dart';


class SignUpPage extends StatefulWidget {
  static const String route = '/signup';
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}


class _SignUpPageState extends State<SignUpPage> {
  final AuthServiceDesktop _authService = AuthServiceDesktop();

  String email;
  String password;
  String passwordChk;
  String name;
  bool emailExists = false;
  String error;
  bool _loading = false;
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void signUp() async {
    setState(() {
      _loading = true;
    });
    if (emailFormKey.currentState.validate()) {



      dynamic result =
      await _authService.registerWithEmail(email, password, name);
      if (result is String) {
        error = result;
        setState(() {
          error = result;
          _loading = false;
        });
      }
      else if(result is MyUser)
        {
          MasterData.instance.user.email = email;
          MasterData.instance.user.name = this.name;
          MasterData.instance.user.accountType = 0;
          DatabaseService().updateUserData(MasterData.instance.user);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(CompanySelect.company, (Route<dynamic> route) => false);
        }



    }
    setState(() {
      _loading = false;
    });
  }

  String checkEmail(String val)  {

    if(emailExists)
    {
      emailExists = false;
      return "This email already exists";
    }

    if (val.isEmpty) {
      return "Enter an email";
    } else if (error != null && error.length > 0) {
      String temp = error;
      error = '';
      return temp;
    }
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val);
    if (!emailValid) {
      return "Please enter a valid email";
    }

    return null;
  }

  String validateNumber(String val) {
    if (val.isEmpty) {
      return "Enter mobile number";
    }
    if (val.length != 8) return "Invalid mobile number";

    if (error != null && error.length > 0) {
      String temp = error;
      error = '';
      return temp;
    }

    return null;
  }

  Widget emailForm() {

    return TextFormField(
        validator: checkEmail,
        onChanged: (val) => setState(() => email = val),
        decoration: DigiFightFormDecoration("Email address"),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'));
  }

  Widget passwordForm() {
    return TextFormField(
        validator: (val) =>
        val.length < 6 ? 'Enter an password length that 6 char long' : null,
        onChanged: (val) => setState(() => password = val),
        decoration: DigiFightFormDecoration("Password"),
        obscureText: true,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'));
  }

  Widget passwordConfirmationForm() {
    return TextFormField(
        validator: (val) =>
        val != password ? 'Password does not match' : null,
        onChanged: (val) => setState(() => passwordChk = val),
        decoration: DigiFightFormDecoration("Password confirmation"),
        obscureText: true,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'));
  }

  Widget registerEmail() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(children: <Widget>[
              Form(
                key: emailFormKey,
                child: Column(
                  children: <Widget>[
                    emailForm(),
                    SizedBox(height: 10.0),
                    passwordForm(),
                    SizedBox(height: 10.0),
                    passwordConfirmationForm(),
                  ],
                ),
              )
            ])));
  }

  Widget nameForm() {
    return TextFormField(
        validator: (val) => val.isEmpty ? 'Enter a name' : null,
        onChanged: (val) => setState(() => name = val),
        decoration: DigiFightFormDecoration("Name"),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: Text("Create User", style: TextStyle(color: kTextColor,
              fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                Container(
                    padding:
                    EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        registerEmail(),
                        SizedBox(height: 40.0),
                        Container(
                          height: 40.0,
                          child: GestureDetector(
                            onTap: signUp,
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              shadowColor: Color(0xff1a1a1c),
                              color: Color(0xff454b53),
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Create User',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            )));
  }
}