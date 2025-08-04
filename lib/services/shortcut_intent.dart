import 'package:flutter/material.dart';

class PrintIntent extends Intent {
  const PrintIntent();
}

class PrintAction extends Action<PrintIntent> {
  final VoidCallback onPrint;

  PrintAction(this.onPrint);

  @override
  Object? invoke(PrintIntent intent) {
    onPrint();
    return null;
  }
}

// Payment Action
class PaymentIntent extends Intent {
  const PaymentIntent();
}

class PaymentAction extends Action<PaymentIntent> {
  final VoidCallback onTap;

  PaymentAction(this.onTap);

  @override
  Object? invoke(PaymentIntent intent) {
    onTap();
    return null;
  }
}
