
import 'package:intl/intl.dart';

class ProductInfo
{
  String id;
  bool change = false;
  String company = "gg";
  int  totalQuantity  = 10;
  int totalPrice  = 0;
  int avgPrice   = 0;
  DateTime productDate =  new DateTime.now();
  String productName  = 'null';


  ProductInfo({this.id});

  String getDateTimeInYYMMDD()
  {

    return DateFormat("yyyy-MM-dd").format(productDate);
  }

  Map<String, dynamic> toJson() =>
      {
        'id'  : id,
        'company': company,
        'totalQuantity': totalQuantity,
        'productDate': productDate.toString(),
        'totalPrice' : totalPrice,
        'productName'  : productName,
        'avgPrice'  : avgPrice,
        'change' : change
      };

  ProductInfo fromJson ( Map<String, dynamic> json) {
    id = json['id'] as String;
    company = json['company'] as String;
    productName = json['productName'] as String;
    totalQuantity = json['totalQuantity'] as int;
    change = json['change'];
    totalPrice = json['totalPrice'];
    avgPrice = json['avgPrice'];
    productDate = DateTime.parse(json['productDate']);
    return this;
  }
}
