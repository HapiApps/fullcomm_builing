import 'package:flutter/material.dart';
import 'package:fullcomm_billing/utils/sized_box.dart';
import 'package:fullcomm_billing/utils/text_formats.dart';

import 'k_text.dart';

class ScreenWidgets {

  /// ------- Empty Alert --------
  static Widget emptyAlert(
      context,{
        double? height,
        double? width,
        required String image,
        required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: height ?? MediaQuery.of(context).size.height * 0.35,
            width: width ?? MediaQuery.of(context).size.height * 0.35,
          ),
          5.height,
          MyText(
            text: text,
            fontSize: TextFormat.responsiveFontSize(context, 16),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
