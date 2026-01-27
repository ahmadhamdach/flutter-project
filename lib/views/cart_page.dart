import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'product_details_page.dart'; // Import the details page

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final ProductController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (_) {
      if (c.cart.isEmpty) {
        return const Center(child: Text('Cart is empty'));
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: c.cart.length,
              itemBuilder: (_, i) {
                final p = c.cart[i];

                return ListTile(
                  // --- NAVIGATION ADDED HERE ---
                  onTap: () => Get.to(() => ProductDetailsPage(product: p)),
                  isThreeLine: true,
                  leading: Image.network(p.image, width: 50, height: 50, fit: BoxFit.contain),
                  title: Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '\$${p.price}',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: () {
                          if (p.quantity > 1) {
                            c.decreaseQuantity(p);
                          } else {
                            Get.defaultDialog(
                              title: 'Delete Item',
                              middleText: 'Remove this item from the cart?',
                              textCancel: 'No',
                              textConfirm: 'Yes',
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                c.cart.remove(p);
                                c.saveCart();
                                c.update();
                                Get.back();
                                Get.snackbar('Removed', 'Item removed successfully');
                              },
                            );
                          }
                        },
                      ),
                      Text(
                        p.quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () => c.increaseQuantity(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Delete Item',
                            middleText: 'Remove this item from the cart?',
                            textCancel: 'No',
                            textConfirm: 'Yes',
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.red,
                            onConfirm: () {
                              c.cart.remove(p);
                              c.saveCart();
                              c.update();
                              Get.back();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0B3D2E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  '\$${c.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}