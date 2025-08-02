import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fullcomm_billing/data/project_data.dart';
import 'package:fullcomm_billing/res/colors.dart';
import 'package:fullcomm_billing/view_models/billing_provider.dart';
import 'package:fullcomm_billing/view_models/credentials_provider.dart';
import 'package:fullcomm_billing/view_models/customer_provider.dart';
import 'package:fullcomm_billing/views/orders/order_detail_page.dart';
import 'package:fullcomm_billing/views/splash_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => CustomersProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: '${ProjectData.title} BillEase',
        routes: {
          '/search': (context) => const OrderDetailPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          textTheme: GoogleFonts.latoTextTheme(),
          useMaterial3: true,
        ),
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
