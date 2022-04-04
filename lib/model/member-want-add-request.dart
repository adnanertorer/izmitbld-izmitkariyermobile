class MemberWantAddRequest{
  int? memberRequestId;
  int? wantAdId;
  int? memberId;
  DateTime? createdAt;
  String? memberNotes ;


  MemberWantAddRequest({
    this.wantAdId,
    this.createdAt,
    this.memberId, this.memberNotes, this.memberRequestId
  });

  factory MemberWantAddRequest.fromJson(Map<String, Map> json){
    return MemberWantAddRequest(
        wantAdId: json["wantAdId"] as int,
        memberRequestId: json["memberRequestId"] as int,
        memberId: json["memberId"] as int,
        createdAt: json["createdAt"] as DateTime,
        memberNotes: json["memberNotes"] as String
    );
  }

  Map<String, dynamic> toJson() => {
    "wantAdId": this.wantAdId,
    "memberRequestId": this.memberRequestId,
    "memberId": this.memberId,
    "createdAt": this.createdAt,
    "memberNotes": this.memberNotes
  };
}
