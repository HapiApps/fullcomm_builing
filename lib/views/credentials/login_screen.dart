import 'package:flutter/material.dart';
import 'package:fullcomm_billing/res/colors.dart';
import 'package:fullcomm_billing/utils/sized_box.dart';
import 'package:fullcomm_billing/utils/toast_messages.dart';
import 'package:fullcomm_billing/view_models/credentials_provider.dart';
import 'package:provider/provider.dart';

import '../../res/components/buttons.dart';
import '../../res/components/k_back_container.dart';
import '../../res/components/k_text.dart';
import '../../res/components/k_text_field.dart';
import '../../utils/input_formatters.dart';
import '../../utils/text_formats.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<UserDataProvider>(builder: (context, userProvider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: BackContainer(
          image: 'assets/vectors/splash_vec.jpg',
          child: Center(
            child: FractionallySizedBox(
              widthFactor:
                  screenWidth > 1200 ? 0.4 : (screenWidth > 800 ? 0.6 : 0.8),
              heightFactor: 0.75,
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/app_logo.png',
                        // width: screenWidth > 800 ? screenWidth * 0.15 : screenWidth * 0.25,
                        // height: screenWidth > 800 ? screenWidth * 0.15 : screenWidth * 0.25,
                        fit: BoxFit.contain,
                      ),
                      MyText(
                        text: 'BillEase',
                        fontSize: TextFormat.responsiveFontSize(context, 30),
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                        letterSpacing: 0.5,
                      ),
                      25.height,
                      MyText(
                        text: 'Login to your account',
                        fontSize: TextFormat.responsiveFontSize(context, 19),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBlue,
                      ),
                      15.height,
                      MyTextField(
                        labelText: 'Mobile Number',
                        width: screenWidth > 800
                            ? screenWidth * 0.20
                            : screenWidth * 0.35,
                        controller: userProvider.mobileController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        inputFormatters: InputFormatters.mobileNumberInput,
                      ),
                      8.height,
                      MyTextField(
                        labelText: 'Password',
                        width: screenWidth > 800
                            ? screenWidth * 0.20
                            : screenWidth * 0.35,
                        controller: userProvider.passwordController,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          userProvider.loginButtonController
                              .start(); // Start Loading

                          if (userProvider.mobileController.text
                                      .trim()
                                      .length ==
                                  10 &&
                              userProvider.passwordController.text
                                  .trim()
                                  .isNotEmpty) {
                            userProvider.login(
                              context: context,
                              mobile: userProvider.mobileController.text.trim(),
                              password:
                                  userProvider.passwordController.text.trim(),
                            );
                          } else if (userProvider.mobileController.text
                              .trim()
                              .isEmpty) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Please enter your mobile number.',
                              color: AppColors.errorMessage,
                            );
                          } else if (userProvider.mobileController.text
                                  .trim()
                                  .length !=
                              10) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Please enter correct mobile number.',
                              color: AppColors.errorMessage,
                            );
                          } else if (userProvider.passwordController.text
                              .trim()
                              .isEmpty) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Please enter your password.',
                              color: AppColors.errorMessage,
                            );
                          } else if (userProvider.passwordController.text
                                  .trim()
                                  .length <
                              8) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Password must be at least 8 characters.',
                              color: AppColors.errorMessage,
                            );
                          } else {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Invalid Mobile/Password!',
                              color: AppColors.errorMessage,
                            );
                          }
                        },
                      ),
                      8.height,
                      Buttons.loginButton(
                        context: context,
                        loadingButtonController:
                            userProvider.loginButtonController,
                        height: 50,
                        width: screenWidth > 800
                            ? screenWidth * 0.20
                            : screenWidth * 0.35,
                        onPressed: () {
                          if (userProvider.mobileController.text
                                      .trim()
                                      .length ==
                                  10 &&
                              userProvider.passwordController.text
                                  .trim()
                                  .isNotEmpty) {
                            userProvider.login(
                              context: context,
                              mobile: userProvider.mobileController.text.trim(),
                              password:
                                  userProvider.passwordController.text.trim(),
                            );
                          } else if (userProvider.mobileController.text
                              .trim()
                              .isEmpty) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Please enter your mobile number.',
                              color: AppColors.errorMessage,
                            );
                          } else if (userProvider.mobileController.text
                                  .trim()
                                  .length !=
                              10) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Please enter your correct mobile number.',
                              color: AppColors.errorMessage,
                            );
                          } else if (userProvider.passwordController.text
                              .trim()
                              .isEmpty) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Enter Valid Password',
                              color: AppColors.errorMessage,
                            );
                          } else if (userProvider.passwordController.text
                                  .trim()
                                  .length <
                              8) {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Password must be at least 8 characters.',
                              color: AppColors.errorMessage,
                            );
                          } else {
                            userProvider.loginButtonController.reset();
                            Toasts.showToastBar(
                              context: context,
                              text: 'Invalid Mobile/Password!',
                              color: AppColors.errorMessage,
                            );
                          }
                        },
                        text: 'LOGIN',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
