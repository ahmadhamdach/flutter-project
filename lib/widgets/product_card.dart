import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import '../views/product_details_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ProductController c = Get.find();
  String? localSelectedColor;
  String? localSelectedSize;

  @override
  void initState() {
    super.initState();
    if (widget.product.variants != null) {
      if (widget.product.variants!['colors'] != null && (widget.product.variants!['colors'] as List).isNotEmpty) {
        localSelectedColor = widget.product.variants!['colors'][0]['name'];
      }
      if (widget.product.variants!['sizes'] != null && (widget.product.variants!['sizes'] as List).isNotEmpty) {
        localSelectedSize = widget.product.variants!['sizes'][0].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const customGreen = Color(0xFF0B3D2E);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8)
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE SECTION ---
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => ProductDetailsPage(product: widget.product)),
                        child: Container(
                          height: 130,
                          width: double.infinity,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Hero(
                            tag: 'prod_${widget.product.id}',
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.network(widget.product.image, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: customGreen,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: const Text(
                              'NEW',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),

                  // --- INFO & VARIANTS ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(color: customGreen, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 8),

                        // --- COLORS ---
                        if (widget.product.variants?['colors'] != null)
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: (widget.product.variants!['colors'] as List).take(5).map((color) {
                              bool isSel = localSelectedColor == color['name'];
                              return GestureDetector(
                                onTap: () => setState(() => localSelectedColor = color['name']),
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(int.parse(color['hex'].replaceFirst('#', '0xff'))),
                                    border: Border.all(
                                        color: isSel ? customGreen : Colors.grey.shade300,
                                        width: 2
                                    ),
                                  ),
                                  child: isSel ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                ),
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: 8),

                        // --- SIZES ---
                        if (widget.product.variants?['sizes'] != null)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: (widget.product.variants!['sizes'] as List).take(5).map((size) {
                                bool isSel = localSelectedSize == size.toString();
                                return GestureDetector(
                                  onTap: () => setState(() => localSelectedSize = size.toString()),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: isSel ? customGreen : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      size.toString(),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isSel ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- ACTION BUTTON ---
          Padding(
            padding: const EdgeInsets.all(8),
            child: GetBuilder<ProductController>(builder: (controller) {
              final cartItemIndex = controller.cart.indexWhere((p) =>
              p.id == widget.product.id &&
                  p.selectedColor == localSelectedColor &&
                  p.selectedSize == localSelectedSize);

              if (cartItemIndex == -1) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    minimumSize: const Size(double.infinity, 38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    widget.product.selectedColor = localSelectedColor;
                    widget.product.selectedSize = localSelectedSize;
                    controller.addToCart(widget.product);
                  },
                  child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 12)),
                );
              } else {
                final cartItem = controller.cart[cartItemIndex];
                return Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: customGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: customGreen.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _qtyBtn(Icons.remove, () => controller.decreaseQuantity(cartItem)),
                      Text('${cartItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, color: customGreen)),
                      _qtyBtn(Icons.add, () => controller.increaseQuantity(cartItem)),
                    ],
                  ),
                );
              }
            }),
          )
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Icon(icon, size: 18, color: const Color(0xFF0B3D2E)),
      ),
    );
  }
}