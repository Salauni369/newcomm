import 'package:flutter/material.dart';
import 'package:newcomm/views/home.dart';
import 'package:newcomm/views/videos_page.dart';
import 'package:newcomm/views/buy_now.dart'; // ← CORRECT PATH
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'mall_page.dart';
import 'orders_page.dart';
import 'cart_page.dart';
import 'search_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 1;

  final Map<String, Map<String, List<Map<String, dynamic>>>> categoriesData = {
    "Kurta": {
      "All": [
        {
          "name": "kurta 1",
          "price": 899,
          "image": "assets/images/kurta 1.png",
          "rating": 4.5,
          "offer": "Special Offer: Get extra discount on next purchase",
          "disccount": "10% OFF",
        },
        {"name": "kurta 2", "price": 1299, "image": "assets/images/kurta 2.png"},
        {"name": "kurta 3", "price": 999, "image": "assets/images/kurta 1.png"},
        {"name": "kurta 4", "price": 1099, "image": "assets/images/kurta 2.png"},
        {"name": "kurta 5", "price": 1199, "image": "assets/images/kurta 1.png"},
      ],
    },
    "Saree": {
      "All": [
        {"name": "Saree 1", "price": 1499, "image": "assets/images/sarre.png"},
        {"name": "Saree 2", "price": 1999, "image": "assets/images/sare2.png"},
        {"name": "Saree 3", "price": 1699, "image": "assets/images/sarre.png"},
        {"name": "Saree 4", "price": 2199, "image": "assets/images/sare2.png"},
      ],
    },
    "Lehenga": {
      "All": [
        {"name": "Lehenga 1", "price": 2999, "image": "assets/images/lehenga1.png"},
        {"name": "Lehenga 2", "price": 3599, "image": "assets/images/lehenga1.png"},
      ],
    },
    "Women Western": {
      "All": [
        {"name": "Dress 1", "price": 1199, "image": "assets/images/lehenga2.png"},
      ],
    },
    "Men": {
      "All": [
        {"name": "Men Shirt", "price": 899, "image": "assets/images/mens.png"},
        {"name": "Men T-Shirt", "price": 1999, "image": "assets/images/tshirt.png"},
        {"name": "Men 3", "price": 1299, "image": "assets/images/mens.png"},
      ],
    },
    "Kids": {
      "All": [
        {"name": "Kids T-Shirt", "price": 299, "image": "assets/images/baby.png"},
      ],
    },
    "Beauty": {
      "Skincare": [
        {"name": "Face Cream", "price": 399, "image": "assets/images/fd.png"},
      ],
      "Haircare": [
        {"name": "Shampoo", "price": 199, "image": "assets/images/hair.png"},
      ],
    },
    "Health": {
      "Supplements": [
        {"name": "Vitamin C", "price": 499, "image": "assets/images/vitaminc.png"},
      ],
    },
    "Electronics": {
      "Mobiles": [
        {"name": "Smartphone", "price": 14999, "image": "assets/images/mobile.png"},
      ],
      "Laptops": [
        {"name": "Laptop", "price": 49999, "image": "assets/images/lappy.png"},
      ],
      "Gadgets": [
        {"name": "Smartwatch", "price": 4999, "image": "assets/images/smart.png"},
      ],
    },
    "Sports": {
      "All": [
        {"name": "Football", "price": 999, "image": "assets/images/fotball.png"},
      ],
    },
    "Books": {
      "All": [
        {"name": "Book 1", "price": 299, "image": "assets/images/books.png"},
      ],
    },
    "Grocery": {
      "All": [
        {"name": "Rice 5kg", "price": 499, "image": "assets/images/rice.png"},
      ],
    },
  };

  String selectedCategory = "Kurta";
  String? selectedSub;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MallPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VideosPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrdersPage()));
        break;
    }
  }

  List<List<T>> _chunk<T>(List<T> list, int n) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += n) {
      chunks.add(list.sublist(i, i + n > list.length ? list.length : i + n));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = selectedCategory != "All"
        ? categoriesData[selectedCategory]!.keys.toList()
        : [];
    selectedSub ??= subCategories.isNotEmpty ? subCategories.first : null;

    final allKeys = ["All", ...categoriesData.keys];

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Categories", style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchPage(allProducts: _allProductsFromData()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
            },
          ),
        ],
      ),

      body: Row(
        children: [
          SizedBox(
            width: 120,
            child: ListView.builder(
              itemCount: allKeys.length,
              itemBuilder: (context, index) {
                final cat = allKeys[index];
                final isActive = cat == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                      if (cat != "All" && categoriesData[cat] != null) {
                        selectedSub = categoriesData[cat]!.keys.first;
                      } else {
                        selectedSub = null;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.black : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      selectedCategory,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (subCategories.isNotEmpty && selectedCategory != "All")
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: subCategories.map((sub) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(sub),
                              selected: selectedSub == sub,
                              onSelected: (_) {
                                setState(() => selectedSub = sub);
                              },
                              selectedColor: Colors.black,
                              labelStyle: TextStyle(color: selectedSub == sub ? Colors.white : Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 12),
                  Builder(builder: (ctx) {
                    final flat = <Map<String, dynamic>>[];

                    if (selectedCategory == "All") {
                      for (final cat in categoriesData.values) {
                        for (final sub in cat.values) {
                          flat.addAll(sub);
                        }
                      }
                    } else if (selectedSub != null) {
                      flat.addAll(categoriesData[selectedCategory]![selectedSub] ?? []);
                    }

                    final chunks = _chunk(flat, 4);
                    return Column(
                      children: chunks.map((chunk) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: chunk.map((product) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BuyNowPage(
                                          productName: product['name'] as String,
                                          price: product['price'] as int,
                                          image: product['image'] as String,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 110,
                                    child: Card(
                                      elevation: 1.5,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                            child: Image.asset(
                                              product['image'] as String,
                                              width: 110,
                                              height: 110,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product['name'] as String,
                                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "₹${product['price']}",
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
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
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: "Videos"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Orders"),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _allProductsFromData() {
    final List<Map<String, dynamic>> all = [];
    for (final cat in categoriesData.values) {
      for (final sub in cat.values) {
        all.addAll(sub);
      }
    }
    return all;
  }
}