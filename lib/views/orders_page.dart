import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'home.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _selectedIndex = 2;
  final List<Map<String, dynamic>> orders = const [
    {"id": "ORD123", "item": "Kurti", "amount": 499, "status": "Delivered", "payment": "Online"},
    {"id": "ORD124", "item": "Designer Dress", "amount": 1299, "status": "Shipped", "payment": "COD"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CartPage()));
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? const Center(child: Text("You have no orders yet"))
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final o = orders[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("${o['item']} — ₹${o['amount']}"),
              subtitle: Text("Order: ${o['id']} • Payment: ${o['payment']}"),
              trailing: Text(
                o['status'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Mall"),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: "Videos"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Orders"),
        ],
      ),
    );
  }
}

