import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final storage = GetStorage();
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = storage.read('isLoggedIn') ?? false;
  }

  void login(String email, String password) {
    // Mocking successful login
    isLoggedIn.value = true;
    storage.write('isLoggedIn', true);
    storage.write('userEmail', email);
    Get.offAllNamed('/home');
  }

  void logout() {
    isLoggedIn.value = false;
    storage.write('isLoggedIn', false);
    storage.remove('userEmail'); // Clean up user data
    Get.offAllNamed('/login'); // Redirect and wipe history
  }
}