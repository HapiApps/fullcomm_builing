class PlacedOrderResponse {
  int? responseCode;
  int? invoiceNo;
  String? message;

  PlacedOrderResponse({
    this.responseCode,
    this.invoiceNo,
    this.message,
  });

  factory PlacedOrderResponse.fromJson(Map<String, dynamic> json) =>
      PlacedOrderResponse(
        responseCode: json["response_code"],
        invoiceNo: json["invoice_no"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "invoice_no": invoiceNo,
        "message": message,
      };
}
