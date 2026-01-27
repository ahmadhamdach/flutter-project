import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import '../views/product_details_page.dart'; // Import the details page

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({super.key, required this.product});

  // Access the product controller to handle "Add to Cart" logic
  final ProductController c = Get.find();

  @override
  Widget build(BuildContext context) {
    const customGreen = Color(0xFF0B3D2E);

    return InkWell(
      // Navigate to the details page when the card is tapped
      onTap: () => Get.to(() => ProductDetailsPage(product: product)),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            // Product Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                    product.image,
                    fit: BoxFit.contain
                ),
              ),
            ),
            // Product Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 5),
            // Product Price
            Text(
              '\$${product.price}',
              style: const TextStyle(
                  color: customGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onPressed: () => c.addToCart(product),
                  child: const Text('Add to Cart'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}