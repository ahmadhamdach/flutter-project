import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripoli_shop/views/checkout_page.dart';
import 'views/home_layout.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/splash_view.dart';
import 'controllers/auth_controller.dart';

void main() async {
  // 1. Initialize Flutter & Storage
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 2. Hide Navigation Bar Globally (Immersive Mode)
  // This solves the button overlap issue across all views.
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.top], // Keeps status bar icons visible
  );

  // 3. Inject Controllers
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom Tripoli Green
    const customGreen = Color(0xFF0B3D2E);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',

      // --- Global Theme Configuration ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: customGreen,
          primary: customGreen,
          secondary: customGreen,
        ),

        // AppBar Styling
        appBarTheme: const AppBarTheme(
          backgroundColor: customGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          // Ensures battery/time icons are white
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),

        // Bottom Navigation Styling
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: customGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 10,
        ),

        // Text Field Styling (Login/Register)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: customGreen, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Button Styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: customGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
      ),

      // Start the app at the Splash Screen
      initialRoute: '/splash',

      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashView(),
          transition: Transition.noTransition, // Splash should appear instantly
        ),
        GetPage(
          name: '/home',
          page: () => HomeLayout(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/checkout',
          page: () => const CheckoutPage(),
          transition: Transition.cupertino,
        ),
      ],
    );
  }
}