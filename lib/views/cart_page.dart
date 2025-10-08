import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'buy_now.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int total = cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(item.name),
                  subtitle: Text("₹${item.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeItem(index),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("₹$total", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        cartItems.clear();
                      });
                    },
                    child: const Text('Clear Cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (cartItems.isNotEmpty) {
                        final first = cartItems.first;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuyNowPage(
                              productName: first.name,
                              price: first.price,
                              image: first.image,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
