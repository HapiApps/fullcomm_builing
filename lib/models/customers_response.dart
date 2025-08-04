class CustomersResponse {
  String? responseCode;
  String? message;
  List<CustomerData>? customersList;

  CustomersResponse({
    this.responseCode,
    this.message,
    this.customersList,
  });

  factory CustomersResponse.fromJson(Map<String, dynamic> json) =>
      CustomersResponse(
        responseCode: json["responseCode"],
        message: json["message"],
        customersList: json["data"] == null
            ? []
            : List<CustomerData>.from(
                json["data"]!.map((x) => CustomerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "message": message,
        "data": customersList == null
            ? []
            : List<dynamic>.from(customersList!.map((x) => x.toJson())),
      };
}

class CustomerData {
  String? userId;
  String? name;
  String? mobile;
  String? emailId;
  String? password;
  dynamic whatsapp;
  DateTime? rDate;
  String? cCode;
  String? code;
  dynamic referCode;
  String? wallet;
  String? addressId;
  String? area;
  String? pincode;
  String? addressLine1;
  String? landmark;
  String? type;
  String? lat;
  String? lng;
  String? addressName;
  String? addressMobile;
  String? city;
  String? state;
  dynamic addressLine2;
  dynamic country;
  String? tier;

  CustomerData({
    this.userId,
    this.name,
    this.mobile,
    this.emailId,
    this.password,
    this.whatsapp,
    this.rDate,
    this.cCode,
    this.code,
    this.referCode,
    this.wallet,
    this.addressId,
    this.area,
    this.pincode,
    this.addressLine1,
    this.landmark,
    this.type,
    this.lat,
    this.lng,
    this.addressName,
    this.addressMobile,
    this.city,
    this.state,
    this.addressLine2,
    this.country,
    this.tier,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        userId: json["user_id"],
        name: json["name"],
        mobile: json["mobile"],
        emailId: json["email_id"],
        password: json["password"],
        whatsapp: json["whatsapp"],
        rDate: json["r_date"] == null ? null : DateTime.parse(json["r_date"]),
        cCode: json["c_code"],
        code: json["code"],
        referCode: json["refer_code"],
        wallet: json["wallet"],
        addressId: json["address_id"],
        area: json["area"],
        pincode: json["pincode"],
        addressLine1: json["address_line_1"],
        landmark: json["landmark"],
        type: json["type"],
        lat: json["lat"],
        lng: json["lng"],
        addressName: json["address_name"],
        addressMobile: json["address_mobile"],
        city: json["city"],
        state: json["state"],
        addressLine2: json["address_line_2"],
        country: json["country"],
        tier: json["tier"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "mobile": mobile,
        "email_id": emailId,
        "password": password,
        "whatsapp": whatsapp,
        "r_date": rDate?.toIso8601String(),
        "c_code": cCode,
        "code": code,
        "refer_code": referCode,
        "wallet": wallet,
        "address_id": addressId,
        "area": area,
        "pincode": pincode,
        "address_line_1": addressLine1,
        "landmark": landmark,
        "type": type,
        "lat": lat,
        "lng": lng,
        "address_name": addressName,
        "address_mobile": addressMobile,
        "city": city,
        "state": state,
        "address_line_2": addressLine2,
        "country": country,
        "tier": tier,
      };
}
