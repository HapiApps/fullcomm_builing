import 'package:fullcomm_billing/data/local_data.dart';
import 'package:fullcomm_billing/models/billing_product.dart';

class Order {
  String customerMobile;
  String customerId;
  String customerName;
  String customerAddress;
  String cashier;
  String paymentMethod;
  String paymentId;
  String orderGrandTotal;
  String orderSubTotal;
  String receivedAmt;
  String payBackAmt;
  String savings;
  List<BillingItem> products;

  Order({
    required this.orderGrandTotal,
    required this.orderSubTotal,
    required this.customerMobile,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.cashier,
    required this.paymentMethod,
    required this.paymentId,
    required this.receivedAmt,
    required this.payBackAmt,
    required this.products,
    required this.savings,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile': customerMobile,
      'customer_id': customerId,
      'customer_name': customerName,
      'address': customerAddress,
      'cashier': cashier,
      'payment_method': paymentMethod,
      'payment_id': paymentId,
      'platform': LocalData.platformKey,
      'o_total': orderGrandTotal,
      'subtotal': orderSubTotal,
      'received_amt': receivedAmt,
      'pay_back_amt': payBackAmt,
      'savings': savings,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
