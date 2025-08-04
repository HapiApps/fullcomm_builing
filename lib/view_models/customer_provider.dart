import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fullcomm_billing/data/local_data.dart';
import 'package:fullcomm_billing/repo/customer_repo.dart';
import 'package:fullcomm_billing/res/colors.dart';
import 'package:fullcomm_billing/utils/sized_box.dart';
import 'package:fullcomm_billing/utils/toast_messages.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../models/customers_response.dart';
import '../res/components/buttons.dart';
import '../res/components/k_text.dart';
import '../res/components/k_text_field.dart';
import '../utils/input_formatters.dart';
import '../utils/text_formats.dart';

class CustomersProvider with ChangeNotifier {
  final CustomersRepository _customerRepo = CustomersRepository();

  // Add Customer Fields :
  TextEditingController customerName = TextEditingController();
  TextEditingController customerMobile = TextEditingController();
  TextEditingController customerStreet = TextEditingController();
  TextEditingController customerArea = TextEditingController();
  TextEditingController customerCity = TextEditingController();
  TextEditingController customerPincode = TextEditingController();
  TextEditingController customerState =
      TextEditingController(text: 'TamilNadu');

  // Loading Button Controller:
  RoundedLoadingButtonController loadingButtonController =
      RoundedLoadingButtonController();

  /// ----------- Add Customer ----------------------
  Future<void> addCustomer({
    required BuildContext context,
    required String name,
    required String mobile,
    required String addressLine1,
    required String area,
    required String pincode,
    required String city,
    required String state,
  }) async {
    try {
      final response = await _customerRepo.addCustomer(
          name: name,
          mobile: mobile,
          addressLine1: addressLine1,
          area: area,
          pincode: pincode,
          city: city,
          state: state);

      if (response.responseCode == 200) {
        // Store Customer Details:
        localData.customerName = name;
        localData.customerMobile = mobile;
        localData.customerAddress =
            "$addressLine1,$area,$city,$pincode".replaceAll(',,', ','); // Fix

        // Clear Fields:
        customerName.clear();
        customerMobile.clear();
        customerStreet.clear();
        customerArea.clear();
        customerCity.clear();
        customerPincode.clear();

        if (!context.mounted) return;
        await getAllCustomers(context);

        if (!context.mounted) return;
        Navigator.pop(context);

        Toasts.showToastBar(context: context, text: 'Customer is added.');
      } else if (response.responseCode == 409) {
        // Existing Customer :
        if (!context.mounted) return;
        Toasts.showToastBar(
            context: context,
            text: 'Customer already exists.',
            color: AppColors.errorMessage);
      } else {
        // Invalid Details :
        if (!context.mounted) return;
        Toasts.showToastBar(
            context: context,
            text: 'Enter Valid Details',
            color: AppColors.errorMessage);
        log("Add Address Error: ${response.message}");
      }
    } catch (e) {
      Toasts.showToastBar(
          context: context,
          text: 'Something went wrong.',
          color: AppColors.errorMessage);
      throw Exception("addCustomer Error : $e");
    } finally {
      loadingButtonController.reset();
      notifyListeners();
    }
  }

  /// --------- Add Customer DialogBox --------------
  void addCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SingleChildScrollView(
              // Ensures content fits dynamically
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min, // Adjusts size to fit content
                  children: [
                    MyText(
                      text: 'Add Customer',
                      fontSize: TextFormat.responsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "Customer's Name",
                      controller: customerName,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "Mobile",
                      controller: customerMobile,
                      inputFormatters: InputFormatters.mobileNumberInput,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "Door No, Street",
                      controller: customerStreet,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "Area",
                      controller: customerArea,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "City",
                      controller: customerCity,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "Pincode",
                      controller: customerPincode,
                      inputFormatters: InputFormatters.pinCodeInput,
                    ),
                    6.height,
                    MyTextField(
                      labelText: "State",
                      controller: customerState,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    6.height,
                    Buttons.loginButton(
                      context: context,
                      loadingButtonController: loadingButtonController,
                      onPressed: () {
                        if (customerName.text.isEmpty) {
                          loadingButtonController.reset();
                          Toasts.showToastBar(
                              context: context,
                              text: "Please enter customer name",
                              color: Colors.red);
                        } else if (customerMobile.text.isEmpty) {
                          loadingButtonController.reset();
                          Toasts.showToastBar(
                              context: context,
                              text: "Please enter customer mobile",
                              color: Colors.red);
                        } else if (customerCity.text.isEmpty) {
                          loadingButtonController.reset();
                          Toasts.showToastBar(
                              context: context,
                              text: "Please enter customer city",
                              color: Colors.red);
                        } else if (customerPincode.text.isEmpty) {
                          loadingButtonController.reset();
                          Toasts.showToastBar(
                              context: context,
                              text: "Please enter customer pincode",
                              color: Colors.red);
                        } else {
                          addCustomer(
                            context: context,
                            name: customerName.text,
                            mobile: customerMobile.text,
                            addressLine1: customerStreet.text,
                            area: customerArea.text,
                            pincode: customerPincode.text,
                            city: customerCity.text,
                            state: customerState.text,
                          );
                        }
                      },
                      text: 'Submit',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  /// -------- Customer Selection -------------------
  String _selectedCustomerId = '';
  String _selectedCustomerName = '';
  String _selectedCustomerMobile = '';

  String get selectedCustomerId => _selectedCustomerId;
  String get selectedCustomerName => _selectedCustomerName;
  String get selectedCustomerMobile => _selectedCustomerMobile;

  /// -------- Fetch all Customers -----------------

  List<CustomerData> _allCustomers = [];
  List<CustomerData> get allCustomersList => _allCustomers;

  // Fetch all Customers Api :
  Future<void> getAllCustomers(context) async {
    try {
      final response = await _customerRepo.getCustomers();

      if (response.responseCode == '200') {
        _allCustomers = response.customersList ?? [];
      } else {
        _allCustomers = [];
      }
    } catch (e) {
      Toasts.showToastBar(
          context: context, text: 'Failed to receive Customers List');
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  // Select Customer :
  TextEditingController customerAddressController = TextEditingController();

  /// Set Customer Details :
  void setCustomerDetails(
      {required String customerId,
      required String customerName,
      required String customerMobile,
      required String customerAddress}) {
    _selectedCustomerId = customerId;
    _selectedCustomerName = customerName;
    _selectedCustomerMobile = customerMobile;
    customerAddressController.text = customerAddress;
    notifyListeners();
  }

  /// Reset Customer Details (Emptying)
  void resetCustomerDetails() {
    _selectedCustomerId = '';
    _selectedCustomerName = '';
    _selectedCustomerMobile = '';
    customerAddressController.clear();
    notifyListeners();
  }
}
