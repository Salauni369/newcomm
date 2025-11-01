import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'product_detail2.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "M";
  double rating = 4.3;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(product['name'], style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          product['image'],
                          height: 230,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹${product['price']}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Best Single Saare",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Text(
                                "Free Delivery available",
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text("4.4",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Select Size:",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: ["S", "M", "L", "XL", "XXL"].map((size) {
                              final isSelected = size == selectedSize;
                              return GestureDetector(
                                onTap: () => setState(() => selectedSize = size),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                    isSelected ? Colors.black : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color:
                                      isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      addToCart(
                        context,
                        CartItem(
                          name: product['name'],
                          price: product['price'],
                          image: product['image'],
                          rating: rating,
                          offer: '',
                          disccount: '',
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade800, width: 1.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(
                            product: {
                              'name': product['name'],
                              'price': product['price'],
                              'image': product['image'],
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Buy Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
