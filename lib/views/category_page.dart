import 'package:flutter/material.dart';
import 'buy_now.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<String> categories = [
    "Men", "Women", "Kids", "Home Decor", "DIY", "Beauty", "Brands"
  ];

  final Map<String, List<Map<String, dynamic>>> productsByCategory = {
    "Men": [
      {"image": 'assets/images/mens.png', "name":"Men Shirt", "price":899},
      {"image": 'assets/images/tshirt.png', "name":"Men T-Shirt", "price":1999},
    ],
    "Women": [
      {"image": 'assets/images/kurti.png', "name":"Kurti", "price":499},
      {"image": 'assets/images/d3.png', "name":"Designer Dress", "price":1299},
    ],
    "Kids": [
      {"image": 'assets/images/baby.png', "name":"Kids T-shirt", "price":299},
    ],
    "Home Decor": [
      {"image": 'assets/images/home.png', "name":"Beautifull Plants", "price":399},
    ],
    "DIY": [
      {"image": 'assets/images/diy.png', "name":"DIY Kit", "price":499},
    ],
    "Beauty": [
      {"image": 'assets/images/mekup.png', "name":"Mekup Kit", "price":699},
    ],
    "Brands": [
      {"image": 'assets/images/ysl.png', "name":"YSL heels", "price":2499},
    ],
  };

  String selected = "Women";

  @override
  Widget build(BuildContext context) {
    final items = productsByCategory[selected] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Categories"), backgroundColor: Colors.white),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final c = categories[index];
                final active = c == selected;
                return GestureDetector(
                  onTap: () => setState(() => selected = c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? Colors.deepPurple : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(c, style: TextStyle(color: active ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("No products in this category"))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final p = items[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Image.asset(p['image'], fit: BoxFit.cover)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("₹${p['price']}", style: const TextStyle(color: Colors.deepPurple)),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {
                                  addToCart(context, CartItem(name: p['name'], price: p['price'], image: p['image']));
                                },
                                child: const Text("Add to Cart"),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => BuyNowPage(productName: p['name'], price: p['price'], image: p['image'])));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Buy Now"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
