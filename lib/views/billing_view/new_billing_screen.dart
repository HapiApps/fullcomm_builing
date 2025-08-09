import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fullcomm_billing/models/products_response.dart';
import 'package:fullcomm_billing/res/colors.dart';
import 'package:fullcomm_billing/res/components/buttons.dart';
import 'package:fullcomm_billing/res/components/k_loadings.dart';
import 'package:fullcomm_billing/res/components/k_text.dart';
import 'package:fullcomm_billing/res/components/screen_widgtes.dart';
import 'package:fullcomm_billing/utils/input_formatters.dart';
import 'package:fullcomm_billing/utils/sized_box.dart';
import 'package:fullcomm_billing/utils/text_formats.dart';
import 'package:fullcomm_billing/utils/toast_messages.dart';
import 'package:fullcomm_billing/view_models/billing_provider.dart';
import 'package:fullcomm_billing/view_models/credentials_provider.dart';
import 'package:fullcomm_billing/view_models/customer_provider.dart';
import 'package:provider/provider.dart';
import '../../data/project_data.dart';
import '../../models/billing_product.dart';
import '../../models/customers_response.dart';
import '../../models/place_order.dart';
import '../../res/components/customer_widgets.dart';
import '../../res/components/k_text_field.dart';
import '../../res/components/keyboard_search.dart';
import '../orders/order_detail_page.dart';

class NextPageIntent extends Intent {
  const NextPageIntent();
}

class ActivateIntent extends Intent {
  const ActivateIntent();
}

class LastBillIntent extends Intent {
  const LastBillIntent();
}

class AltOnlyIntent extends Intent {
  const AltOnlyIntent();
}

class NewBillingScreen extends StatefulWidget {
  const NewBillingScreen({super.key});

  @override
  State<NewBillingScreen> createState() => _NewBillingScreenState();
}

class _NewBillingScreenState extends State<NewBillingScreen> {
  final FocusNode dropdownFocusNode = FocusNode();
  final FocusNode fieldFocusNode = FocusNode();
  final TextEditingController dropdownController = TextEditingController();
  final TextEditingController quantityVariationController =
      TextEditingController();

  // For Scrolling Billing Table :
  ScrollController scrollController = ScrollController();

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + kBottomNavigationBarHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      log("ScrollController is not attached to any scroll view.");
    }
  }

  FocusNode _focusNode = FocusNode();
  FocusNode _focusNodeSearch = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.requestFocus();
    _focusNodeSearch.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BillingProvider>(context, listen: false)
          .getProducts(); // Fetch all Products & Stocks
      Provider.of<CustomersProvider>(context, listen: false)
          .getAllCustomers(context); // Fetch all Products & Stocks
      Provider.of<CustomersProvider>(context, listen: false)
          .resetCustomerDetails(); // Reset Customer details
      Provider.of<BillingProvider>(context, listen: false).fetchBill(context);
      Provider.of<BillingProvider>(context, listen: false)
          .setBillingItems([]); // Set Billing Items with Empty Table
    });
  }

  @override
  void dispose() {
    _focusNodeSearch.dispose();
    dropdownFocusNode.dispose();
    fieldFocusNode.dispose();
    dropdownController.dispose();
    quantityVariationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer3<UserDataProvider, CustomersProvider, BillingProvider>(
        builder:
            (context, userDataProvider, customerProvider, billingProvider, _) {
      return Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyP):
                const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP):
                const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyS):
                const NextPageIntent(),
            LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyR):
                const LastBillIntent(),
            LogicalKeySet(LogicalKeyboardKey.alt): const AltOnlyIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (intent) {
                  if (billingProvider.billingItems.isNotEmpty) {
                    billingProvider.paymentReceived.clear();
                    billingProvider.paymentBalance.clear();
                    showPaymentBalanceDialog(context, onPressPrint: () {
                      if (customerProvider.selectedCustomerId.isEmpty) {
                        customerProvider.setCustomerDetails(
                            customerId: ProjectData.cashId,
                            customerName: "Cash",
                            customerMobile: "1212121212",
                            customerAddress: "Chennai");
                      }
                      billingProvider.placeOrderAndPrintBill(
                        context,
                        order: Order(
                            customerMobile:
                                customerProvider.selectedCustomerMobile,
                            customerId: customerProvider.selectedCustomerId,
                            customerName: customerProvider.selectedCustomerName,
                            customerAddress:
                                customerProvider.customerAddressController.text,
                            cashier: billingProvider.cashierNameController.text
                                .trim(),
                            paymentMethod:
                                billingProvider.selectBillMethod.toString(),
                            paymentId:
                                billingProvider.selectBillMethod.toString() == "Cash"
                                    ? '2'
                                    : '1',
                            products: billingProvider.billingItems,
                            orderGrandTotal: billingProvider
                                .calculatedGrandTotal()
                                .toString(),
                            orderSubTotal: billingProvider
                                .calculatedGrandTotal()
                                .toString(),
                            receivedAmt: billingProvider
                                    .paymentReceived.text.isEmpty
                                ? "0.0"
                                : double.parse(billingProvider.paymentReceived.text)
                                    .toStringAsFixed(1),
                            payBackAmt:
                                (((billingProvider.paymentReceived.text.isEmpty
                                            ? 0.0
                                            : double.parse(
                                                billingProvider.paymentReceived.text)) -
                                        billingProvider.calculatedGrandTotal())
                                    .abs()
                                    .toStringAsFixed(2)),
                            savings: '${billingProvider.billingItems.fold(0.0, (total, item) => total + item.calculateDiscount())}'),
                      );
                    });
                  } else {
                    billingProvider.printButtonController.reset();
                    Toasts.showToastBar(
                        context: context,
                        text: 'Bill List is empty',
                        color: Colors.red);
                  }
                  return null;
                },
              ),
              NextPageIntent: CallbackAction<NextPageIntent>(
                onInvoke: (intent) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OrderDetailPage()));
                  return null;
                },
              ),
              LastBillIntent: CallbackAction<LastBillIntent>(
                onInvoke: (intent) {
                  billingProvider.getLastOrderDetails(context);
                  return null;
                },
              ),
              AltOnlyIntent: CallbackAction<Intent>(
                onInvoke: (intent) {
                  return null;
                },
              ),
            },
            child: Focus(
              focusNode: _focusNode,
              autofocus: true,
              child: PopScope(
                canPop: false,
                child: Scaffold(
                  backgroundColor: Color(0xffffffff),
                  appBar: AppBar(
                    backgroundColor: Color(0xffffffff),
                    toolbarHeight: 100,
                    leadingWidth: 150,
                    leading: Image.asset(
                      'assets/logo/app_logo.png',
                      width: 100,
                      height: 90,
                    ),

                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: "ARUU Billing Portal",
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                        ),
                        MyText(
                            text: " v${ProjectData.version}",
                            color: Colors.grey,
                            fontSize: 15,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    centerTitle: true,
                    actions: [
                      CustomerFieldWidgets.iconButton(
                        context: context,
                        toolTip: 'Search bill',
                        icon: 'assets/images/bill.svg',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderDetailPage()),
                          );
                        },
                      ),
                      20.width,
                      CustomerFieldWidgets.iconButton(
                        context: context,
                        toolTip: 'Add Customer',
                        icon: 'assets/images/customer.svg',
                        onPressed: () {
                          customerProvider.addCustomerDialog(context);
                        },
                      ),
                      20.width,
                      CustomerFieldWidgets.iconButton(
                        context: context,
                        toolTip: 'Refresh Stock Status',
                        icon: 'assets/images/Refresh.svg',
                        onPressed: () {
                          billingProvider.getProducts();
                        },
                      ),
                      20.width,
                      CustomerFieldWidgets.iconButton(
                        context: context,
                        toolTip: 'Logout',
                        icon: 'assets/images/logout.svg',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColors.primary,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Do you want to log out?",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            side: BorderSide(
                                                color: AppColors.secondary),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: const Text(
                                            "No",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () async {
                                            userDataProvider.logout(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            side: BorderSide(
                                                color: AppColors.secondary),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  body: GestureDetector(
                    onTap: () {
                      _focusNode.requestFocus();
                    },
                    child: billingProvider.isLoading
                        ? LoadingWidgets.circleLoading()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 90,
                                color: Color(0xfffdfafa),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Cashier Name
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    text: '  Bill No :  ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.ash,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: billingProvider.billNo ??'',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: AppColors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Cashier Name:  ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.ash,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: billingProvider.cashierNameController.text,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Customer Address
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                    text: 'Customer',
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff9E9E9E)),
                                                // MyDropdownMenu2<CustomerData>(
                                                //   width: screenWidth * 0.20,
                                                //   labelText: 'Cust. Contact',
                                                //   hintText: "Select Customer...",
                                                //   menuHeight: screenHeight * 0.40,
                                                //   enableSearch: true,
                                                //   enableFilter: true,
                                                //   dropdownMenuEntries: customerProvider.allCustomersList.map((customer) {
                                                //     return MyDropdownMenuEntry2(
                                                //       value: customer,
                                                //       label: '${customer.name} - ${customer.mobile}',
                                                //     );
                                                //   }).toList(),
                                                //   onSelected: (value) {
                                                //     customerProvider.setCustomerDetails(
                                                //       customerId: value!.userId.toString(),
                                                //       customerName: value.name.toString(),
                                                //       customerMobile: value.mobile.toString(),
                                                //       customerAddress:
                                                //       "${value.addressLine1 ?? ''} ${value.area ?? ''} ${value.city ?? ''}-${value.pincode ?? ''}",
                                                //     );
                                                //     _focusNode.requestFocus();
                                                //   },
                                                // ),
                                                SizedBox(
                                                  width: screenWidth * 0.20,
                                                  height: 40,
                                                  child: KeyboardDropdownField<CustomerData>(
                                                    items: customerProvider.allCustomersList,
                                                    borderRadius: 0,
                                                    hintText: "Cust. Contact",
                                                    labelText: "",
                                                    labelBuilder: (customer) =>'${customer.name} - ${customer.mobile}',
                                                    itemBuilder: (customer) =>
                                                        Container(
                                                          width: screenWidth * 0.20,
                                                          padding: const EdgeInsets
                                                              .fromLTRB(10, 5, 10, 5),
                                                          child: MyText(
                                                            text: '${customer.name} - ${customer.mobile}',
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                    textEditingController: dropdownController,
                                                    onSelected: (value) {
                                                          customerProvider.setCustomerDetails(
                                                            customerId: value.userId.toString(),
                                                            customerName: value.name.toString(),
                                                            customerMobile: value.mobile.toString(),
                                                            customerAddress:
                                                            "${value.addressLine1 ?? ''} ${value.area ?? ''} ${value.city ?? ''}-${value.pincode ?? ''}",
                                                          );
                                                          _focusNode.requestFocus();
                                                    },
                                                    onClear: () {
                                                      customerProvider.setCustomerDetails(
                                                        customerId: "",
                                                        customerName: "",
                                                        customerMobile: "",
                                                        customerAddress: "",
                                                      );
                                                      //quantityVariationController.clear();
                                                    },
                                                  ),
                                                ),
                                                // MyTextField(
                                                //   width: screenWidth * 0.20,
                                                //   height: 41,
                                                //   isOptional: true,
                                                //   controller: customerProvider
                                                //       .customerAddressController,
                                                //   hintText: "Customer",
                                                //   labelText: '',
                                                //   focusedBorderColor:
                                                //       Color(0xff9e9e9e),
                                                //   enabledBorderColor:
                                                //       Color(0xff9e9e9e),
                                                //   fillColor: Color(0xffffffff),
                                                //   borderRadius: 5,
                                                //   //maxLines: null,
                                                //   //minLines: 2,
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                    text: 'Customer Address',
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff9E9E9E)),
                                                MyTextField(
                                                  width: screenWidth * 0.20,
                                                  height: 41,
                                                  isOptional: true,
                                                  controller: customerProvider
                                                      .customerAddressController,
                                                  hintText: "Customer Address",
                                                  labelText: '',
                                                  focusedBorderColor:
                                                      Color(0xff9e9e9e),
                                                  enabledBorderColor:
                                                      Color(0xff9e9e9e),
                                                  fillColor: Color(0xffffffff),
                                                  borderRadius: 5,
                                                  //maxLines: null,
                                                  //minLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              10.height,

                              /// Fixed Header:
                              // Row containing Search Dropdown and Variation/Quantity field
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Searchable DropdownMenu (Header)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        billingProvider.barcodeMode
                                            ? MyTextField(
                                                width: screenWidth * 0.35,
                                                height: 45,
                                                isOptional: true,

                                                controller: billingProvider
                                                    .barcodeScanner,
                                                labelText: 'Scan...',
                                                maxLines: null,
                                                minLines: 2,
                                                //textAlign: TextAlign.left,
                                                autofocus: true,
                                                onChanged: (value) {
                                                  print("Barcode value $value");
                                                  //billingProvider.findProductByBarcode(value);
                                                },
                                                onEditingComplete: () {
                                                  //billingProvider.findProductByBarcode(context,billingProvider.barcodeScanner.text);
                                                  try {
                                                    final product = billingProvider
                                                        .productsList
                                                        .firstWhere((p) =>
                                                            p.barcode ==
                                                            billingProvider
                                                                .barcodeScanner
                                                                .text);

                                                    billingProvider.selectedProduct =
                                                        product;
                                                    billingProvider
                                                            .barcodeScanner
                                                            .text =
                                                        "${billingProvider.selectedProduct!.pTitle.toString()} ${billingProvider.selectedProduct!.pVariation.toString()}${billingProvider.selectedProduct!.unit.toString()}";
                                                    // billingProvider.updateTemporaryFields(
                                                    //   variation: product.isLoose == '1'
                                                    //           ? 1.0
                                                    //           : null,
                                                    //   quantity: product.isLoose == '0'
                                                    //           ? 1
                                                    //           : null,
                                                    // );
                                                    fieldFocusNode.requestFocus();
                                                  } catch (e) {
                                                    Toasts.showToastBar(
                                                        context: context,
                                                        text:
                                                            "Please scan correct barcode..",
                                                        color: Colors.red);
                                                    // Product not found — you can log or show a message if needed
                                                  }
                                                },
                                              )
                                            : SizedBox(
                                                width: screenWidth * 0.55,
                                                child: KeyboardDropdownField<ProductData>(
                                                  borderRadius: 20,
                                                  focusNode: dropdownFocusNode,
                                                  items: billingProvider.productsList,
                                                  hintText: "Search Product...",
                                                  labelText: " Product",
                                                  labelBuilder: (product) => product.isLoose == '0'
                                                      ? '${product.pTitle} ${product.pVariation}${product.unit}'
                                                      : '${product.pTitle} (${product.pVariation})',
                                                  itemBuilder: (product) =>
                                                      Container(
                                                    width: screenWidth * 0.55,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 5, 10, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MyText(
                                                          text: product
                                                                      .isLoose ==
                                                                  '0'
                                                              ? '${product.pTitle} ${product.pVariation}${product.unit}'
                                                              : '${product.pTitle} (${product.pVariation})',
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          child: MyText(
                                                            text: product.isLoose == '1'
                                                                ? "₹${(double.parse(product.mrp.toString()) / (double.parse(product.stockQty.toString()) / 1000)).toStringAsFixed(1)}/kg"
                                                                : "₹${double.parse(product.mrp.toString()).toStringAsFixed(1)}",
                                                            fontSize: 14,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  textEditingController: dropdownController,
                                                  onSelected: (product) {
                                                    billingProvider.selectedProduct = product;
                                                    billingProvider.updateTemporaryFields(
                                                      variation: product.isLoose == '1'
                                                              ? 1.0
                                                              : null,
                                                      quantity: product.isLoose == '0'
                                                              ? 1
                                                              : null,
                                                    );
                                                    fieldFocusNode
                                                        .requestFocus();
                                                  },
                                                  onClear: () {
                                                    billingProvider
                                                        .selectedProduct = null;
                                                    billingProvider
                                                        .updateTemporaryFields(
                                                      quantity: 0,
                                                      variation: 0.0,
                                                    );
                                                    //quantityVariationController.clear();
                                                  },
                                                ),
                                              ),
                                        10.width,
                                        IconButton(
                                            tooltip: billingProvider.barcodeMode
                                                ? 'Search Products'
                                                : 'Scan Products',
                                            onPressed: () {
                                              //controller.barcodeMode.value = !controller.barcodeMode.value;
                                              if (billingProvider.barcodeMode) {
                                                dropdownFocusNode
                                                    .requestFocus();
                                              }
                                              billingProvider
                                                  .barcodeModeChange();

                                              print(
                                                  "scan ${billingProvider.barcodeMode}");
                                            },
                                            icon: billingProvider.barcodeMode
                                                ? const Icon(Icons.search,
                                                    color: Colors.grey)
                                                : const Icon(
                                                    Icons.barcode_reader,
                                                    color: Colors.grey)),
                                        30.width,

                                        /// Variation/Quantity field (Header)
                                        Container(
                                          width: screenWidth * 0.10,
                                          alignment: Alignment.center,
                                          child: MyTextField(
                                            focusNode: fieldFocusNode,
                                            isOptional: true,
                                            height: 50,

                                            focusedBorderColor:
                                                Color(0xff9e9e9e),
                                            enabledBorderColor:
                                                Color(0xff9e9e9e),
                                            controller:
                                                quantityVariationController,
                                            labelText: billingProvider
                                                        .selectedProduct
                                                        ?.isLoose ==
                                                    '1'
                                                ? "Variation(kg)"
                                                : "Quantity",
                                            keyboardType: TextInputType.number,
                                            inputFormatters: billingProvider
                                                        .selectedProduct
                                                        ?.isLoose ==
                                                    '1'
                                                ? InputFormatters.variationInput
                                                : InputFormatters.quantityInput,
                                            //     : [
                                            //   StrictNonZeroIntFormatter(),
                                            // ],
                                            onChanged: (value) {

                                              if (billingProvider
                                                      .selectedProduct !=
                                                  null) {
                                                if (billingProvider
                                                        .selectedProduct!
                                                        .isLoose ==
                                                    '1') {
                                                  billingProvider
                                                      .updateTemporaryFields(
                                                    variation:
                                                        (double.parse(value) *
                                                            1000),
                                                  );
                                                } else {
                                                  billingProvider
                                                      .updateTemporaryFields(
                                                    quantity: int.tryParse(
                                                            value) ??
                                                        billingProvider
                                                            .temporaryQuantity,
                                                  );
                                                }
                                              } else {
                                                // Optionally reset focus or show a message
                                                //dropdownFocusNode.requestFocus();
                                                Toasts.showToastBar(
                                                    context: context,
                                                    text: "Please add product",
                                                    color: Colors.red);
                                              }
                                            },
                                            onFieldSubmitted: (_) {
                                              if (billingProvider
                                                      .selectedProduct !=
                                                  null) {
                                                billingProvider.addBillingItem(
                                                  BillingItem(
                                                    id: billingProvider
                                                        .selectedProduct!.id!
                                                        .toString(),
                                                    product: billingProvider
                                                        .selectedProduct!,
                                                    productTitle: billingProvider
                                                                .selectedProduct!
                                                                .isLoose ==
                                                            '0'
                                                        ? billingProvider
                                                            .selectedProduct!
                                                            .pTitle
                                                            .toString()
                                                        : "${billingProvider.selectedProduct!.pTitle} ${billingProvider.temporaryVariation / 1000}kg",
                                                    variation: billingProvider
                                                                .selectedProduct!
                                                                .isLoose ==
                                                            '1'
                                                        ? billingProvider
                                                            .temporaryVariation
                                                        : 1,
                                                    variationUnit:
                                                        "${billingProvider.selectedProduct!.pVariation}${billingProvider.selectedProduct!.unit}",
                                                    quantity: billingProvider
                                                                .selectedProduct!
                                                                .isLoose ==
                                                            '0'
                                                        ? billingProvider
                                                            .temporaryQuantity
                                                        : 1,
                                                    proController:
                                                        TextEditingController(),
                                                    proFocusNode: FocusNode(),
                                                  ),
                                                );
                                                billingProvider
                                                    .barcodeScanner.text = "";
                                                billingProvider
                                                    .selectedProduct = null;
                                                scrollDown(); // Scroll to bottom
                                              } else {
                                                log("No product selected!");
                                                Toasts.showToastBar(
                                                    context: context,
                                                    text: "Please add product",
                                                    color: Colors.red);
                                                // Reset focus back to dropdown
                                              }
                                              dropdownFocusNode.requestFocus();
                                              dropdownController.clear();
                                              quantityVariationController
                                                  .clear();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            billingProvider
                                                .getLastOrderDetails(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              side: BorderSide(
                                                color: Color(
                                                    0xff0055989),
                                                width:
                                                    1.5,
                                              ),
                                            ),
                                            minimumSize: const Size(120, 48),
                                          ),
                                          child: MyText(
                                            text: 'Reprint',
                                            color: AppColors.secondary,
                                            fontSize:
                                                TextFormat.responsiveFontSize(
                                                    context, 12),
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (billingProvider
                                                .billingItems.isNotEmpty) {
                                              billingProvider.paymentReceived
                                                  .clear();
                                              billingProvider.paymentBalance
                                                  .clear();
                                              showPaymentBalanceDialog(context,
                                                  onPressPrint: () {
                                                if (customerProvider
                                                    .selectedCustomerId
                                                    .isEmpty) {
                                                  customerProvider
                                                      .setCustomerDetails(
                                                          customerId:
                                                              ProjectData
                                                                  .cashId,
                                                          customerName: "Cash",
                                                          customerMobile:
                                                              "1212121212",
                                                          customerAddress:
                                                              "Chennai");
                                                }
                                                billingProvider.placeOrderAndPrintBill(
                                                  context,
                                                  order: Order(
                                                      customerMobile: customerProvider
                                                          .selectedCustomerMobile,
                                                      customerId: customerProvider
                                                          .selectedCustomerId,
                                                      customerName: customerProvider
                                                          .selectedCustomerName,
                                                      customerAddress: customerProvider
                                                          .customerAddressController
                                                          .text,
                                                      cashier: billingProvider
                                                          .cashierNameController
                                                          .text
                                                          .trim(),
                                                      paymentMethod: billingProvider
                                                          .selectBillMethod
                                                          .toString(),
                                                      paymentId: billingProvider.selectBillMethod.toString() == "Cash"
                                                          ? '2'
                                                          : '1',
                                                      products: billingProvider
                                                          .billingItems,
                                                      orderGrandTotal: billingProvider
                                                          .calculatedGrandTotal()
                                                          .toString(),
                                                      orderSubTotal: billingProvider
                                                          .calculatedGrandTotal()
                                                          .toString(),
                                                      receivedAmt: billingProvider
                                                              .paymentReceived
                                                              .text
                                                              .isEmpty
                                                          ? "0.0"
                                                          : double.parse(billingProvider.paymentReceived.text).toStringAsFixed(1),
                                                      payBackAmt: (((billingProvider.paymentReceived.text.isEmpty ? 0.0 : double.parse(billingProvider.paymentReceived.text)) - billingProvider.calculatedGrandTotal()).abs().toStringAsFixed(2)),
                                                      savings: '${billingProvider.billingItems.fold(0.0, (total, item) => total + item.calculateDiscount())}'),
                                                );
                                              });
                                            } else {
                                              billingProvider
                                                  .printButtonController
                                                  .reset();
                                              Toasts.showToastBar(
                                                  context: context,
                                                  text: 'Bill List is empty',
                                                  color: Colors.red);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              side: BorderSide(
                                                color: Color(
                                                    0xff0055989),
                                                width:
                                                    1.5,
                                              ),
                                            ),
                                            minimumSize: const Size(120, 48),
                                          ),
                                          child: MyText(
                                            text: 'Print Bill',
                                            color: AppColors.secondary,
                                            fontSize:
                                                TextFormat.responsiveFontSize(
                                                    context, 12),
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              10.height,

                              ///  Billing Table :
                              billingProvider.billingItems.isEmpty
                                  ? SizedBox(
                                      width: 260,
                                      child: Column(
                                        children: [
                                          ScreenWidgets.emptyAlert(context,
                                              image:
                                                  'assets/images/noproduct.svg',
                                              text: 'No Product Found'),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xfff0f9ff),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            // border: Border.all(
                                            //   color: Color(0xfff3f3f2),
                                            //   width: 2.0,
                                            // ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.8), // darker shadow
                                                spreadRadius:
                                                    0, // no side spread
                                                blurRadius:
                                                    12, // softer & bigger shadow
                                                offset: const Offset(0,
                                                    8), // more downward distance
                                              ),
                                            ],
                                          ),
                                          child:
                                              // Table Headings
                                              Container(
                                                  color: Color(0xffF0F9FF),
                                                  child: SizedBox(
                                                    width: screenWidth * 0.98,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: DataTable(
                                                        dividerThickness: 0,
                                                        showBottomBorder: false,
                                                        dataRowHeight:
                                                            50, // Row height for all data rows
                                                        headingRowHeight: 50,
                                                        horizontalMargin: 0,
                                                        // Height for header row
                                                        border:
                                                            const TableBorder(
                                                          verticalInside:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xff9E9E9E)),
                                                          top: BorderSide.none,
                                                          bottom:
                                                              BorderSide.none,
                                                          horizontalInside:
                                                              BorderSide.none,
                                                        ), // Column lines
                                                        headingRowColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                          (states) => Color(
                                                              0xff0078D7), // Header background
                                                        ),
                                                        columns: [
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: Text(
                                                                "Change\nName",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "S.No",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "Product",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "Variation",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "Quantity",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "MRP",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "Our Price",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "Discount",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "SubTotal",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          DataColumn(
                                                            headingRowAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            label: SizedBox(
                                                              height: 50,
                                                              child: Center(
                                                                  child: MyText(
                                                                      text:
                                                                          "Remove",
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                        ],
                                                        rows: List.generate(
                                                            billingProvider
                                                                .billingItems
                                                                .length,
                                                            (index) {
                                                          final billProduct =
                                                              billingProvider
                                                                      .billingItems[
                                                                  index];
                                                          return DataRow(
                                                            color:
                                                                MaterialStateProperty
                                                                    .resolveWith(
                                                              (states) => index %
                                                                          2 ==
                                                                      0
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xffD9EEFF),
                                                            ),
                                                            cells: [
                                                              DataCell(
                                                                Center(
                                                                  child:
                                                                      IconButton(
                                                                    icon: const Icon(
                                                                        Icons.add),
                                                                    tooltip:
                                                                        'Edit Product Name',
                                                                    onPressed: () {
                                                                          if(billProduct.product.pTitle.toString().isNotEmpty){
                                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                              if (billProduct.proController != null &&
                                                                                  billProduct.proFocusNode != null) {
                                                                                setState(() {
                                                                                  billProduct.proController!.clear();
                                                                                  billProduct.proFocusNode!.requestFocus();
                                                                                  customerProvider.showInputDialog(
                                                                                    context: context,
                                                                                    width: screenWidth * 0.20,
                                                                                    height: screenHeight * 0.07,
                                                                                    controller: billProduct.proController!,
                                                                                    focus: billProduct.proFocusNode,
                                                                                    onChanged: () {
                                                                                      setState(() {
                                                                                        final text = billProduct.proController!.text;
                                                                                        if (text.isNotEmpty) {
                                                                                          billProduct.product.pTitle = "${billProduct.productTitle}/$text";
                                                                                          Navigator.of(context).pop();
                                                                                        } else {
                                                                                          Toasts.showToastBar(
                                                                                            context: context,
                                                                                            text: 'Please Fill Product Name',
                                                                                          );
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    onSubmitted: (_) {
                                                                                      final text = billProduct.proController!.text;
                                                                                      if (text.isNotEmpty) {
                                                                                        billProduct.product.pTitle = "${billProduct.productTitle}/$text";
                                                                                      }
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  );
                                                                                });
                                                                              } else {
                                                                                Toasts.showToastBar(
                                                                                    context: context,
                                                                                    text: 'One or more of the following is null:');
                                                                                debugPrint("One or more of the following is null: "
                                                                                    "proController, proFocusNode, product, productTitle");
                                                                              }
                                                                            });

                                                                          }else{
                                                                            Toasts.showToastBar(
                                                                                context: context,
                                                                                text: 'Please Select Product Name');
                                                                          }
                                                                      // Your existing edit logic here
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              DataCell(Center(
                                                                  child: Text(
                                                                "${index + 1}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ))),
                                                              DataCell(Center(
                                                                child: Text(
                                                                  billProduct.product
                                                                              .isLoose ==
                                                                          '1'
                                                                      ? "${billProduct.product.pTitle}"
                                                                      : "${billProduct.product.pTitle} ${billProduct.product.pVariation ?? ""}${billProduct.product.unit ?? ""}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )),
                                                              DataCell(
                                                                billProduct.product
                                                                            .isLoose ==
                                                                        '1'
                                                                    ? SizedBox(
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              TextEditingController(
                                                                            text:
                                                                                "${billProduct.variation / 1000}",
                                                                          ),
                                                                          onChanged:
                                                                              (value) {
                                                                            billingProvider.updateBillingItem(
                                                                              index,
                                                                              isLoose: '1',
                                                                              variation: double.tryParse(value) ?? billProduct.variation * 1000,
                                                                            );
                                                                          },
                                                                        ),
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            Text(
                                                                        billProduct.variationUnit ??
                                                                            "",
                                                                      )),
                                                              ),
                                                              DataCell(
                                                                billProduct.product
                                                                            .isLoose ==
                                                                        '0'
                                                                    ? SizedBox(
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            TextFormField(
                                                                          controller: billingProvider.quantityControllers[index] ??
                                                                              TextEditingController(
                                                                                text: "${billProduct.quantity}",
                                                                              ),
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                InputBorder.none, // Removes underline
                                                                            isDense:
                                                                                true, // Reduces padding
                                                                            contentPadding:
                                                                                EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatters: [
                                                                            LengthLimitingTextInputFormatter(5), // Limit to 5 digits
                                                                          ],
                                                                          onChanged:
                                                                              (value) {
                                                                            if (value.isNotEmpty) {
                                                                              billingProvider.updateBillingItem(
                                                                                index,
                                                                                isLoose: '0',
                                                                                quantity: int.tryParse(value) ?? billProduct.quantity,
                                                                              );
                                                                            } else {
                                                                              billingProvider.updateBillingItem(
                                                                                index,
                                                                                isLoose: '0',
                                                                                quantity: 0,
                                                                              );
                                                                            }
                                                                          },
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        "${billProduct.quantity}"),
                                                              ),
                                                              DataCell(Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  TextFormat.formattedAmount(
                                                                      billProduct
                                                                          .mrpPerProduct()),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                ),
                                                              )),
                                                              DataCell(Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(TextFormat
                                                                    .formattedAmount(
                                                                        billProduct
                                                                            .calculateOutPrice())),
                                                              )),
                                                              DataCell(Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(billProduct
                                                                    .calculateDiscount()
                                                                    .toStringAsFixed(
                                                                        2)),
                                                              )),
                                                              DataCell(Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                    TextFormat
                                                                        .formattedAmount(
                                                                  billProduct
                                                                      .calculateSubtotal(),
                                                                )),
                                                              )),
                                                              DataCell(
                                                                Center(
                                                                  child:
                                                                  IconButton(
                                                                        tooltip: 'Delete ${billProduct.product.isLoose == '1'
                                                                            ? "${billProduct.product.pTitle} ${billProduct.variation/1000}kg"
                                                                            : "${billProduct.product.pTitle} ${billProduct.variationUnit}"}',
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red),
                                                                    onPressed: () =>
                                                                        billingProvider.removeBillingItem(
                                                                            index:
                                                                                index),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                  ),
                  bottomNavigationBar: billingProvider.isLoading
                      ? 0.height
                      : SizedBox(
                          height: 180,
                          width: screenWidth,
                          child: Column(
                            children: [
                              Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 12, right: 12, bottom: 0),
                                  height: 90,
                                  width: screenWidth,
                                  child: DataTable(
                                    headingRowHeight: 40, // Height for header
                                    dataRowHeight: 40, // Height for data
                                    headingTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    border: const TableBorder(
                                      // left: BorderSide(width: 1, color: Color(0xff9E9E9E)),
                                      // right: BorderSide(width: 1, color: Color(0xff9E9E9E)),
                                      verticalInside: BorderSide(
                                          width: 1, color: Color(0xff9E9E9E)),
                                      top: BorderSide.none,
                                      bottom: BorderSide.none,
                                      horizontalInside: BorderSide.none,
                                    ),
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Color(0xff0078D7),
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Items',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Qty',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Subtotal',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Discount',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'GST',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Grand Total',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],

                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(Center(
                                            child: Text(billingProvider
                                                .calculatedTotalProducts()
                                                .toString()),
                                          )),
                                          DataCell(Center(
                                            child: Text(billingProvider
                                                .calculatedTotalQuantity()
                                                .toString()),
                                          )),
                                          DataCell(
                                              Center(
                                            child: MyText(
                                                text: billingProvider
                                                .calculatedMrpSubtotal()
                                                .toString()),
                                          )),
                                          DataCell(Center(
                                            child: Text(billingProvider
                                                .calculateTotalDiscount()
                                                .toString()),
                                          )),
                                          DataCell(Center(child: Text('0.0%'))),
                                          DataCell(Center(
                                            child: Text(TextFormat
                                                .formattedAmount(billingProvider
                                                    .calculatedGrandTotal())),
                                          )),
                                        ],
                                      ),
                                    ],
                                  )),
                              Container(
                                height: 90,
                                width: screenWidth,
                                padding: const EdgeInsets.only(
                                    top: 10, left: 12, right: 12, bottom: 0),
                                decoration: BoxDecoration(
                                  border: const Border(
                                    left: BorderSide(
                                        color: Colors.black,
                                        width: 1), // Outer left border
                                    right: BorderSide(
                                        color: Colors.black,
                                        width: 1), // Outer right border
                                  ),
                                ),
                                child: DataTable(
                                  headingRowHeight: 40,
                                  dataRowHeight: 40,
                                  dividerThickness: 0, // No horizontal dividers
                                  headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  border: const TableBorder(
                                    verticalInside: BorderSide(
                                        color: Color(0xff9E9E9E),
                                        width: 1), // Column dividers
                                    // left: BorderSide(color: Colors.black, width: 1),   // Left border
                                    // right: BorderSide(color: Colors.black, width: 1),  // Right border
                                  ),
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Color(0xffD9EEFF),
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            'Loading Charge',
                                            style: TextStyle(
                                                color: Color(0xff0078D7)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            'Cutting Charge',
                                            style: TextStyle(
                                                color: Color(0xff0078D7)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Center(
                                          child: Text(
                                            'Freight Charge',
                                            style: TextStyle(
                                                color: Color(0xff0078D7)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  rows:  [
                                    DataRow(
                                      cells: [
                                        DataCell(
                                            Center(child: TextField(
                                              controller: billingProvider.loadingCharge,
                                              focusNode: billingProvider.loadingChargeFocusNode,
                                              onSubmitted: (_){
                                                billingProvider.updateFooterButtons();
                                                billingProvider.cuttingChargeFocusNode.requestFocus();
                                              },
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(fontSize: 15),
                                              decoration: const InputDecoration(border: InputBorder.none,
                                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5)
                                              ),
                                            ),)),
                                        DataCell(Center(child: TextField(
                                          controller: billingProvider.cuttingCharge,
                                          focusNode: billingProvider.cuttingChargeFocusNode,
                                          onSubmitted: (_){
                                            billingProvider.updateFooterButtons();
                                            billingProvider.freightChargeFocusNode.requestFocus();
                                          },
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(fontSize: 15),
                                          decoration: const InputDecoration(border: InputBorder.none,
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5)
                                          ),
                                        ),)),
                                        DataCell(Center(child: TextField(
                                          controller: billingProvider.freightCharge,
                                          focusNode: billingProvider.freightChargeFocusNode,
                                          onSubmitted: (_){
                                            billingProvider.updateFooterButtons();
                                          },
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(fontSize: 15),
                                          decoration: const InputDecoration(border: InputBorder.none,
                                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5)
                                          ),
                                        ),)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ));
    });
  }

  Future<void> showPaymentBalanceDialog(
    BuildContext context, {
    required void Function() onPressPrint,
  }) async {
    final billingProvider =
        Provider.of<BillingProvider>(context, listen: false);
    billingProvider.paymentReceived.addListener(() {
      billingProvider.calculatePaymentBalance();
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer<BillingProvider>(
                builder: (context, billingProvider, _) {
              return AlertDialog(
                title: MyText(
                  text: 'Print Bill',
                  fontSize: TextFormat.responsiveFontSize(context, 23),
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                // icon: InkWell(onTap: (){
                //   Navigator.of(context).pop();
                // }, child: const Icon(Icons.clear,color: Colors.red,)),
                // iconPadding: const EdgeInsets.fromLTRB(400, 0, 1, 1),
                content: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Display Total Amount
                      RichText(
                        text: TextSpan(
                          text: 'Total Amount : ',
                          style: GoogleFonts.lato(
                            fontSize:
                                TextFormat.responsiveFontSize(context, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: TextFormat.formattedAmount(
                                  billingProvider.calculatedGrandTotal()),
                              style: GoogleFonts.lato(
                                fontSize:
                                    TextFormat.responsiveFontSize(context, 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Payment Received Input
                      MyTextField(
                        height: null,
                        labelText: "Payment Received",
                        autofocus: true,
                        isOptional: true,
                        controller: billingProvider.paymentReceived,
                        inputFormatters: InputFormatters.mobileNumberInput,
                        onEditingComplete: () {
                          billingProvider.keyboardListenerFocusNode
                              .requestFocus();
                        },
                      ),

                      // Display Balance
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: billingProvider.paymentBalance,
                        builder: (context, value, child) {
                          return RichText(
                            text: TextSpan(
                              text: 'Balance:     ',
                              style: GoogleFonts.lato(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: value.text.contains('-')
                                      ? value.text
                                      : "₹ ${value.text.isEmpty ? "0" : value.text}",
                                  style: GoogleFonts.lato(
                                    color: value.text.contains('-')
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const MyText(
                        text: 'Select Payment Method',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),

                      KeyboardListener(
                        focusNode: billingProvider.keyboardListenerFocusNode,
                        onKeyEvent: (KeyEvent event) {
                          final currentIndex = billingProvider.billMethods
                              .indexOf(billingProvider.selectBillMethod ?? "");
                          if (event is KeyDownEvent) {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowRight) {
                              int next = (currentIndex + 1) %
                                  billingProvider.billMethods.length;
                              billingProvider.changeBillMethod(
                                  billingProvider.billMethods[next]);
                              billingProvider.billMethodFocusNodes[next]
                                  .requestFocus();
                            } else if (event.logicalKey ==
                                LogicalKeyboardKey.arrowLeft) {
                              int prev = (currentIndex -
                                      1 +
                                      billingProvider.billMethods.length) %
                                  billingProvider.billMethods.length;
                              billingProvider.changeBillMethod(
                                  billingProvider.billMethods[prev]);
                              billingProvider.billMethodFocusNodes[prev]
                                  .requestFocus();
                            } else if (event.logicalKey ==
                                LogicalKeyboardKey.enter) {
                              billingProvider.printAfterChangeButtonController
                                  .start();
                              onPressPrint;
                            }
                          }
                        },
                        child: Row(
                          children: List.generate(
                              billingProvider.billMethods.length, (index) {
                            final method = billingProvider.billMethods[index];
                            return Row(
                              children: [
                                Radio<String>(
                                  value: method,
                                  focusNode:
                                      billingProvider.billMethodFocusNode,
                                  groupValue: billingProvider.selectBillMethod,
                                  onChanged: (value) {
                                    billingProvider.changeBillMethod(value!);
                                    billingProvider.billMethodFocusNodes[index].requestFocus();
                                  },
                                  focusColor: Colors
                                      .transparent, // Removes blue focus color
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent), // Removes ripple
                                  visualDensity: VisualDensity
                                      .compact, // Optional: compact spacing
                                ),
                                MyText(text: method, fontSize: 14),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Buttons.loginButton(
                    context: context,
                    loadingButtonController:
                        billingProvider.printAfterChangeButtonController,
                    toolTip: 'Print Bill',
                    height: 45,
                    onPressed: onPressPrint,
                    text: 'Print',
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }

  /// Table Header Widget :
  Widget _buildHeaderCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: MyText(
        text: text,
        fontStyle: FontStyle.normal,
        isBold: true,
        textAlign: TextAlign.center,
        color: AppColors.white,
        fontSize: 14,
      ),
    );
  }

  /// Billing Products Widget :
  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MyText(
        text: text == "null" ? "" : text,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Editable Cell :
  Widget _buildEditableCell(
      {required int index,
      required TextEditingController controller,
      required void Function(String) onChanged,
      required List<TextInputFormatter> inputFormatters,
      required void Function()? onEditingComplete}) {
    final bool isEven = index % 2 == 0;

    return MyTextField(
      controller: controller,
      isOptional: true,
      hintText: "",
      labelText: "",
      borderRadius: 5,
      inputFormatters: inputFormatters,
      textAlign: TextAlign.center,
      enabledBorderColor: isEven ? Color(0xffFFFFFF) : Color(0xffD9EEFF),
      focusedBorderColor: isEven ? Color(0xffFFFFFF) : Color(0xffD9EEFF),
      onChanged: onChanged,
      fillColor: isEven ? Color(0xffF5F5F5) : Color(0xffC5E5FF),
      onEditingComplete: onEditingComplete,
    );
  }
}

DataColumn _buildHeader(String text, double width) {
  return DataColumn(
    label: SizedBox(
      width: width,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

DataCell _buildCell(String text, double width, Alignment alignment) {
  return DataCell(
    SizedBox(
      width: width,
      child: Align(
        alignment: alignment,
        child: Text(text),
      ),
    ),
  );
}

/// Product Dropdown (Deprecated) :
// MyDropdownMenu<ProductData>(
//   enableSearch: true,
//   enableFilter: true,
//   menuHeight: 300,
//   controller: TextEditingController(
//     text: billProduct.product.isLoose == '1'
//         ? "${billProduct.productTitle} ${billProduct.variation}g"
//         : "${billProduct.productTitle} ${billProduct.variationUnit}",
//   ),
//   dropdownMenuEntries: billingProvider.productsList.map((product) {
//     return MyDropdownMenuEntry<ProductData>(
//       value: product,
//       label: product.isLoose == '1'
//           ? "${product.pTitle}"
//           : "${product.pTitle} ${product.pVariation}${product.unit}",
//       trailingIcon: Row(
//         children: [
//           MyText(
//             text : product.isLoose == '1'
//                 ? "₹${product.outPrice} (₹${product.pricePerG}/g)"
//                 : "₹${product.outPrice}",
//           ),
//         ],
//       ),
//     );
//   }).toList(),
//   // hintText: "Search product...",
//   onSelected: (selectedProduct) {
//     if (selectedProduct != null) {
//       billingProvider.updateBillingItem(
//         index,
//         isLoose: selectedProduct.isLoose.toString(),
//         variation: selectedProduct.isLoose == '1' ? 1 : 0, // Reset variation for loose
//         quantity: selectedProduct.isLoose == '0' ? 1 : 0,  // Reset quantity for non-loose
//       );
//       billProduct.product = selectedProduct; // Update product
//     }
//   },
// ),
