import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'views/home_layout.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'controllers/auth_controller.dart'; // Ensure this import exists

void main() async {
  // 1. Initialize Flutter and Local Storage
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 2. Inject AuthController globally before the app runs
  // This prevents the "Controller not found" error in HomeLayout
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom hex color #0B3D2E
    const customGreen = Color(0xFF0B3D2E);

    // Access storage to check login status
    final storage = GetStorage();
    final bool isLoggedIn = storage.read('isLoggedIn') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',

      // Global Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: customGreen,
          primary: customGreen,
          secondary: customGreen,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: customGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        // Style for the Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: customGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        // Global Style for TextFields (Login/Register)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: customGreen, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Style for Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: customGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // Auth Logic: Decide where the user starts
      initialRoute: isLoggedIn ? '/home' : '/login',

      getPages: [
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
      ],
    );
  }
}