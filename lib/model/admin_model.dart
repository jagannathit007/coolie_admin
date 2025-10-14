class AdminSignInResponse {
  String? token;
  Admin? admin;

  AdminSignInResponse({
    this.token,
    this.admin,
  });

  factory AdminSignInResponse.fromJson(Map<String, dynamic> json) => AdminSignInResponse(
        token: json["token"],
        admin: json["admin"] != null ? Admin.fromJson(json["admin"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "admin": admin?.toJson(),
      };
}

class Admin {
  String? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? profilePic;

  Admin({
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.profilePic,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "profilePic": profilePic,
      };
}