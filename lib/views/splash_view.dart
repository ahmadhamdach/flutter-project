import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(SplashController());
    const customGreen = Color(0xFF0B3D2E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this Icon with your Image.asset('assets/logo.png')
            const Icon(Icons.shopping_bag, size: 100, color: customGreen),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: customGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              "Tripoli Shop",
              style: TextStyle(
                color: customGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}