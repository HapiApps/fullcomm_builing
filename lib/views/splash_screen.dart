import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullcomm_billing/res/colors.dart';
import 'package:fullcomm_billing/view_models/credentials_provider.dart';
import 'package:provider/provider.dart';

import '../res/components/k_back_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 1200), () {
      Provider.of<UserDataProvider>(context, listen: false)
          .checkUserExistence(context); // Check for logged in user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackContainer(
        image: 'assets/vectors/splash_vec.jpg',
        colorFilter: ColorFilter.mode(
          AppColors.black.withValues(alpha: 0.1),
          BlendMode.dstATop,
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double logoSize =
                  constraints.maxWidth * 0.3; // 20% of screen width

              // Minimum and Maximum size
              logoSize = logoSize.clamp(50.0, 300.0); // Min: 50, Max: 300

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/app_logo.png',
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
