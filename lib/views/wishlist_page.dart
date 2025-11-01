// // wishlist_page.dart
// import 'package:flutter/material.dart';
//
// class WishlistPage extends StatelessWidget {
//   const WishlistPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // placeholder data - you can replace with your actual wishlist storage
//     final wishItems = [
//       {"name": "Kurti", "image": "assets/images/kurti.png", "price": 499},
//       {"name": "YSL heels", "image": "assets/images/ysl.png", "price": 2499},
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wishlist"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: wishItems.isEmpty
//           ? const Center(child: Text("No items in wishlist"))
//           : GridView.builder(
//         padding: const EdgeInsets.all(12),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 12, mainAxisSpacing: 12),
//         itemCount: wishItems.length,
//         itemBuilder: (context, index) {
//           final item = wishItems[index];
//           return Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: Image.asset(
//                     item['image']?.toString() ?? '',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item['name']?.toString() ?? '',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         "₹${item['price']?.toString() ?? ''}",
//                         style: const TextStyle(color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//
//         },
//       ),
//     );
//   }
// }
