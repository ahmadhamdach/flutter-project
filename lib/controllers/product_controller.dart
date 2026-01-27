import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  Future<void> fetchProducts() async {
    isLoading = true;
    update();

    try {
      final res =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        products = data.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
    }

    isLoading = false;
    update();
  }

  void addToCart(Product product) {
    final index = cart.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      cart[index].quantity++;
    } else {
      cart.add(product);
    }
    saveCart();
    update();

    Get.snackbar('Success', 'Added to cart',
        snackPosition: SnackPosition.TOP);
  }

  void increaseQuantity(Product product) {
    product.quantity++;
    saveCart();
    update();
  }

  void decreaseQuantity(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      cart.remove(product); // remove item completely if quantity is 1
    }
    saveCart();
    update();
  }



  double get totalPrice =>
      cart.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get totalItems =>
      cart.fold(0, (sum, item) => sum + item.quantity);

  void saveCart() {
    box.write('cart', cart.map((e) => e.toJson()).toList());
  }

  void loadCart() {
    final data = box.read('cart');
    if (data != null) {
      cart = List<Map<String, dynamic>>.from(data)
          .map((e) => Product(
        id: e['id'],
        title: e['title'],
        price: e['price'],
        image: e['image'],
        quantity: e['quantity'],
      ))
          .toList();
      update();
    }
  }
}
