
import 'package:flutter/material.dart';
import 'package:flutter_app/Page/CompanySelect.dart';

import 'package:flutter_app/Service/AuthService.dart';
import 'package:flutter_app/model/Myuser.dart';
import 'package:flutter_app/widgets/constant.dart';



class LoginPage extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginPageState createState() => new _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final AuthServiceDesktop _authService = AuthServiceDesktop();
  String email;
  String password;
  String error;
  bool _loading = false;

  final forgotEmailController = TextEditingController();
  FocusNode passwordFocusNode = new FocusNode();

  bool obscureText = true;

  final emailFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget passwordForm() {

    return TextFormField(
      focusNode: passwordFocusNode,
      onChanged: (val) => setState(() => password = val),
      decoration: InputDecoration(
          suffixIcon: IconButton(
            alignment: Alignment(2.0, 2.0),
            icon: Icon(
              // Based on passwordVisible state choose the icon
              obscureText ? Icons.visibility_off : Icons.visibility,
              color:  Color(0xff454b53),
              size: 15,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
          fillColor: Color(0xff2a2b2e),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24)),
          labelText: 'Password',
          labelStyle: TextStyle(
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.bold,
              color: /*passwordFocusNode.hasFocus ?  HexColor("876A36"):*/ Colors
                  .grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54))),
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceSansPro'),
      obscureText: obscureText,
    );
  }

  Widget emailForm() {
    return TextFormField(
      onChanged: (val) => setState(() => email = val),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24)),
        labelText: 'Email',
        labelStyle: TextStyle(
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      ),
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceSansPro'),
    );
  }

  String checkEmail(String val) {
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

  void logIn() async {
    setState(() => _loading = true);

    if (email == null || password == null) {
      setState(() {
        error = "email or password has no value";
        _loading = false;
      });
      return;
    }
    dynamic result = await _authService.signInWithEmail(email, password);
    if (result is String || result == null) {
      setState(() {
        error = result;
        _loading = false;
      });
    }
    else if(result is MyUser)
    {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(CompanySelect.company, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {



    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: kPrimaryColor,
        body: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                Container(
                  child: Center(
                   child: Text(appTitle, style: TextStyle(color: kTextColor,
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold)),
                    ),
                ),
                Container(
                    padding:
                    EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        emailForm(),
                        SizedBox(height: 20.0),
                        passwordForm(),
                        SizedBox(height: 10.0),
                        if (error != null) ...{
                          Text(error,
                              style: TextStyle(
                                  color: Colors.red, fontSize: 14)),
                        },
                        SizedBox(height: 40.0),
                        Container(
                          height: 40.0,
                          child: GestureDetector(
                            onTap: logIn,
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              shadowColor: Color(0xff1a1a1c),
                              color: Color(0xff454b53),
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'LOGIN',
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
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to ' + appTitle + "?",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Color(0xff7C899C),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}