class DrivingLicence{
  int? driverLicenseId;
  String? licenseName;

  DrivingLicence({this.driverLicenseId, this.licenseName});

  factory DrivingLicence.fromJson(Map<String, Map> json){
    return DrivingLicence(
        driverLicenseId: json["driverLicenseId"] as int,
        licenseName: json["licenseName"] as String
    );
  }
}