import 'package:flutter/material.dart';
import 'package:fullcomm_billing/res/colors.dart';

class DividerWidgets {

  /// Main Screen Divider :
  static Widget mainDivider(){
    return Divider(
      indent: 5,
      endIndent: 10,
      color: AppColors.primary.withValues(alpha: 0.5),
    );
  }

}

