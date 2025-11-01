import 'package:flutter/material.dart';
import 'buy_now.dart';
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'orders_page.dart';
import 'videos_page.dart';
import 'category_page.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key});

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> featured = const [
    {"image": 'assets/images/baby.png', "name": "Baby Doll", "price": 599},
    {"image": 'assets/images/ysl.png', "name": "Designer Heels", "price": 2799},
    {"image": 'assets/images/home.png', "name": "Decor Item", "price": 499},
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Already on Home")));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const CategoryPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MallPage()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const VideosPage()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const OrdersPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mall"), backgroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text("Featured",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final p = featured[index];
                return SizedBox(
                  width: 170,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Expanded(
                            child: Image.asset(p['image'], fit: BoxFit.cover)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(p['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("₹${p['price']}",
                                  style: const TextStyle(
                                      color: Colors.deepPurple)),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () {
                                    addToCart(
                                        context,
                                        CartItem(
                                            name: p['name'],
                                            price: p['price'],
                                            image: p['image'],
                                            rating: 4.3,
                                            offer: '',
                                            disccount: ''));
                                  },
                                  child: const Text("Add"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text("More picks for you",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featured.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8),
            itemBuilder: (context, index) {
              final p = featured[index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                        child: Image.asset(p['image'], fit: BoxFit.cover)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(p['name'],
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                          Text("₹${p['price']}"),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Mall"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.play_circle_fill), label: "Videos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Orders"),
        ],
      ),
    );
  }
}
