import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductController controller = Get.find();
  String? selectedColor;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    // Default to first variant if available
    if (widget.product.variants?['colors'] != null) {
      selectedColor = widget.product.variants!['colors'][0]['name'];
    }
    if (widget.product.variants?['sizes'] != null) {
      selectedSize = widget.product.variants!['sizes'][0].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const customGreen = Color(0xFF0B3D2E);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.product.image, height: 300, fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('\$${widget.product.price}', style: const TextStyle(fontSize: 20, color: customGreen)),

                  if (widget.product.variants?['colors'] != null) ...[
                    const SizedBox(height: 20),
                    const Text("Select Color", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: (widget.product.variants!['colors'] as List).map((c) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedColor = c['name']),
                          child: Container(
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: selectedColor == c['name'] ? customGreen : Colors.transparent, width: 2),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color(int.parse(c['hex'].replaceFirst('#', '0xff'))),
                              radius: 15,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  if (widget.product.variants?['sizes'] != null) ...[
                    const SizedBox(height: 20),
                    const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: (widget.product.variants!['sizes'] as List).map((s) {
                        return ChoiceChip(
                          label: Text(s.toString()),
                          selected: selectedSize == s.toString(),
                          onSelected: (val) => setState(() => selectedSize = s.toString()),
                          selectedColor: customGreen,
                          labelStyle: TextStyle(color: selectedSize == s.toString() ? Colors.white : Colors.black),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: customGreen, minimumSize: const Size(double.infinity, 55)),
          onPressed: () {
            widget.product.selectedColor = selectedColor;
            widget.product.selectedSize = selectedSize;
            controller.addToCart(widget.product);
          },
          child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}