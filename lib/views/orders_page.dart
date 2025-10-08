import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});


  final List<Map<String, dynamic>> orders = const [
    {"id": "ORD123", "item": "Kurti", "amount": 499, "status": "Delivered", "payment": "Online"},
    {"id": "ORD124", "item": "Designer Dress", "amount": 1299, "status": "Shipped", "payment": "COD"},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), backgroundColor: Colors.white),
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
              trailing: Text(o['status'], style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
