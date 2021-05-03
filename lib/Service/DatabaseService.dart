import 'dart:io';
import 'package:firedart/firedart.dart';
import 'package:flutter_app/model/CompanyInfo.dart';
import 'package:flutter_app/model/MasterData.dart';
import 'package:flutter_app/model/Myuser.dart';
import 'package:flutter_app/model/ProductInfo.dart';
import 'package:flutter_app/model/StockInfo.dart';


//import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class DatabaseService {
  final CollectionReference userCollection = Firestore.instance.collection("user");
  final CollectionReference companyCollection = Firestore.instance.collection("company");
  final CollectionReference productCollection = Firestore.instance.collection("product");
  final CollectionReference stockCollection = Firestore.instance.collection("stock");

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

  List<CompanyInfo> _companyInfoFromSnapshot(List<Document> snapshot) {
    print(snapshot);
    return snapshot.map((doc) {
      print("testing124");
      CompanyInfo temp = CompanyInfo();
      temp.fromJson(doc.map);
      return temp;
    }).toList();
  }

  List<ProductInfo> _productInfoFromSnapshot(List<Document> snapshot) {
    return snapshot.map((doc) {
      ProductInfo temp = ProductInfo();
      temp.fromJson(doc.map);
      return temp;
    }).toList();
  }

  List<StockInfo> _stockInfoFromSnapshot(List<Document> snapshot) {
    return snapshot.map((doc) {
      StockInfo temp = StockInfo();
      temp.fromJson(doc.map);
      return temp;
    }).toList();
  }

  Stream<List<ProductInfo>> getAllProduct(String companyName) {
    return productCollection.where("company", isEqualTo: companyName ).get().asStream().map(_productInfoFromSnapshot);
  }

  Future addProduct(ProductInfo info) async{
    return await productCollection.document(info.id).set(info.toJson());
  }

  Stream<List<CompanyInfo>> getAllCompany() {
    return companyCollection.stream.map(_companyInfoFromSnapshot);
  }
   Future addCompany(CompanyInfo info) async{
     return await companyCollection.document(info.id).set(info.toJson());
  }

  Stream<List<StockInfo>> getAllStock(String productID) {
    return stockCollection.where("productID", isEqualTo: productID ).get().asStream().map(_stockInfoFromSnapshot);
  }


  Future addStock(StockInfo info) async{
    return await stockCollection.document(info.id).set(info.toJson());
  }


}