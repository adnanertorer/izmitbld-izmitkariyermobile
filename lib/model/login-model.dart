class LoginResource {
  String? tcIdendtityNumber;
  String? password;

  LoginResource({this.password, this.tcIdendtityNumber});

  Map<String, dynamic> toJson() => {
        "tcIdendtityNumber": this.tcIdendtityNumber,
        "password": this.password,
      };
}
