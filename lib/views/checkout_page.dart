import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as ll2;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import '../controllers/product_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final ProductController pc = Get.find();
  final MapController _mapController = MapController();

  // Controllers for user input
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final Color customGreen = const Color(0xFF0B3D2E);
  bool saveAddress = true;

  ll2.LatLng selectedLocation = const ll2.LatLng(34.4255, 35.8390);
  String selectedAddress = "Detecting location...";
  bool isLoading = true;

  final List<ll2.LatLng> abuSamraBoundary = [
    const ll2.LatLng(34.4320, 35.8350),
    const ll2.LatLng(34.4300, 35.8450),
    const ll2.LatLng(34.4200, 35.8520),
    const ll2.LatLng(34.4120, 35.8400),
    const ll2.LatLng(34.4180, 35.8280),
    const ll2.LatLng(34.4280, 35.8300),
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- LOCATION LOGIC ---
  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      ll2.LatLng currentPoint = ll2.LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          selectedLocation = currentPoint;
          isLoading = false;
        });
        _mapController.move(currentPoint, 15.0);
        _getAddress(currentPoint);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _getAddress(ll2.LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() => selectedAddress = "${place.street ?? 'Street'}, Abu Samra");
      }
    } catch (e) {
      setState(() => selectedAddress = "Abu Samra, Tripoli");
    }
  }

  bool _isInsideAbuSamra(ll2.LatLng point) {
    List<mp.LatLng> convertedPolygon = abuSamraBoundary.map((p) => mp.LatLng(p.latitude, p.longitude)).toList();
    return mp.PolygonUtil.containsLocation(mp.LatLng(point.latitude, point.longitude), convertedPolygon, false);
  }

  void _handlePlaceOrder() {
    if (_phoneController.text.length < 8) {
      Get.snackbar("Error", "Please enter a valid phone number", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    pc.clearCart();
    Get.snackbar(
      "Order Confirmed", "We will call you at ${_phoneController.text} shortly.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: customGreen,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
    Future.delayed(const Duration(milliseconds: 2000), () => Get.offAllNamed('/home'));
  }

  @override
  Widget build(BuildContext context) {
    bool canDeliver = _isInsideAbuSamra(selectedLocation);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: customGreen))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("1. Delivery Location"),
            const SizedBox(height: 10),
            _buildAddressCard(canDeliver),
            const SizedBox(height: 20),

            _buildSectionHeader("2. Contact & Details"),
            const SizedBox(height: 10),
            _buildContactCard(),
            const SizedBox(height: 20),

            _buildSectionHeader("3. Order Summary"),
            const SizedBox(height: 10),
            _buildOrderItemsCard(),
            const SizedBox(height: 25),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(canDeliver),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5));
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        children: [
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_android, color: customGreen),
              hintText: "Phone Number (e.g. 70 123 456)",
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.notes, color: customGreen),
              hintText: "Building name, floor, or special notes...",
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Save for future orders", style: TextStyle(fontSize: 13)),
            activeColor: customGreen,
            value: saveAddress,
            onChanged: (val) => setState(() => saveAddress = val),
          )
        ],
      ),
    );
  }

  Widget _buildAddressCard(bool canDeliver) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: SizedBox(
              height: 160,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(initialCenter: selectedLocation, initialZoom: 15, onTap: (p, latLng) { setState(() => selectedLocation = latLng); _getAddress(latLng); }),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                  PolygonLayer(polygons: [Polygon(points: abuSamraBoundary, color: customGreen.withOpacity(0.1), isFilled: true, borderColor: customGreen, borderStrokeWidth: 2)]),
                  MarkerLayer(markers: [Marker(point: selectedLocation, child: Icon(Icons.location_on, color: canDeliver ? Colors.red : Colors.grey, size: 35))]),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(selectedAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(canDeliver ? "Abu Samra Zone" : "Outside Zone", style: TextStyle(color: canDeliver ? customGreen : Colors.red, fontSize: 12)),
            trailing: IconButton(onPressed: _determinePosition, icon: Icon(Icons.my_location, color: customGreen)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: pc.cart.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item.image, width: 45, height: 45, fit: BoxFit.cover)),
              const SizedBox(width: 12),
              Expanded(child: Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              Text("x${item.quantity}", style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 10),
              Text("\$${(item.price * item.quantity).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildBottomAction(bool canDeliver) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text("\$${pc.totalPrice.toStringAsFixed(2)}", style: TextStyle(color: customGreen, fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: canDeliver ? customGreen : Colors.grey[400], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
              onPressed: canDeliver ? _handlePlaceOrder : null,
              child: const Text("CONFIRM ORDER", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}