import 'package:flutter_app/model/Myuser.dart';
import 'package:firedart/firedart.dart';

class MasterData {

  MasterData._privateConstructor();

  static final MasterData instance = MasterData._privateConstructor();
  CollectionReference _stockCollection = Firestore.instance.collection("stock");
  MyUser user = new MyUser(uid: null);

  Map<String,Function> _setStateFunction = new Map();
  bool googleSignIn = false;
  bool uploadImage = false;

  DateTime currentDate;
  DateTime endDate;

  void init()
  {
    //_stockCollection.stream.listen((event) {print("testing");event.forEach((element) {print(element);});});
  }
  void addSetState(String name,Function setStateFunction)
  {
    print(_setStateFunction);
    _setStateFunction[name] = setStateFunction;
  }


  void callSetState(String name)
  {
    if(_setStateFunction.containsKey(name))
    {
      _setStateFunction[name]();
    }
  }


  void removeSetState(String name)
  {
    if(_setStateFunction.containsKey(name))
    {
      _setStateFunction.remove(name);
    }
  }





}