class MemberCompetenceModel {
  int? memberCompetenceId;
  String? competenceName;
  int? memberId;

  MemberCompetenceModel(
      {this.memberId, this.competenceName, this.memberCompetenceId});

  Map<String, dynamic> toJson() => {
    "memberCompetenceId": this.memberCompetenceId,
    "competenceName": this.competenceName,
    "memberId": this.memberId
  };

  factory MemberCompetenceModel.fromJson(Map<String, Map> json) {
    return MemberCompetenceModel(
      memberCompetenceId: json["memberCompetenceId"] as int,
      memberId: json["memberId"] as int,
      competenceName: json["competenceName"] as String,
    );}
}


