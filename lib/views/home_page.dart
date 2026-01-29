import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (c) {
      if (c.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12), // Slightly increased padding for the outer edges
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,    // Vertical gap between rows
          crossAxisSpacing: 12,   // Horizontal gap between columns
          childAspectRatio: 0.55, // Adjusted ratio to prevent overflow with new spacing
        ),
        itemCount: c.products.length,
        itemBuilder: (_, i) => ProductCard(product: c.products[i]),
      );
    });
  }
}