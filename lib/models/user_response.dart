class UserDataResponse {
  int? responseCode;
  String? message;
  UserData? userData;

  UserDataResponse({
    this.responseCode,
    this.message,
    this.userData,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) =>
      UserDataResponse(
        responseCode: json["responseCode"],
        message: json["message"],
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "message": message,
        "userData": userData?.toJson(),
      };
}

class UserData {
  String? id;
  String? sName;
  String? sMobile;
  String? email;
  DateTime? dob;
  String? sAddress;
  String? salary;
  String? bonus;
  String? password;
  String? role;
  String? otherRoles;
  DateTime? joiningDate;
  String? whatsapp;
  String? cosId;

  UserData(
      {this.id,
      this.sName,
      this.sMobile,
      this.email,
      this.dob,
      this.sAddress,
      this.salary,
      this.bonus,
      this.password,
      this.role,
      this.otherRoles,
      this.joiningDate,
      this.whatsapp,
      this.cosId});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        sName: json["s_name"],
        sMobile: json["s_mobile"],
        email: json["email"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        sAddress: json["s_address"],
        salary: json["salary"],
        bonus: json["bonus"],
        password: json["password"],
        role: json["role"],
        otherRoles: json["other_roles"],
        joiningDate: json["joining_date"] == null
            ? null
            : DateTime.parse(json["joining_date"]),
        whatsapp: json["whatsapp"],
        cosId: json["cos_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "s_name": sName,
        "s_mobile": sMobile,
        "email": email,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "s_address": sAddress,
        "salary": salary,
        "bonus": bonus,
        "password": password,
        "role": role,
        "other_roles": otherRoles,
        "joining_date":
            "${joiningDate!.year.toString().padLeft(4, '0')}-${joiningDate!.month.toString().padLeft(2, '0')}-${joiningDate!.day.toString().padLeft(2, '0')}",
        "whatsapp": whatsapp,
        "cos_id": cosId
      };
}
