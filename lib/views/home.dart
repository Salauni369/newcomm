import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'cart_page.dart';
import 'buy_now.dart';
import 'category_page.dart';
import 'mall_page.dart';
import 'videos_page.dart';
import 'orders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // original data (kept same)
  final List<String> bannerImages = const [
    'assets/images/banner1.png',
    'assets/images/img.png',
    'assets/images/img_1.png',
    'assets/images/img_2.png',
  ];

  final List<Map<String, dynamic>> allProducts = const [
    {"image": 'assets/images/kurti.png', "name": "Kurti", "price": 499, "category":"Women"},
    {"image": 'assets/images/d3.png', "name": "Designer Dress", "price": 1299, "category":"Women"},
    {"image": 'assets/images/sare2.png', "name": "Saree 2", "price": 1899, "category":"Women"},
    {"image": 'assets/images/sarre.png', "name": "Saree 1", "price": 799, "category":"Women"},
    {"image": 'assets/images/anr.png', "name": "Anarkali", "price": 1599, "category":"Women"},
    {"image": 'assets/images/ysl.png', "name": "YSL heels", "price": 2499, "category":"Women"},
    {"image": 'assets/images/mens.png', "name": "Men Shirt", "price": 899, "category":"Men"},
    {"image": 'assets/images/tshirt.png', "name": "Men T-Shirt", "price": 1999, "category":"Men"},
    {"image": 'assets/images/baby.png', "name": "Kids T-shirt", "price": 299, "category":"Kids"},
    {"image": 'assets/images/home.png', "name": "Cushion Cover", "price": 399, "category":"Home Decor"},
    {"image": 'assets/images/mekup.png', "name": "Face Serum", "price": 699, "category":"Beauty"},
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(allProducts);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts.where((p) {
          final name = (p['name'] as String).toLowerCase();
          final cat = (p['category'] as String).toLowerCase();
          final mall=(<String >['Category','Mall','Wishlist']);
          return name.contains(q) || cat.contains(q);

        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  Widget _bottomIconRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home, "Home", () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Already on Home")));
          }),
          _navIcon(Icons.category, "Category", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
          }),
          _navIcon(Icons.store, "Mall", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MallPage()));
          }),
          _navIcon(Icons.play_circle_fill, "Videos", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const VideosPage()));
          }),
          _navIcon(Icons.receipt_long, "Orders", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersPage()));
          }),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(title: Text('Home')),
            ListTile(title: Text('Categories')),
            ListTile(title: Text('Orders')),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products or categories...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.black), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
          }),
          IconButton(icon: const Icon(Icons.person, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: Colors.grey[100],
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            TextEditingController locationController = TextEditingController();
                            String currentLocation = "Lucknow - 226001";

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 50,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Change Delivery Location",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  Text("Current Address: $currentLocation",
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: locationController,
                                    decoration: InputDecoration(
                                      labelText: "Enter new address / PIN code",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (locationController.text.isNotEmpty) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Location changed to ${locationController.text}")),
                                              );
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Submit"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            "Delivering to Lucknow - 226001",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bannerImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            bannerImages[index],
                            fit: BoxFit.cover,
                            width: 300,
                          ),
                        );
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'For youhh my princess',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600 ? 4 : 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  product['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${product['price']}',
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  // Add to Cart Button
                                  SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        addToCart(
                                          context,
                                          CartItem(
                                            name: product['name'],
                                            price: product['price'],
                                            image: product['image'],
                                          ),
                                        );
                                      },
                                      child: const Text('Add to Cart'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Buy Now Button
                                  SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BuyNowPage(
                                              productName: product['name'],
                                              price: product['price'],
                                              image: product['image'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Buy Now'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _bottomIconRow(),
        ],
      ),
    );
  }
}
