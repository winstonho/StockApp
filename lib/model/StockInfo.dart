import 'package:intl/intl.dart';

class StockInfo
{
  String id;
  bool action = false;
  String productID  = "gg";
  String remake  = "null";
  int  quantity  = 0;
  int balance = 0;
  String unitPrice   = "0.00";
  String totalPrice    = "0.00";
  DateTime stockDate =  new DateTime.now();


  StockInfo({this.id});

  String getIndex(int index)
  {
    switch(index)
    {
      case 0:
        return quantity.toString();
        break;
      case 1:
        return remake.toString();
        break;
      case 2:
        return balance.toString();
        break;
    }
  }

  String getDateTimeInYYMMDD()
  {

    return DateFormat("yyyy-MM-dd").format(stockDate);
  }

  Map<String, dynamic> toJson() =>
      {
        'id'          : id,
        'productID'   : productID,
        'quantity'    : quantity,
        'stockDate' : stockDate.toString(),
        'balance'     : balance,
        'unitPrice'   : unitPrice,
        'totalPrice'  : totalPrice,
        'remake'      : remake,
        'action'      : action
      };

  StockInfo fromJson ( Map<String, dynamic> json) {
    id = json['id'] as String;
    productID = json['productID'] as String;
    remake = json['remake'] as String;
    quantity = json['quantity'] as int;
    totalPrice = json['totalPrice'];
    balance = json['balance'];
    print(balance);
    stockDate = DateTime.parse(json['stockDate']);
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    action = json['action'];
    return this;
  }
}


class WithdrawInfo
{
  String id;
  String received = "";
  String drawBy = "";
  String signature = "";


  WithdrawInfo({this.id});



  Map<String, dynamic> toJson() =>
      {
        'id'          : id,
        'drawBy'    : drawBy,
        'received'    : received,
        'signature' : signature,
      };

  WithdrawInfo fromJson ( Map<String, dynamic> json) {
    id = json['id'] as String;
    received = json['received'] as String;
    drawBy = json['drawBy'] as String;
    signature = json['signature'] as String;
    return this;
  }
}
