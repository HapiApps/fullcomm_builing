import 'package:flutter/material.dart';

import '../colors.dart';
import 'k_text.dart';

class BottomWidgets {
  // Bottom Card that shows Discount,Tax,SubTotal,etc.
  static Widget valueCard(
      {required BuildContext context,
      required String title,
      required String value}) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.09,
      width: screenWidth * 0.13,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.25),
          spreadRadius: -5,
          blurRadius: 10,
          offset: const Offset(10, 0),
        ),
      ], color: AppColors.white, borderRadius: BorderRadius.circular(13)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: screenWidth,
              height: screenHeight * 0.04,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                  color: AppColors.primary),
              child: MyText(
                text: title,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: screenHeight * 0.05,
              child: MyText(
                  text: value,
                  color: AppColors.black,
                  fontSize: 17,
                  textAlign: TextAlign.center),
            ),
          ]),
    );
  }
}
