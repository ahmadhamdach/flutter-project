import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductController extends GetxController {
  final box = GetStorage();

  List<Product> products = [];
  List<Product> cart = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    loadCart();
  }

  // Define totalItems getter clearly for the UI to use
  int get totalItems => cart.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> fetchProducts() async {
    isLoading = true;
    update();
    try {
      final res = await http.get(Uri.parse('https://gist.githubusercontent.com/ahmadhamdach/40ff6d7f372a8d048846172b667ddefc/raw/a4f7fbf4c05911fe2f5f7e61c49ee80bd5fca05b/gistfile1.txt'));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        products = data.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
    isLoading = false;
    update();
  }

  void addToCart(Product product) {
    // Unique check: Item matches if ID, Color, and Size are the same
    final index = cart.indexWhere((p) =>
    p.id == product.id &&
        p.selectedColor == product.selectedColor &&
        p.selectedSize == product.selectedSize
    );

    if (index >= 0) {
      cart[index].quantity++;
    } else {
      cart.add(Product(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
        variants: product.variants,
        quantity: 1,
        selectedColor: product.selectedColor,
        selectedSize: product.selectedSize,
      ));
    }
    saveCart();
    update();

    Get.snackbar(
      'Success',
      'Added to cart',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF0B3D2E).withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.only(top: 60, left: 10, right: 10),
    );
  }

  void increaseQuantity(Product p) { p.quantity++; saveCart(); update(); }

  void decreaseQuantity(Product p) {
    if (p.quantity > 1) { p.quantity--; }
    else { cart.remove(p); }
    saveCart(); update();
  }

  void saveCart() {
    box.write('cart', cart.map((e) => e.toJson()).toList());
  }

  void loadCart() {
    final data = box.read('cart');
    if (data != null) {
      cart = List<Map<String, dynamic>>.from(data)
          .map((e) => Product.fromJson(e))
          .toList();
      update();
    }
  }

  void clearCart() {
    cart.clear();
    saveCart();
    update();
  }
}