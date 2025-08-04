// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fullcomm_billing/models/products_response.dart';
// import 'package:fullcomm_billing/res/colors.dart';
// import 'package:fullcomm_billing/res/components/bottom_widgets.dart';
// import 'package:fullcomm_billing/res/components/buttons.dart';
// import 'package:fullcomm_billing/res/components/k_loadings.dart';
// import 'package:fullcomm_billing/res/components/k_text.dart';
// import 'package:fullcomm_billing/res/components/screen_widgtes.dart';
// import 'package:fullcomm_billing/res/widgets/divider_widgets.dart';
// import 'package:fullcomm_billing/utils/input_formatters.dart';
// import 'package:fullcomm_billing/utils/sized_box.dart';
// import 'package:fullcomm_billing/utils/text_formats.dart';
// import 'package:fullcomm_billing/utils/toast_messages.dart';
// import 'package:fullcomm_billing/view_models/billing_provider.dart';
// import 'package:fullcomm_billing/view_models/credentials_provider.dart';
// import 'package:fullcomm_billing/view_models/customer_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../../data/project_data.dart';
// import '../../models/billing_product.dart';
// import '../../models/customers_response.dart';
// import '../../models/place_order.dart';
// import '../../res/components/customer_widgets.dart';
// import '../../res/components/k_dropdown_menu.dart';
// import '../../res/components/k_dropdown_menu_2.dart';
// import '../../res/components/k_text_field.dart';
// import '../../res/components/keyboard_search.dart';
// import '../../services/shortcut_intent.dart';
// import '../../utils/non_zero_int_format.dart';
//
// class BillingScreen extends StatefulWidget {
//   const BillingScreen({super.key});
//
//   @override
//   State<BillingScreen> createState() => _BillingScreenState();
// }
//
// class _BillingScreenState extends State<BillingScreen> {
//
//   final FocusNode dropdownFocusNode = FocusNode();
//   final FocusNode fieldFocusNode = FocusNode();
//   final TextEditingController dropdownController = TextEditingController();
//   final TextEditingController quantityVariationController = TextEditingController();
//
//   // For Scrolling Billing Table :
//   ScrollController scrollController = ScrollController();
//
//   void scrollDown() {
//     if (scrollController.hasClients) {
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent + kBottomNavigationBarHeight,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       log("ScrollController is not attached to any scroll view.");
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp){
//       Provider.of<BillingProvider>(context,listen: false).getProducts();  // Fetch all Products & Stocks
//       Provider.of<CustomersProvider>(context,listen: false).getAllCustomers(context);  // Fetch all Products & Stocks
//       Provider.of<CustomersProvider>(context,listen: false).resetCustomerDetails();  // Reset Customer details
//       Provider.of<BillingProvider>(context,listen: false).setBillingItems([]); // Set Billing Items with Empty Table
//     });
//
//   }
//
//   @override
//   void dispose() {
//     dropdownFocusNode.dispose();
//     fieldFocusNode.dispose();
//     dropdownController.dispose();
//     quantityVariationController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth  = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Consumer3<UserDataProvider,CustomersProvider,BillingProvider>(
//       builder: (context, userDataProvider, customerProvider, billingProvider, _) {
//         return Shortcuts(
//           shortcuts: <LogicalKeySet, Intent>{
//             LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP): const PrintIntent(),
//             LogicalKeySet(LogicalKeyboardKey.f3): const PaymentIntent(),
//             LogicalKeySet(LogicalKeyboardKey.f4): const PrintIntent(),
//           },
//           child: Actions(
//             actions: <Type, Action<Intent>>{
//               PrintIntent: PrintAction(() {
//                 // Print Bill Shortcut
//                 if(customerProvider.selectedCustomerMobile=='' || customerProvider.selectedCustomerName==''){
//                   billingProvider.printButtonController.reset();
//                   Toasts.showToastBar(context: context, text: 'Please Select a Customer',color: AppColors.toastRed);
//                 }
//                 else{
//                   // After Customer Selected
//                   if(billingProvider.billingItems.isNotEmpty){
//
//                     billingProvider.placeOrderAndPrintBill(
//                         context,
//                         order: Order(
//                             customerMobile: customerProvider.selectedCustomerMobile,
//                             customerId: customerProvider.selectedCustomerId,
//                             customerName: customerProvider.selectedCustomerName,
//                             customerAddress: customerProvider.customerAddressController.text,
//                             cashier: billingProvider.cashierNameController.text.trim(),
//                             paymentMethod: 'Cash', // Fix it
//                             paymentId: '2', // Fix it
//                             products: billingProvider.billingItems,
//                             orderGrandTotal: billingProvider.calculatedGrandTotal().toString(),
//                             orderSubTotal: billingProvider.calculatedGrandTotal().toString(),
//                         )
//                     );
//                   }
//                   else {
//                     billingProvider.printButtonController.reset();
//                     Toasts.showToastBar(context: context, text: 'Bill List is empty');
//                   }
//                 }
//               }),
//               PaymentIntent: PaymentAction((){
//                 billingProvider.paymentReceived.clear();  // Clear Text Fields
//                 billingProvider.paymentBalance.clear();
//                 billingProvider.paymentButtonController.reset();
//
//                 billingProvider.showPaymentBalanceDialog(
//                     context,
//                     onPressPrint: (){
//                       if(customerProvider.selectedCustomerMobile=='' || customerProvider.selectedCustomerName==''){
//                         billingProvider.printButtonController.reset();
//                         Toasts.showToastBar(context: context, text: 'Please Select Customer',color: AppColors.toastRed);
//                       }
//                       else{
//                         // After Customer Selected
//                         if(billingProvider.billingItems.isNotEmpty){
//
//                           billingProvider.placeOrderAndPrintBill(
//                               context,
//                               order: Order(
//                                   customerMobile: customerProvider.selectedCustomerMobile,
//                                   customerId: customerProvider.selectedCustomerId,
//                                   customerName: customerProvider.selectedCustomerName,
//                                   customerAddress: customerProvider.customerAddressController.text,
//                                   cashier: billingProvider.cashierNameController.text.trim(),
//                                   paymentMethod: 'Cash', // Fix it
//                                   paymentId: '2', // Fix it
//                                   products: billingProvider.billingItems,
//                                   orderGrandTotal: billingProvider.calculatedGrandTotal().toString(),
//                                   orderSubTotal: billingProvider.calculatedGrandTotal().toString())
//                           );
//
//                         }
//                         else{
//                           billingProvider.printButtonController.reset();
//                           Toasts.showToastBar(context: context, text: 'Bill List is empty');
//                         }
//                       }
//                     });
//               }),
//             },
//             child: PopScope(
//               canPop: false,
//               child: Scaffold(
//                 appBar: PreferredSize(
//                   preferredSize: Size.fromHeight(screenHeight * 0.20),
//                   child: Container(
//                     color: AppColors.primary.withValues(alpha:0.2),
//                     padding: const EdgeInsets.only(bottom: 3),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Top AppBar Section
//                         AppBar(
//                           toolbarHeight: screenHeight * 0.10,
//                           leading: Row(
//                             children: [
//                               10.width,
//                               SizedBox(
//                                 width: 60,height: 50,
//                                 child: FittedBox(
//                                   fit: BoxFit.cover,
//                                     child: SvgPicture.asset('assets/logo/app_logo.svg')
//                                 ),
//                               ),
//                             ],
//                           ),
//                           leadingWidth: 100,
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               const MyText(
//                                 text: "${ProjectData.title} BillEase",
//                               ),
//                               5.width,
//                               const MyText(
//                                 text: ProjectData.version,
//                                 fontSize: 11,
//                                 color: AppColors.grey,
//                               ),
//                             ],
//                           ),
//                           automaticallyImplyLeading: false,
//                           centerTitle: true,
//                           backgroundColor: AppColors.transparent,
//                           elevation: 0, // Removes shadow
//                           actions: [
//                             // Add Customer
//                             CustomerFieldWidgets.iconButton(
//                               context: context,
//                               toolTip: 'Add Customer',
//                               icon: 'assets/icons/add_customer.svg',
//                               onPressed: () {
//                                 customerProvider.addCustomerDialog(context);
//                               },
//                             ),
//
//                             const SizedBox(width: 20),
//
//                             // Refresh Stock
//                             CustomerFieldWidgets.iconButton(
//                               context: context,
//                               toolTip: 'Refresh Stock Status',
//                               icon: 'assets/icons/refresh_stock.svg',
//                               onPressed: () {
//                                 billingProvider.getProducts();
//                               },
//                             ),
//
//                             // Options :
//                             PopupMenuButton<int>(
//                               icon: Padding(
//                                 padding: const EdgeInsets.only(right: 8,top: 5,bottom: 5,left: 10),
//                                 child: Tooltip(
//                                   message: 'Options',
//                                   child: CircleAvatar(
//                                     radius: 23,
//                                     backgroundColor: Colors.yellow.withValues(alpha:0.4),
//                                     child: SvgPicture.asset('assets/icons/options.svg'),
//                                   ),
//                                 ),
//                               ),
//                               onSelected: (value) {
//                                 if (value == 1) {
//                                   userDataProvider.logout(context);
//                                 }
//                               },
//                               itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
//                                 const PopupMenuItem<int>(
//                                   value: 1, // Unique identifier for the item
//                                   child: Text('Logout'),
//                                 ),
//                               ],
//                             ),
//
//                           ],
//                         ),
//
//                         5.height,
//
//                         // Bottom Section (Customer Details and Inputs)
//                         Flexible(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Cashier Name
//                                 MyTextField(
//                                   controller: billingProvider.cashierNameController,
//                                   labelText: 'Cashier Name',
//                                   textInputAction: TextInputAction.done,
//                                   onChanged: (value) async {
//                                     // Your onChanged logic
//                                   },
//                                 ),
//                                 // const SizedBox(width: 8),
//                                 // Customer Dropdown and Address
//                                 SizedBox(
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       // Customer Contact Dropdown
//                                       MyDropdownMenu2<CustomerData>(
//                                         width: screenWidth * 0.20,
//                                         labelText: 'Cust. Contact',
//                                         hintText: "Select Customer...",
//                                         menuHeight: screenHeight * 0.40,
//                                         enableSearch: true,
//                                         enableFilter: true,
//                                         dropdownMenuEntries: customerProvider.allCustomersList.map((customer) {
//                                           return MyDropdownMenuEntry2(
//                                             value: customer,
//                                             label: '${customer.name} - ${customer.mobile}',
//                                           );
//                                         }).toList(),
//                                         onSelected: (value) {
//                                           customerProvider.setCustomerDetails(
//                                             customerId: value!.userId.toString(),
//                                             customerName: value.name.toString(),
//                                             customerMobile: value.mobile.toString(),
//                                             customerAddress:
//                                             "${value.addressLine1 ?? ''} ${value.area ?? ''} ${value.city ?? ''}-${value.pincode ?? ''}",
//                                           );
//                                         },
//                                       ),
//
//                                       5.width,
//
//                                       // Customer Address
//                                       MyTextField(
//                                         width: screenWidth * 0.20,
//                                         controller: customerProvider.customerAddressController,
//                                         labelText: 'Cust. Address',
//                                         maxLines: null,
//                                         minLines: 2,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 body: billingProvider.isLoading ? LoadingWidgets.circleLoading()
//                     : Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     /// Fixed Header:
//                     // Row containing Search Dropdown and Variation/Quantity field
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         /// Searchable DropdownMenu (Header)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               SizedBox(
//                                 width : screenWidth * 0.55,
//                                 child: KeyboardDropdownField<ProductData>(
//                                   focusNode:dropdownFocusNode,
//                                   items: billingProvider.productsList,
//                                       hintText: "Search Product...",
//                                       labelText: "Product",
//                                   labelBuilder: (product) => product.isLoose == '0'
//                                       ? '${product.pTitle} ${product.pVariation}${product.unit}'
//                                       : '${product.pTitle} (${product.pVariation})',
//                                   itemBuilder: (product) => Container(
//                                     width : screenWidth * 0.55,
//                                     padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         MyText(
//                                           text:product.isLoose == '0'
//                                               ? '${product.pTitle} ${product.pVariation}${product.unit}'
//                                               : '${product.pTitle} (${product.pVariation})',
//                                           color: Colors.black,
//                                           fontSize: 14,
//                                         ),
//                                         SizedBox(
//                                           width: 50,
//                                           child: MyText(
//                                             text: product.isLoose == '1'
//                                                 ? "₹${(double.parse(product.mrp.toString()) / (double.parse(product.stockQty.toString()) / 1000)).toStringAsFixed(1)}/kg"
//                                                 : "₹${double.parse(product.mrp.toString()).toStringAsFixed(1)}",
//                                             fontSize: 14,
//                                             color: Colors.orange,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   textEditingController: dropdownController,
//                                   onSelected: (product) {
//                                     billingProvider.selectedProduct = product;
//                                     billingProvider.updateTemporaryFields(
//                                       variation: product.isLoose == '1' ? 1.0 : null,
//                                       quantity: product.isLoose == '0' ? 1 : null,
//                                     );
//                                     fieldFocusNode.requestFocus();
//                                                                 },
//                                   onClear: () {
//                                     billingProvider.selectedProduct = null;
//                                     billingProvider.updateTemporaryFields(
//                                       quantity: 0,
//                                       variation: 0.0,
//                                     );
//                                     quantityVariationController.clear();
//                                   },
//
//                                 ),
//                               ),
//                               10.width,
//                               /// Variation/Quantity field (Header)
//                               Container(
//                                 width: screenWidth * 0.20,
//                                 alignment: Alignment.center,
//                                 child: MyTextField(
//                                   focusNode: fieldFocusNode,
//                                   height: 50,
//                                   controller: quantityVariationController,
//                                   labelText: billingProvider.selectedProduct?.isLoose == '1'
//                                       ? "Variation(kg)"
//                                       : "Quantity",
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: billingProvider.selectedProduct?.isLoose == '1'
//                                       ? InputFormatters.variationInput
//                                       //: InputFormatters.quantityInput,
//                                       : [
//                                     StrictNonZeroIntFormatter(),
//                                   ],
//                                   onChanged: (value) {
//                                     print("billingProvider.selectedProduct ${billingProvider.selectedProduct}");
//                                     if (billingProvider.selectedProduct != null) {
//                                       if (billingProvider.selectedProduct!.isLoose == '1') {
//                                         billingProvider.updateTemporaryFields(
//                                           variation: (double.parse(value) * 1000),
//                                         );
//                                       } else {
//                                         billingProvider.updateTemporaryFields(
//                                           quantity: int.tryParse(value) ?? billingProvider.temporaryQuantity,
//                                         );
//                                       }
//                                     } else {
//                                       // Optionally reset focus or show a message
//                                       //dropdownFocusNode.requestFocus();
//                                       Toasts.showToastBar(context: context, text: "Please add product",color: Colors.red);
//                                     }
//                                   },
//                                   onFieldSubmitted: (_) {
//                                     if (billingProvider.selectedProduct != null) {
//                                       billingProvider.addBillingItem(
//                                         BillingItem(
//                                           id: billingProvider.selectedProduct!.id!.toString(),
//                                           product: billingProvider.selectedProduct!,
//                                           productTitle: billingProvider.selectedProduct!.isLoose == '0'
//                                               ? billingProvider.selectedProduct!.pTitle.toString()
//                                               : "${billingProvider.selectedProduct!.pTitle} ${billingProvider.temporaryVariation/1000}kg",
//                                           variation: billingProvider.selectedProduct!.isLoose == '1' ? billingProvider.temporaryVariation : 1,
//                                           variationUnit:  "${billingProvider.selectedProduct!.pVariation}${billingProvider.selectedProduct!.unit}",
//                                           quantity: billingProvider.selectedProduct!.isLoose == '0' ? billingProvider.temporaryQuantity : 1,
//                                         ),
//                                       );
//                                       scrollDown(); // Scroll to bottom
//                                     }
//                                     else {
//                                       log("No product selected!");
//                                       Toasts.showToastBar(context: context, text: "Please add product",color: Colors.red);
//                                       // Reset focus back to dropdown
//                                     }
//                                     dropdownFocusNode.requestFocus();
//                                     dropdownController.clear();
//                                     quantityVariationController.clear();
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // SizedBox(
//                         //   width: screenWidth * 0.55,
//                         //   child: MyDropdownMenu<ProductData>(
//                         //     width: screenWidth * 0.55,
//                         //     enableSearch: true,
//                         //     enableFilter: true,
//                         //     menuHeight: 300,
//                         //     controller: dropdownController,
//                         //     focusNode: dropdownFocusNode,
//                         //     dropdownMenuEntries: billingProvider.productsList.map((product) {
//                         //       return MyDropdownMenuEntry<ProductData>(
//                         //         value: product,
//                         //         enabled: true,
//                         //         label: product.isLoose == '0'
//                         //             ? '${product.pTitle} ${product.pVariation ?? ""}${product.unit ?? ""}'
//                         //             : '${product.pTitle} (${product.pVariation ?? ""})',
//                         //         trailingIcon: Row(
//                         //           mainAxisAlignment: MainAxisAlignment.end,
//                         //           children: [
//                         //             SizedBox(
//                         //               width: 75,
//                         //               child: MyText(
//                         //                 text: product.isLoose == '1'
//                         //                     ? "₹${(double.parse(product.mrp.toString()) / (double.parse(product.stockQty.toString()) / 1000)).toStringAsFixed(1)}/kg"
//                         //                     : "₹${double.parse(product.mrp.toString()).toStringAsFixed(1)}",
//                         //                 textDecoration: TextDecoration.lineThrough,
//                         //               ),
//                         //             ),
//                         //             10.width,
//                         //             SizedBox(
//                         //               width: 75,
//                         //               child: MyText(
//                         //                 text: product.isLoose == '1'
//                         //                     ? () {
//                         //                   final pricePerG = double.tryParse(product.pricePerG?.toString() ?? '') ?? 0.0;
//                         //                   final pricePerKg = pricePerG * 1000;
//                         //                   return "₹${pricePerG.toStringAsFixed(2)}/g\n(₹${pricePerKg.toStringAsFixed(2)}/kg)";
//                         //                 }()
//                         //                     : () {
//                         //                   final outPrice = double.tryParse(product.outPrice?.toString() ?? '') ?? 0.0;
//                         //                   return "₹${outPrice.toStringAsFixed(1)}";
//                         //                 }(),
//                         //               ),
//                         //             ),
//                         //
//                         //           ],
//                         //         ),
//                         //       );
//                         //     }).toList(),
//                         //     menuStyle: const MenuStyle(
//                         //       backgroundColor: WidgetStatePropertyAll(AppColors.white),
//                         //     ),
//                         //     hintText: "Search Product...",
//                         //     labelText: "Product",
//                         //     onSelected: (ProductData? selectedProduct) {
//                         //       if (selectedProduct != null) {
//                         //         billingProvider.selectedProduct = selectedProduct;
//                         //         billingProvider.updateTemporaryFields(
//                         //           variation: selectedProduct.isLoose == '1' ? 1.0 : null,
//                         //           quantity: selectedProduct.isLoose == '0' ? 1 : null,
//                         //         );
//                         //         fieldFocusNode.requestFocus();
//                         //       }
//                         //     },
//                         //   ),
//                         // ),
//
//                             // Payment Mode
//                             // Buttons.footerButton(
//                             //     context,
//                             //     text: 'Payment',
//                             //     toolTip: 'Payment Balance\n(Press F3)',
//                             //     loadingButtonController: billingProvider.paymentButtonController,
//                             //     onPressed: (){
//                             //
//                             //       billingProvider.paymentReceived.clear();  // Clear Text Fields
//                             //       billingProvider.paymentBalance.clear();
//                             //
//                             //       billingProvider.paymentButtonController.reset();
//                             //
//                             //       billingProvider.showPaymentBalanceDialog(
//                             //           context,
//                             //           onPressPrint: (){
//                             //             if(customerProvider.selectedCustomerMobile == ''
//                             //                 || customerProvider.selectedCustomerName == ''){
//                             //               billingProvider.printButtonController.reset();
//                             //               Toasts.showToastBar(context: context, text: 'Please Select Customer',
//                             //                   color: AppColors.toastRed);
//                             //             }
//                             //             else{
//                             //               // After Selecting Customer :
//                             //               if(billingProvider.billingItems.isNotEmpty){
//                             //
//                             //                 billingProvider.placeOrderAndPrintBill(
//                             //                     context,
//                             //                     order: Order(
//                             //                         customerMobile: customerProvider.selectedCustomerMobile,
//                             //                         customerId: customerProvider.selectedCustomerId,
//                             //                         customerName: customerProvider.selectedCustomerName,
//                             //                         customerAddress: customerProvider.customerAddressController.text,
//                             //                         cashier: billingProvider.cashierNameController.text.trim(),
//                             //                         paymentMethod: 'Cash', // Fix it
//                             //                         paymentId: '2', // Fix it
//                             //                         products: billingProvider.billingItems,
//                             //                         orderGrandTotal: billingProvider.calculatedGrandTotal().toString(),
//                             //                         orderSubTotal: billingProvider.calculatedGrandTotal().toString())
//                             //                 );
//                             //
//                             //               }
//                             //               else{
//                             //                 billingProvider.printButtonController.reset();
//                             //                 Toasts.showToastBar(context: context, text: 'Bill List is empty');
//                             //               }
//                             //             }
//                             //           });
//                             //
//                             //       billingProvider.paymentButtonController.reset();
//                             //     }
//                             //     ),
//
//                             // Print Bill Button
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ElevatedButton(
//                                 onPressed: (){
//                                   if(billingProvider.billingItems.isNotEmpty){
//                                     billingProvider.paymentReceived.clear();
//                                     billingProvider.paymentBalance.clear();
//                                     showPaymentBalanceDialog(
//                                         context,
//                                         onPressPrint: (){
//                                           // if(customerProvider.selectedCustomerMobile == ''
//                                           //     || customerProvider.selectedCustomerName == ''){
//                                           //   billingProvider.printButtonController.reset();
//                                           //   Toasts.showToastBar(context: context, text: 'Please Select Customer',
//                                           //       color: AppColors.toastRed);
//                                           // }
//                                           // else{
//                                           // After Selecting Customer :
//                                           if(customerProvider.selectedCustomerId.isEmpty){
//                                             customerProvider.setCustomerDetails(
//                                                 customerId: ProjectData.cashId, customerName: "Cash",
//                                                 customerMobile: "1212121212",
//                                                 customerAddress: "Chennai");
//                                           }
//                                           billingProvider.placeOrderAndPrintBill(
//                                               context,
//                                               order: Order(
//                                                   customerMobile: customerProvider.selectedCustomerMobile,
//                                                   customerId: customerProvider.selectedCustomerId,
//                                                   customerName: customerProvider.selectedCustomerName,
//                                                   customerAddress: customerProvider.customerAddressController.text,
//                                                   cashier: billingProvider.cashierNameController.text.trim(),
//                                                   paymentMethod: billingProvider.selectBillMethod.toString(),
//                                                   paymentId: billingProvider.selectBillMethod.toString()=="Cash"?'2':'1',
//                                                   products: billingProvider.billingItems,
//                                                   orderGrandTotal: billingProvider.calculatedGrandTotal().toString(),
//                                                   orderSubTotal: billingProvider.calculatedGrandTotal().toString())
//                                           );
//
//                                           // }
//                                         });
//                                   }
//                                   else{
//                                     billingProvider.printButtonController.reset();
//                                     Toasts.showToastBar(context: context, text: 'Bill List is empty',color: Colors.red);
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColors.primary
//                                 ),
//                                 child: MyText(
//                                   text : 'Print Bill',
//                                   color: AppColors.secondary,
//                                   fontSize: TextFormat.responsiveFontSize(context, 16),
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ),
//                             // Buttons.footerButton(
//                             //     context,
//                             //     text: 'Print Bill',
//                             //     toolTip: 'Place Order\n(Press F4)',
//                             //     loadingButtonController: billingProvider.printButtonController,
//                             //     onPressed: (){
//                             //             billingProvider.paymentReceived.clear();  // Clear Text Fields
//                             //             billingProvider.paymentBalance.clear();
//                             //            setState(() {
//                             //              billingProvider.paymentButtonController.reset();
//                             //            });
//                             //             showPaymentBalanceDialog(
//                             //                 context,
//                             //                 onPressPrint: (){
//                             //                   // if(customerProvider.selectedCustomerMobile == ''
//                             //                   //     || customerProvider.selectedCustomerName == ''){
//                             //                   //   billingProvider.printButtonController.reset();
//                             //                   //   Toasts.showToastBar(context: context, text: 'Please Select Customer',
//                             //                   //       color: AppColors.toastRed);
//                             //                   // }
//                             //                   // else{
//                             //                     // After Selecting Customer :
//                             //                     if(billingProvider.billingItems.isNotEmpty){
//                             //                       if(customerProvider.selectedCustomerId.isEmpty){
//                             //                         customerProvider.setCustomerDetails(
//                             //                             customerId: "577", customerName: "Cash",
//                             //                             customerMobile: "1212121212",
//                             //                             customerAddress: "Chennai");
//                             //                       }
//                             //                       billingProvider.placeOrderAndPrintBill(
//                             //                           context,
//                             //                           order: Order(
//                             //                               customerMobile: customerProvider.selectedCustomerMobile,
//                             //                               customerId: customerProvider.selectedCustomerId,
//                             //                               customerName: customerProvider.selectedCustomerName,
//                             //                               customerAddress: customerProvider.customerAddressController.text,
//                             //                               cashier: billingProvider.cashierNameController.text.trim(),
//                             //                               paymentMethod: billingProvider.selectBillMethod.toString(),
//                             //                               paymentId: billingProvider.selectBillMethod.toString()=="Cash"?'2':'1',
//                             //                               products: billingProvider.billingItems,
//                             //                               orderGrandTotal: billingProvider.calculatedGrandTotal().toString(),
//                             //                               orderSubTotal: billingProvider.calculatedGrandTotal().toString())
//                             //                       );
//                             //                     }
//                             //                     else{
//                             //                       billingProvider.printButtonController.reset();
//                             //                       Toasts.showToastBar(context: context, text: 'Bill List is empty');
//                             //                     }
//                             //                  // }
//                             //                 });
//                             //
//                             //       // if(customerProvider.selectedCustomerMobile==''
//                             //       //     || customerProvider.selectedCustomerName==''){
//                             //       //   billingProvider.printButtonController.reset();
//                             //       //   Toasts.showToastBar(context: context, text: 'Please Select Customer',color: AppColors.toastRed);
//                             //       // }
//                             //       // else{
//                             //         // After Customer Selected
//                             //         // if(billingProvider.billingItems.isNotEmpty){
//                             //         //   billingProvider.placeOrderAndPrintBill(
//                             //         //       context,
//                             //         //       order: Order(
//                             //         //           customerMobile: customerProvider.selectedCustomerMobile,
//                             //         //           customerId: customerProvider.selectedCustomerId,
//                             //         //           customerName: customerProvider.selectedCustomerName,
//                             //         //           customerAddress: customerProvider.customerAddressController.text,
//                             //         //           cashier: billingProvider.cashierNameController.text.trim(),
//                             //         //           paymentMethod: 'Cash', // Fix it
//                             //         //           paymentId: '2', // Fix it
//                             //         //           products: billingProvider.billingItems,
//                             //         //           orderGrandTotal: billingProvider.calculatedGrandTotal().toString(),
//                             //         //           orderSubTotal: billingProvider.calculatedGrandTotal().toString())
//                             //         //   );
//                             //         // }
//                             //         // else{
//                             //         //   billingProvider.printButtonController.reset();
//                             //         //   Toasts.showToastBar(context: context, text: 'Bill List is empty');
//                             //         // }
//                             //       //}
//                             //
//                             //     }
//                             // ),
//                       ],
//                     ),
//
//                     ///  Billing Table :
//                     Expanded(
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                             child: Column(
//                               children: [
//                                 // Table Headings
//                                 Container(
//                                   color: AppColors.primary,
//                                   padding: const EdgeInsets.symmetric(vertical: 8),
//                                   child: Row(
//                                     children: [
//                                       // Fixed-width for S.No
//                                       SizedBox(width: 60, child: _buildHeaderCell("S.No")),
//
//                                       // Flexible width for Product
//                                       Expanded(flex: 3,
//                                           child: Align(
//                                               alignment: Alignment.centerLeft,
//                                               child: _buildHeaderCell("Product"))),
//
//                                       // Flexible width for Variation
//                                       Expanded(flex: 2, child: _buildHeaderCell("Variation")),
//
//                                       // Flexible width for Quantity
//                                       Expanded(flex: 2, child: _buildHeaderCell("Quantity")),
//
//                                       // Flexible width for MRP
//                                       Expanded(flex: 1, child: _buildHeaderCell("MRP")),
//
//                                       // Flexible width for Our Price
//                                       Expanded(flex: 2, child: _buildHeaderCell("Our Price")),
//
//                                       // Flexible width for Discount
//                                       Expanded(flex: 1, child: _buildHeaderCell("Discount")),
//
//                                       // Flexible width for Subtotal
//                                       Expanded(flex: 2, child: _buildHeaderCell("Subtotal")),
//
//                                     ],
//                                   ),
//                                 ),
//
//                                 /// Billing Items (Table)
//                                 Expanded(
//                                   child: billingProvider.billingItems.isNotEmpty ? ListView.builder(
//                                     controller: scrollController,
//                                     itemCount: billingProvider.billingItems.length,
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, index) {
//
//                                       final billProduct = billingProvider.billingItems[index];
//                                       return Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Row(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children: [
//
//                                               /// S.No :
//                                               SizedBox(
//                                                   width: 60,
//                                                   child: _buildCell("${index + 1}")),
//
//                                               /// Product Title :
//                                               Expanded(
//                                                 flex: 3,
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     MyText(text: billProduct.product.isLoose == '1'
//                                                                   ? "${billProduct.product.pTitle}"
//                                                                   : "${billProduct.product.pTitle} ${billProduct.product.pVariation ?? ""}${billProduct.product.unit ?? ""}",),
//                                                     10.width,
//                                                     /// Delete Option :
//                                                     IconButton(
//                                                         tooltip: 'Delete ${billProduct.product.isLoose == '1'
//                                                             ? "${billProduct.productTitle} ${billProduct.variation/1000}kg"
//                                                             : "${billProduct.productTitle} ${billProduct.variationUnit}"}',
//                                                         onPressed: (){
//                                                           billingProvider.removeBillingItem(index: index);
//                                                         },
//                                                         icon: const Icon(Icons.delete_forever)
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//
//                                               /// Editable Variation
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: billProduct.product.isLoose == '1'
//                                                     ? _buildEditableCell(
//                                                   index: index,
//                                                   controller: TextEditingController(
//                                                     text: "${billProduct.variation/1000}",
//                                                   ),
//                                                   onChanged: (value) {
//                                                     billingProvider.updateBillingItem(
//                                                       index,
//                                                       isLoose: '1',
//                                                       variation: double.tryParse(value) ?? billProduct.variation * 1000,
//                                                     );
//                                                   },
//                                                   inputFormatters: InputFormatters.variationInput
//                                                 )
//                                                     : _buildCell(billProduct.variationUnit=="nullnull"?"":billProduct.variationUnit),),
//
//                                               // Editable Quantity
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: billProduct.product.isLoose == '0'
//                                                     ? _buildEditableCell(
//                                                   index: index,
//                                                   controller: billingProvider.quantityControllers[index] ?? TextEditingController(
//                                                     text: "${billProduct.quantity}",
//                                                   ),
//                                                   onChanged: (value){
//                                                     if(value.isNotEmpty){
//                                                       billingProvider.updateBillingItem(
//                                                         index,
//                                                         isLoose: '0',
//                                                         quantity: int.tryParse(value) ?? billProduct.quantity,
//                                                       );
//                                                     }
//                                                   },
//                                                   inputFormatters:[
//                                                     StrictNonZeroIntFormatter(),
//                                                   ]
//                                                 )
//                                                     : _buildCell("${billProduct.quantity}"),),
//
//                                               // MRP
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: _buildCell(TextFormat.formattedAmount(billProduct.mrpPerProduct()))),
//
//                                               // Our Price
//                                               Expanded(
//                                                   flex: 2,
//                                                   child: _buildCell(TextFormat.formattedAmount(billProduct.calculateOutPrice()))),
//
//                                               // Editable Discount
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: _buildCell(
//                                                   billProduct.calculateDiscount().toStringAsFixed(2),
//                                                 ),
//                                               ),
//
//                                               /// Subtotal
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: _buildCell(
//                                                   TextFormat.formattedAmount(billProduct.calculateSubtotal()),
//                                                 ),
//                                               ),
//
//                                             ],
//                                           ),
//                                           DividerWidgets.mainDivider()
//                                         ],
//                                       );
//                                     },
//                                   )
//                                       : ScreenWidgets.emptyAlert(
//                                       context,
//                                       image: 'assets/images/empty_bill.png',
//                                       text: ''),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 bottomNavigationBar: billingProvider.isLoading ? 0.height
//                     : Container(
//                   color: AppColors.primary.withValues(alpha:0.1),
//                   padding: const EdgeInsets.only(top: 8,left: 12,right: 12,bottom: 8),
//                   height: screenHeight * 0.12,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       BottomWidgets.valueCard(context: context, title: 'Items', value: billingProvider.calculatedTotalProducts().toString()),
//                       BottomWidgets.valueCard(context: context, title: 'Qty', value: billingProvider.calculatedTotalQuantity().toString()),
//                       BottomWidgets.valueCard(context: context, title: 'Subtotal', value: billingProvider.calculatedMrpSubtotal().toString()),
//                       BottomWidgets.valueCard(context: context, title: 'Discount', value: billingProvider.calculateTotalDiscount()),
//                       BottomWidgets.valueCard(context: context, title: 'GST', value: '0.0%'),
//                       BottomWidgets.valueCard(
//                           context: context,
//                           title: 'Grand Total',
//                           value: TextFormat.formattedAmount(billingProvider.calculatedGrandTotal())
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     );
//   }
//
//   void showPaymentBalanceDialog(
//       BuildContext context, {required void Function() onPressPrint,}) {
//     final  billingProvider= Provider.of<BillingProvider>(context, listen: false);
//     billingProvider.paymentReceived.addListener(() {
//       billingProvider.calculatePaymentBalance();
//     });
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//           return Consumer<BillingProvider>(
//               builder: (context,billingProvider,_){
//                 return AlertDialog(
//                   title: MyText(
//                     text: 'Print Bill',
//                     fontSize: TextFormat.responsiveFontSize(context, 23),
//                     fontWeight: FontWeight.bold,
//                     textAlign: TextAlign.center,
//                   ),
//                   // icon: InkWell(onTap: (){
//                   //   Navigator.of(context).pop();
//                   // }, child: const Icon(Icons.clear,color: Colors.red,)),
//                   // iconPadding: const EdgeInsets.fromLTRB(400, 0, 1, 1),
//                   content: Container(
//                     alignment: Alignment.center,
//                     height: MediaQuery.of(context).size.height * 0.30,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         // Display Total Amount
//                         RichText(
//                           text: TextSpan(
//                             text: 'Total Amount : ',
//                             style: GoogleFonts.lato(
//                               fontSize: TextFormat.responsiveFontSize(context, 20),
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: TextFormat.formattedAmount(billingProvider.calculatedGrandTotal()),
//                                 style: GoogleFonts.lato(
//                                   fontSize: TextFormat.responsiveFontSize(context, 20),
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green.shade800,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Payment Received Input
//                         MyTextField(
//                           height: null,
//                           labelText: "Payment Received",
//                           autofocus: true,
//                           controller: billingProvider.paymentReceived,
//                           inputFormatters: InputFormatters.mobileNumberInput,
//                           onEditingComplete: (){
//                             billingProvider.keyboardListenerFocusNode.requestFocus();
//                           },
//                         ),
//
//                         // Display Balance
//                         ValueListenableBuilder<TextEditingValue>(
//                           valueListenable: billingProvider.paymentBalance,
//                           builder: (context, value, child) {
//                             return RichText(
//                               text: TextSpan(
//                                 text: 'Balance:     ',
//                                 style: GoogleFonts.lato(
//                                   fontSize: 19,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                     text: value.text.contains('-')
//                                         ? value.text
//                                         : "₹ ${value.text.isEmpty?"0":value.text}",
//                                     style: GoogleFonts.lato(
//                                       color: value.text.contains('-')
//                                           ? Colors.red
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         const MyText(text: 'Select Payment Method',fontSize: 16,fontWeight: FontWeight.bold,),
//                         // Row(
//                         //   children: [
//                         //     Radio(
//                         //       value: "Cash",
//                         //       groupValue: billingProvider.selectBillMethod,
//                         //       onChanged: (value) {
//                         //         billingProvider.changeBillMethod(value!);
//                         //       },
//                         //     ),
//                         //     const MyText(text: 'Cash', fontSize: 14),
//                         //     Radio(
//                         //       value: "Money Transfer",
//                         //       groupValue: billingProvider.selectBillMethod,
//                         //       onChanged: (value) {
//                         //         print("value $value");
//                         //         billingProvider.changeBillMethod(value!);
//                         //       },
//                         //     ),
//                         //     const MyText(text: 'Money Transfer', fontSize: 14),
//                         //     Radio(
//                         //       value: "Cheque",
//                         //       groupValue: billingProvider.selectBillMethod,
//                         //       onChanged: (value) {
//                         //         billingProvider.changeBillMethod(value!);
//                         //       },
//                         //     ),
//                         //     const MyText(text: 'Cheque', fontSize: 14),
//                         //   ],
//                         // )
//                         KeyboardListener(
//                           focusNode: billingProvider.keyboardListenerFocusNode,
//                           onKeyEvent: (KeyEvent event) {
//                             final currentIndex =  billingProvider.billMethods.indexOf( billingProvider.selectBillMethod ?? "");
//                             if (event is KeyDownEvent) {
//                               if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
//                                 int next = (currentIndex + 1) %  billingProvider.billMethods.length;
//                                 billingProvider.changeBillMethod( billingProvider.billMethods[next]);
//                                 billingProvider.billMethodFocusNodes[next].requestFocus();
//                               } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
//                                 int prev = (currentIndex - 1 +  billingProvider.billMethods.length) %  billingProvider.billMethods.length;
//                                 billingProvider.changeBillMethod( billingProvider.billMethods[prev]);
//                                 billingProvider.billMethodFocusNodes[prev].requestFocus();
//                               }else if(event.logicalKey == LogicalKeyboardKey.enter){
//                                 billingProvider.printAfterChangeButtonController.start();
//                                 onPressPrint;
//
//                               }
//                             }
//                           },
//                           child: Row(
//                             children: List.generate( billingProvider.billMethods.length, (index) {
//                               final method =  billingProvider.billMethods[index];
//                               return Row(
//                                 children: [
//                                   Radio<String>(
//                                     value: method,
//                                     focusNode:  billingProvider.billMethodFocusNode,
//                                     groupValue:  billingProvider.selectBillMethod,
//                                     onChanged: (value) {
//                                       billingProvider.changeBillMethod(value!);
//                                       billingProvider.billMethodFocusNodes[index].requestFocus();
//                                     },
//                                   ),
//                                   MyText(text: method, fontSize: 14),
//                                 ],
//                               );
//                             }),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   actions: [
//                     Buttons.loginButton(
//                       context: context,
//                       loadingButtonController:  billingProvider.printAfterChangeButtonController,
//                       toolTip: 'Print Bill',
//                       height: 45,
//                       onPressed: onPressPrint,
//                       text: 'Print',
//                     ),
//                   ],
//                 );
//               });},
//         );
//       },
//     );
//   }
//
//   /// Table Header Widget :
//   Widget _buildHeaderCell(String text) {
//     return Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: MyText(
//         text: text,
//         fontWeight: FontWeight.bold,
//         textAlign: TextAlign.center,
//         color: AppColors.black,
//         fontSize: 14,
//       ),
//     );
//   }
//
//   /// Billing Products Widget :
//   Widget _buildCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: MyText(
//         text: text=="null"?"":text,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   /// Editable Cell :
//   Widget _buildEditableCell({
//     required int index,
//     required TextEditingController controller,
//     required void Function(String) onChanged,
//     required List<TextInputFormatter> inputFormatters
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: MyTextField(
//         controller: controller,
//         height: 50,
//         inputFormatters: inputFormatters,
//         textAlign: TextAlign.center,
//         onChanged: onChanged,
//       ),
//     );
//   }
//
// }
//
//
// /// Product Dropdown (Deprecated) :
// // MyDropdownMenu<ProductData>(
// //   enableSearch: true,
// //   enableFilter: true,
// //   menuHeight: 300,
// //   controller: TextEditingController(
// //     text: billProduct.product.isLoose == '1'
// //         ? "${billProduct.productTitle} ${billProduct.variation}g"
// //         : "${billProduct.productTitle} ${billProduct.variationUnit}",
// //   ),
// //   dropdownMenuEntries: billingProvider.productsList.map((product) {
// //     return MyDropdownMenuEntry<ProductData>(
// //       value: product,
// //       label: product.isLoose == '1'
// //           ? "${product.pTitle}"
// //           : "${product.pTitle} ${product.pVariation}${product.unit}",
// //       trailingIcon: Row(
// //         children: [
// //           MyText(
// //             text : product.isLoose == '1'
// //                 ? "₹${product.outPrice} (₹${product.pricePerG}/g)"
// //                 : "₹${product.outPrice}",
// //           ),
// //         ],
// //       ),
// //     );
// //   }).toList(),
// //   // hintText: "Search product...",
// //   onSelected: (selectedProduct) {
// //     if (selectedProduct != null) {
// //       billingProvider.updateBillingItem(
// //         index,
// //         isLoose: selectedProduct.isLoose.toString(),
// //         variation: selectedProduct.isLoose == '1' ? 1 : 0, // Reset variation for loose
// //         quantity: selectedProduct.isLoose == '0' ? 1 : 0,  // Reset quantity for non-loose
// //       );
// //       billProduct.product = selectedProduct; // Update product
// //     }
// //   },
// // ),
