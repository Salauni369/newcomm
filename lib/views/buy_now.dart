import 'package:flutter/material.dart';
import 'package:newcomm/views/product_detail2.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import 'home.dart';
import 'product_detail2.dart'; // ← ADD THIS

class BuyNowPage extends StatefulWidget {
  final String productName;
  final int price;
  final String image;

  const BuyNowPage({
    super.key,
    required this.productName,
    required this.price,
    required this.image,
  });

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  String? selectedPayment;
  bool isWishlisted = false;
  String selectedSize = 'M';

  // Dummy similar images
  final List<String> similarImages = [
    'assets/images/kurti.png',
    'assets/images/d3.png',
    'assets/images/sarre.png',
  ];

  @override
  Widget build(BuildContext context) {
    final int discount = 11;
    final double discountAmount = widget.price * (discount / 100);
    final double finalPrice = widget.price - discountAmount;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
          ),
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.black,
            ),
            onPressed: () {
              setState(() => isWishlisted = !isWishlisted);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isWishlisted ? "Added to Wishlist" : "Removed from Wishlist")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.black, size: 18),
                  SizedBox(width: 6),
                  Text("Delivering to Lucknow - 226001", style: TextStyle(fontWeight: FontWeight.w500)),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: similarImages.length + 1, // 1 main image + similar ones
                itemBuilder: (context, index) {
                  String imageToShow;
                  if (index == 0) {
                    imageToShow = widget.image; // main product image (clicked one)
                  } else {
                    imageToShow = similarImages[index - 1]; // others
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(imageToShow),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 16),
            const Text("Similar Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: similarImages.map((img) {
                return Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                    image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            Text(
              "Stylish_Women_Kurti_2025_Trendy_Floral_Print_Anarkali_Dress_499",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Text("₹${finalPrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(width: 8),
                Text("₹${widget.price}", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 14)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text("$discount% OFF", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),

            const SizedBox(height: 12),
            _buildDetailRow("Special offer: Buy 1 Get 1", Colors.green),
            _buildDetailRow("₹9 off Discount for Lucknow", Colors.black),
            _buildDetailRow("Free delivery", Colors.black),

            const SizedBox(height: 16),

            const Text("Select Size", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'].map((size) {
                return GestureDetector(
                  onTap: () => setState(() => selectedSize = size),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedSize == size ? Colors.black : Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        size,
                        style: TextStyle(
                          color: selectedSize == size ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  addToCart(
                    context,
                    CartItem(
                      name: widget.productName,
                      price: widget.price,
                      image: widget.image,
                      rating: 4.5,
                      offer: 'Buy 1 Get 1',
                      disccount: '11%',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Cart!")));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("ADD TO CART", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailPage(
                        product: {
                          'name': widget.productName,
                          'price': finalPrice.toInt(),
                          'image': widget.image,
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("BUY NOW", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(text, style: TextStyle(fontSize: 13, color: color)),
    );
  }
}
class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => const Center(child: Text("Search Results"));

  @override
  Widget buildSuggestions(BuildContext context) => const Center(child: Text("Type to search..."));
}