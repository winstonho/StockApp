//import 'dart:convert' ;


enum AccountType
{
  user,admin
}



class MyUser
{
  String uid;
  String name = "dummy";
  String email = "dummy";
  int accountType = AccountType.user.index;


  MyUser({this.uid});

  Map<String, dynamic> toJson() =>
      {
        'id'  : uid,
        'name': name,
        'email':email,
        'accountType' : accountType,
      };

  void fromJson ( Map<String, dynamic> json)
  {
      uid  = json['id'] as String;
      name = json['name'] as String;
      accountType = json['accountType'] as int;
      email = json['email'] as String;
  }

}