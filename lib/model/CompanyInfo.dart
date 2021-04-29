import 'package:intl/intl.dart';

class CompanyInfo
{
  String id;
  String name  = "gg";
  String location = "cityhall";
  DateTime companyStartDate =  new DateTime.now();


  CompanyInfo({this.id});

  String getDateTimeInYYMMDD()
  {

    return DateFormat("yyyy-MM-dd").format(companyStartDate);
  }

  Map<String, dynamic> toJson() =>
      {
        'id'          : id,
        'location'    : location,
        'name'        : name,
        'companyStartDate' : companyStartDate.toString(),
      };

  void fromJson ( Map<String, dynamic> json) {
    id = json['id'] as String;
    location = json['location'] as String;
    name = json['name'];
    companyStartDate = DateTime.parse(json['companyStartDate']);
  }
}
