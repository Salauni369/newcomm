import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'buy_now.dart';
import 'package:share_plus/share_plus.dart';

class OrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const OrderDetailPage({super.key, required this.product});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String selectedSize = "XL";

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "REVIEW YOUR ORDER",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      product['image'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "₹${product['price']}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "₹281",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "3% OFF",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Size: $selectedSize   Qty: 1",
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.blue, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Estimated Delivery by Thursday, 06th Nov",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Salauni, 9639850141\nNear Vikas Digital Dharm Kanta, Amroha Dhanora Road, Amroha, Uttar Pradesh, 244221...",
                          style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Change", style: TextStyle(color: Colors.black, fontSize: 13,fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Product Price"),
                      Text("₹281"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Discount"),
                      Text("− ₹9"),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Total Amount",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹272",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "₹272   ",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "You saved ₹9 (3% OFF)",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  "View price details",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _showPaymentBottomSheet(context, product['price']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void _showPaymentBottomSheet(BuildContext context, int price) {
  String? paymentMethod;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      return StatefulBuilder(builder: (context, setStateSB) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: const Text("Cash on Delivery"),
                value: 'cod',
                groupValue: paymentMethod,
                onChanged: (v) => setStateSB(() => paymentMethod = v),
              ),
              RadioListTile<String>(
                title: const Text("Pay Online (UPI)"),
                value: 'upi',
                groupValue: paymentMethod,
                onChanged: (v) => setStateSB(() => paymentMethod = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: paymentMethod == null
                    ? null
                    : () async {
                  if (paymentMethod == 'upi') {
                    final upiUrl = Uri.parse(
                        'upi://pay?pa=example@upi&pn=YourMerchantName&am=$price&cu=INR&tn=Order%20Payment');
                    if (await canLaunchUrl(upiUrl)) {
                      await launchUrl(upiUrl);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order Placed! COD")));
                  }
                  Navigator.pop(context);
                  Navigator.pop(context); // Close OrderDetailPage
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
                child: const Text("Place Order", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      });
    },
  );
}
