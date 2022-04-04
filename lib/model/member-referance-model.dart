class MemberReferanceModel {
  int? memberReferanceId;
  int? memberId;
  String? referanceName;
  String? referanceSurname;
  String? referancePhone;
  int? isApprove;

  MemberReferanceModel({
    this.memberId,
    this.isApprove,
    this.memberReferanceId,
    this.referanceName,
    this.referancePhone,
    this.referanceSurname,
  });

  factory MemberReferanceModel.fromJson(Map<String, Map> json) {
    return MemberReferanceModel(
      isApprove: json["isApprove"] as int,
      memberId: json["memberId"] as int,
      memberReferanceId: json["memberReferanceId"] as int,
      referanceName: json["referanceName"] as String,
      referancePhone: json["referancePhone"] as String,
      referanceSurname: json["referanceSurname"] as String,
    );}

  Map<String, dynamic> toJson() => {
    "isApprove": this.isApprove,
    "memberId": this.memberId,
    "memberReferanceId": this.memberReferanceId,
    "referanceName": this.referanceName,
    "referancePhone": this.referancePhone,
    "referanceSurname": this.referanceSurname
  };
}
