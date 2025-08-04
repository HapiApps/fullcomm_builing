class PreviousBillObj {
  String responseCode;
  String message;
  List<BillObj> data;

  PreviousBillObj({
    required this.responseCode,
    required this.message,
    required this.data,
  });

  factory PreviousBillObj.fromJson(Map<String, dynamic> json) =>
      PreviousBillObj(
        responseCode: json["responseCode"],
        message: json["message"],
        data: List<BillObj>.from(json["data"].map((x) => BillObj.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BillObj {
  String invoiceNo;
  String cosId;
  String oId;
  String pTitle;
  String pQuantity;
  String pDiscount;
  String pPrice;
  String oTotal;
  String subtotal;
  String mobile;
  String status;
  String billType;
  DateTime oDate;
  String pMethodId;
  String address;
  String dCharge;
  String couId;
  String couAmt;
  String wallAmt;
  String name;
  String tSlot;
  String uId;
  String paymentActive;
  String createdBy;
  String transId;
  String active;
  String platform;

  BillObj({
    required this.invoiceNo,
    required this.cosId,
    required this.oId,
    required this.pTitle,
    required this.pQuantity,
    required this.pDiscount,
    required this.pPrice,
    required this.oTotal,
    required this.subtotal,
    required this.mobile,
    required this.status,
    required this.billType,
    required this.oDate,
    required this.pMethodId,
    required this.address,
    required this.dCharge,
    required this.couId,
    required this.couAmt,
    required this.wallAmt,
    required this.name,
    required this.tSlot,
    required this.uId,
    required this.paymentActive,
    required this.createdBy,
    required this.transId,
    required this.active,
    required this.platform,
  });

  factory BillObj.fromJson(Map<String, dynamic> json) => BillObj(
        invoiceNo: json["invoice_no"],
        cosId: json["cos_id"],
        oId: json["o_id"],
        pTitle: json["p_title"],
        pQuantity: json["p_quantity"],
        pDiscount: json["p_discount"],
        pPrice: json["p_price"],
        oTotal: json["o_total"],
        subtotal: json["subtotal"],
        mobile: json["mobile"],
        status: json["status"],
        billType: json["bill_type"],
        oDate: DateTime.parse(json["o_date"]),
        pMethodId: json["p_method_id"],
        address: json["address"],
        dCharge: json["d_charge"],
        couId: json["cou_id"],
        couAmt: json["cou_amt"],
        wallAmt: json["wall_amt"],
        name: json["name"],
        tSlot: json["t_slot"],
        uId: json["u_id"],
        paymentActive: json["payment_active"],
        createdBy: json["created_by"],
        transId: json["trans_id"],
        active: json["active"],
        platform: json["platform"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_no": invoiceNo,
        "cos_id": cosId,
        "o_id": oId,
        "p_title": pTitle,
        "p_quantity": pQuantity,
        "p_discount": pDiscount,
        "p_price": pPrice,
        "o_total": oTotal,
        "subtotal": subtotal,
        "mobile": mobile,
        "status": status,
        "bill_type": billType,
        "o_date":
            "${oDate.year.toString().padLeft(4, '0')}-${oDate.month.toString().padLeft(2, '0')}-${oDate.day.toString().padLeft(2, '0')}",
        "p_method_id": pMethodId,
        "address": address,
        "d_charge": dCharge,
        "cou_id": couId,
        "cou_amt": couAmt,
        "wall_amt": wallAmt,
        "name": name,
        "t_slot": tSlot,
        "u_id": uId,
        "payment_active": paymentActive,
        "created_by": createdBy,
        "trans_id": transId,
        "active": active,
        "platform": platform,
      };
}
