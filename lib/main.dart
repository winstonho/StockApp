import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Page/PdfView.dart';
import 'package:flutter_app/Page/signup_page.dart';
import 'package:flutter_app/Page/stockInfoprice_selection.dart';
import 'package:flutter_app/Page/ProductSelect.dart';
import 'package:flutter_app/Page/CompanySelect.dart';
import 'package:flutter_app/Page/Login.dart';
import 'package:flutter_app/widgets/constant.dart';


import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:firedart/firedart.dart';

const apiKey = 'AIzaSyAMjuWzqm9dFN5nZ7VNORjqd6CrHMxx9pQ';
const projectId = 'red-ace-282812';
const email = 'you@server.com';
const password = '123456';


void main() async{
  FirebaseAuth.initialize(apiKey, VolatileStore());
  Firestore.initialize(projectId);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello World',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColor,
        // fontFamily: "Montserrat",
        highlightColor: kPrimaryColor,
      ),
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (context) => LoginPage(),
        SignUpPage.route : (context) => SignUpPage(),
        CompanySelect.company : (context) => CompanySelect(),
        ProductInfoSelect.route : (context) => ProductInfoSelect(),
        StockInfoPriceSelect.route : (context) => StockInfoPriceSelect(),
        PdfView.route : (context) => PdfView()
        //GamePage.route: (context) => GameStartPage(),
        //'/signup'     : (context) => new SignupPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  MyHomePage();
  final String title = "testing";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    // Monitor sign-in state
    auth.signInState.listen((state) => print("Signed ${state ? "in" : "out"}"));
  }

  void _incrementCounter() async {

    var auth = FirebaseAuth.instance;
    // Sign in with user credentials
    var user  = await auth.signIn("gg","dd");
    print(user);
    // Get user object
    //var user = await auth.getUser();
    //print(user);

    //var ref = Firestore.instance.collection('test');

    //await ref.document("testing").set({"gg": 1});

    final pdf = pw.Document();


    final font = await rootBundle.load("assets/Montserrat-Regular.ttf");
    final ttf =  pw.Font.ttf(font);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Hello World!',style: pw.TextStyle(font: ttf, fontSize: 40)),
        ),
      ),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
