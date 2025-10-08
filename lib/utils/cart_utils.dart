import 'package:flutter/material.dart';
import 'package:newcomm/views/home.dart';
import '../models/cart.dart';
import '../views/buy_now.dart';


List<CartItem> cartItems = [];


void addToCart(BuildContext context, CartItem product) {
  cartItems.add(product);


  int total = cartItems.fold(0, (sum, item) => sum + item.price);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Added to Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('₹${item.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  );

                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('₹$total', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // close sheet
                      Navigator.pushNamed(context, 'cart'); // open CartPage
                    },
                    child: const Text('View Cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      final last = cartItems.isNotEmpty ? cartItems.last : null;
                      if (last != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuyNowPage(
                              productName: last.name,
                              price: last.price,
                              image: last.image,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
