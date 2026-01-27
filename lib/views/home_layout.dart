import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/auth_controller.dart'; // Import AuthController
import 'home_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  final NavController nav = Get.put(NavController());
  final ProductController product = Get.put(ProductController());

  // Find the AuthController we initialized in main or login
  final AuthController auth = Get.find<AuthController>();

  final pages = [const HomePage(), CartPage(), const ProfilePage()];
  final titles = ['Shop', 'Cart', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text(titles[nav.currentIndex])),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const Text('Shop Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Shop'),
                selected: nav.currentIndex == 0,
                onTap: () { nav.changeTab(0); Get.back(); },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Cart'),
                selected: nav.currentIndex == 1,
                onTap: () { nav.changeTab(1); Get.back(); },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                selected: nav.currentIndex == 2,
                onTap: () { nav.changeTab(2); Get.back(); },
              ),
              const Divider(),

              // --- UPDATED LOGOUT SECTION ---
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Show a confirmation dialog before logging out
                  Get.defaultDialog(
                    title: "Logout",
                    middleText: "Are you sure you want to logout?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      auth.logout(); // Calls the logic in AuthController
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: pages[nav.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.currentIndex,
          onTap: nav.changeTab,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  Positioned(
                    right: 0,
                    child: GetBuilder<ProductController>(
                      builder: (_) => product.totalItems == 0
                          ? const SizedBox()
                          : CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          product.totalItems.toString(),
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    });
  }
}