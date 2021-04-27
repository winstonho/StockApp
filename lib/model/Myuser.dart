//import 'dart:convert' ;


enum AccountType
{
  user,admin
}

Map<String, int> accountTypeMap =
{
  'user':  0,
  'admin': 1,
};


String getTypeNameFromInt(int type)
{
  return accountTypeMap.keys.firstWhere(
          (k) => accountTypeMap[k] == type, orElse: () => "");
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