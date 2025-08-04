class CommonResponse {
  bool? status;
  String? message;
  int? responseCode;

  CommonResponse({
    this.status,
    this.message,
    this.responseCode,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
        status: json["status"],
        message: json["message"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "responseCode": responseCode,
      };
}
