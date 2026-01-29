import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import 'product_details_page.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final ProductController c = Get.find();

  // --- DELETE CONFIRMATION DIALOG ---
  Future<bool?> _showDeleteConfirmation(BuildContext context, dynamic product, bool isAll) async {
    const customGreen = Color(0xFF0B3D2E);

    return await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(isAll ? 'Empty Cart?' : 'Remove Item?', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(isAll
            ? 'Are you sure you want to remove all items?'
            : 'Do you want to remove this item from your cart?'),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAll ? Colors.red : customGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (isAll) c.clearCart();
              Get.back(result: true);
            },
            child: const Text('CONFIRM', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const customGreen = Color(0xFF0B3D2E);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for professional look
      appBar: AppBar(
        title: const Text('Shopping Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          GetBuilder<ProductController>(builder: (_) {
            return c.cart.isNotEmpty
                ? IconButton(
              onPressed: () => _showDeleteConfirmation(context, null, true),
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
            )
                : const SizedBox();
          }),
        ],
      ),
      body: GetBuilder<ProductController>(builder: (_) {
        if (c.cart.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 100, color: Colors.grey[300]),
                const SizedBox(height: 10),
                const Text('Your cart is empty', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: c.cart.length,
                itemBuilder: (_, i) {
                  final p = c.cart[i];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: Key(p.id.toString() + (p.selectedColor ?? '') + (p.selectedSize ?? '')),
                      direction: DismissDirection.endToStart, // Swipe left to delete
                      confirmDismiss: (direction) => _showDeleteConfirmation(context, p, false),
                      onDismissed: (direction) => c.decreaseQuantity(p), // Logic to remove
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () => Get.to(() => ProductDetailsPage(product: p)),
                          leading: Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                            child: Image.network(p.image, fit: BoxFit.contain),
                          ),
                          title: Text(p.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: customGreen, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  if (p.selectedColor != null) _buildTag(p.selectedColor!),
                                  if (p.selectedSize != null) _buildTag("Size: ${p.selectedSize}"),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _qtyBtn(Icons.remove, () {
                                      if (p.quantity == 1) {
                                        _showDeleteConfirmation(context, p, false).then((val) {
                                          if (val == true) c.decreaseQuantity(p);
                                        });
                                      } else {
                                        c.decreaseQuantity(p);
                                      }
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('${p.quantity}', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                    ),
                                    _qtyBtn(Icons.add, () => c.increaseQuantity(p)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildCheckoutBottom(customGreen),
          ],
        );
      }),
    );
  }

  // --- UI HELPERS ---

  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
      child: Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 24, color: const Color(0xFF0B3D2E)),
      ),
    );
  }

  Widget _buildCheckoutBottom(Color customGreen) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text('\$${c.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: customGreen, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: () => Get.to(() => const CheckoutPage()),
              child: const Text('CHECKOUT NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}