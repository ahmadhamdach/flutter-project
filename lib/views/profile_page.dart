import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart'; // Make sure to import your AuthController

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Find the AuthController instance
    final AuthController auth = Get.find<AuthController>();

    // 2. Read the saved data from GetStorage via the controller
    final String userEmail = auth.storage.read('userEmail') ?? 'no-email@example.com';
    // You can split the email to get a "Name" or just use a placeholder for now
    final String userName = userEmail.split('@')[0].capitalizeFirst ?? 'User';

    final customGreen = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Picture Section
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: customGreen.withOpacity(0.1),
                  child: Icon(Icons.person, size: 80, color: customGreen),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: customGreen,
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 3. Display the dynamic data
          Text(
            userName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
              userEmail,
              style: const TextStyle(color: Colors.grey)
          ),

          const SizedBox(height: 30),

          // Settings Options
          _buildProfileTile(Icons.shopping_bag_outlined, 'My Orders', () {}),
          _buildProfileTile(Icons.favorite_border, 'Wishlist', () {}),
          _buildProfileTile(Icons.location_on_outlined, 'Shipping Address', () {}),
          _buildProfileTile(Icons.payment_outlined, 'Payment Methods', () {}),

          const Divider(indent: 20, endIndent: 20),

          // 4. Connect the Logout button to your AuthController logic
          _buildProfileTile(
              Icons.logout,
              'Logout',
                  () {
                Get.defaultDialog(
                  title: "Logout",
                  middleText: "Are you sure you want to logout?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () => auth.logout(),
                );
              },
              color: Colors.red
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}