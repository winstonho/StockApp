import 'dart:io';
import 'package:firedart/firedart.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/Myuser.dart';


//import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class DatabaseService {
  final CollectionReference userCollection = Firestore.instance.collection("user");


  Future updateUserData(MyUser user) async {
    return await userCollection.document(user.uid).set(user.toJson());
  }

  Future<MyUser> getUserDataFromFireBase(String uid) async {
    var doc = await userCollection.document(uid).get();
    if (doc != null) {
      print(doc.map);
      MyUser obj = MyUser(uid: uid);
      obj.fromJson(doc.map);
      MasterData.instance.user = obj;
      return obj;
    }
    return null;
  }

  Future<List<Document>> checkEmailExists(String email) {
    return userCollection.where("email", isEqualTo: email).get();
  }

}