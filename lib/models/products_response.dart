class ProductsResponse {
  int? responseCode;
  String? message;
  List<ProductData>? productList;

  ProductsResponse({
    this.responseCode,
    this.message,
    this.productList,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
    responseCode: json["responseCode"],
    message: json["message"],
    productList: json["data"] == null ? [] : List<ProductData>.from(json["data"]!.map((x) => ProductData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "message": message,
    "data": productList == null ? [] : List<dynamic>.from(productList!.map((x) => x.toJson())),
  };
}

class ProductData {
  String? id;
  String? skuId;
  dynamic hsnCode;
  String? barcode;
  String? catId;
  String? subCatId;
  String? pImg;
  String? pTitle;
  String? brand;
  String? pVariation;
  String? cgst;
  String? sgst;
  String? igst;
  String? pDisc;
  String? unit;
  String? type;
  dynamic pDesc;
  String? isLoose;
  String? reorderLevel;
  String? emergencyLevel;
  String? location;
  String? godownLocation;
  String? batchNo;
  String? mrp;
  String? outPrice;
  String? qtyLeft;
  String? stockQty;
  dynamic pricePerG;
  String? missingQty;
  DateTime? expiryDate;
  String? stockDate;
  String? supplierId;

  ProductData({
    this.id,
    this.skuId,
    this.hsnCode,
    this.barcode,
    this.catId,
    this.subCatId,
    this.pImg,
    this.pTitle,
    this.brand,
    this.pVariation,
    this.cgst,
    this.sgst,
    this.igst,
    this.pDisc,
    this.unit,
    this.type,
    this.pDesc,
    this.isLoose,
    this.reorderLevel,
    this.emergencyLevel,
    this.location,
    this.godownLocation,
    this.batchNo,
    this.mrp,
    this.outPrice,
    this.qtyLeft,
    this.stockQty,
    this.pricePerG,
    this.missingQty,
    this.expiryDate,
    this.stockDate,
    this.supplierId,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    id: json["id"],
    skuId: json["sku_id"],
    hsnCode: json["hsn_code"],
    barcode: json["barcode"],
    catId: json["cat_id"],
    subCatId: json["sub_cat_id"],
    pImg: json["p_img"],
    pTitle: json["p_title"],
    brand: json["brand"],
    pVariation: json["p_variation"],
    cgst: json["cgst"],
    sgst: json["sgst"],
    igst: json["igst"],
    pDisc: json["p_disc"],
    unit: json["unit"],
    type: json["type"],
    pDesc: json["p_desc"],
    isLoose: json["is_loose"],
    reorderLevel: json["reorder_level"],
    emergencyLevel: json["emergency_level"],
    location: json["location"],
    godownLocation: json["godown_location"],
    batchNo: json["batch_no"],
    mrp: json["mrp"],
    outPrice: json["out_price"],
    qtyLeft: json["qty_left"],
    stockQty: json["stockqty"],
    pricePerG: json["per_g"],
    missingQty: json["missing_qty"],
    expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
    stockDate: json["stock_date"],
    supplierId: json["supplier_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku_id": skuId,
    "hsn_code": hsnCode,
    "barcode": barcode,
    "cat_id": catId,
    "sub_cat_id": subCatId,
    "p_img": pImg,
    "p_title": pTitle,
    "brand": brand,
    "p_variation": pVariation,
    "cgst": cgst,
    "sgst": sgst,
    "igst": igst,
    "p_disc": pDisc,
    "unit": unit,
    "type": type,
    "p_desc": pDesc,
    "is_loose": isLoose,
    "reorder_level": reorderLevel,
    "emergency_level": emergencyLevel,
    "location": location,
    "godown_location": godownLocation,
    "batch_no": batchNo,
    "mrp": mrp,
    "out_price": outPrice,
    "qty_left": qtyLeft,
    "stockqty": stockQty,
    "per_g": pricePerG,
    "missing_qty": missingQty,
    "expiry_date": "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "stock_date": stockDate,
    "supplier_id": supplierId,
  };
}
