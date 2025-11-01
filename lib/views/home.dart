import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newcomm/views/buy_now.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/cart.dart';
import '../utils/cart_utils.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'mall_page.dart';
import 'videos_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';
import 'wishlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> allProducts = const [
    {"image": 'assets/images/kurti.png', "name": "Kurti", "price": 499, "category": "Women"},
    {"image": 'assets/images/d3.png', "name": "Designer Dress", "price": 1299, "category": "Women"},
    {"image": 'assets/images/sare2.png', "name": "Saree 2", "price": 1899, "category": "Women"},
    {"image": 'assets/images/sarre.png', "name": "Saree 1", "price": 799, "category": "Women"},
    {"image": 'assets/images/anr.png', "name": "Anarkali", "price": 1599, "category": "Women"},
    {"image": 'assets/images/ysl.png', "name": "YSL heels", "price": 2499, "category": "Women"},
    {"image": 'assets/images/mens.png', "name": "Men Shirt", "price": 899, "category": "Men"},
    {"image": 'assets/images/tshirt.png', "name": "Men T-Shirt", "price": 1999, "category": "Men"},
    {"image": 'assets/images/baby.png', "name": "Kids T-shirt", "price": 299, "category": "Kids"},
    {"image": 'assets/images/home.png', "name": "Cushion Cover", "price": 399, "category": "Home Decor"},
    {"image": 'assets/images/mekup.png', "name": "Face Serum", "price": 699, "category": "Beauty"},
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  late DateTime _flashEnd;
  Timer? _flashTimer;
  Duration _remaining = Duration.zero;
  String _sortBy = 'relevance';
  String _categoryRadio = 'All';
  Set<String> _filterGenders = {};
  late final List<String> _allCategories;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(allProducts);
    _searchController.addListener(_onSearchChanged);

    final catSet = <String>{};
    for (var p in allProducts) {
      catSet.add(p['category']?.toString() ?? 'Unknown');
    }
    _allCategories = ['All', ...catSet];

    _flashEnd = DateTime.now().add(const Duration(hours: 2));
    _startFlashTimer();
  }

  void _startFlashTimer() {
    _flashTimer?.cancel();
    _flashTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final diff = _flashEnd.difference(DateTime.now());
        _remaining = diff.isNegative ? Duration.zero : diff;
        if (_remaining == Duration.zero) _flashTimer?.cancel();
      });
    });
  }

  void _onSearchChanged() => _applyFilters();

  @override
  void dispose() {
    _flashTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndSearch() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;

      final fileName = kIsWeb ? file.name ?? 'image.jpg' : file.path.split('/').last;
      final searchText = fileName
          .toLowerCase()
          .replaceAll(RegExp(r'[_\-\.]'), ' ')
          .split(' ')
          .take(2)
          .join(' ');

      _searchController.text = searchText;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searched: $searchText')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image pick failed')),
      );
    }
  }

  Future<void> _toggleListening() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice search not supported on web')),
      );
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          _searchController.text = result.recognizedWords;
          if (result.finalResult) {
            _speech.stop();
            setState(() => _isListening = false);
          }
        });
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _openFilterSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return DefaultTabController(
      length: 3,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [Tab(text: "Sort"), Tab(text: "Category"), Tab(text: "Filters")],
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  _sortTab(),
                  _categoryTab(),
                  _filterTab(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Apply", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortTab() => ListView(padding: const EdgeInsets.all(16), children: [
    RadioListTile<String>(
      title: const Text("Price: Low to High"),
      value: 'low_high',
      groupValue: _sortBy,
      onChanged: (v) => setState(() => _sortBy = v!),
    ),
  ]);

  Widget _categoryTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: _allCategories
        .map((c) => RadioListTile<String>(
      title: Text(c),
      value: c,
      groupValue: _categoryRadio,
      onChanged: (v) => setState(() => _categoryRadio = v!),
    ))
        .toList(),
  );

  Widget _filterTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ..._allCategories.where((c) => c != 'All').map((g) {
        final checked = _filterGenders.contains(g);
        return CheckboxListTile(
          title: Text(g),
          value: checked,
          dense: true,
          onChanged: (v) => setState(() => v == true ? _filterGenders.add(g) : _filterGenders.remove(g)),
        );
      }),
    ],
  );

  void _applyFilters() {
    final q = _searchController.text.trim().toLowerCase();
    var list = List<Map<String, dynamic>>.from(allProducts);

    if (q.isNotEmpty) {
      list = list.where((p) {
        final name = p['name']?.toString().toLowerCase() ?? '';
        final cat = p['category']?.toString().toLowerCase() ?? '';
        return name.contains(q) || cat.contains(q);
      }).toList();
    }

    if (_categoryRadio != 'All') {
      list = list.where((p) => p['category'] == _categoryRadio).toList();
    }

    if (_filterGenders.isNotEmpty) {
      list = list.where((p) => _filterGenders.contains(p['category'])).toList();
    }

    if (_sortBy == 'low_high') {
      list.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
    }

    setState(() => filteredProducts = list);
  }

  Widget _categoryCard(String img, String label) => InkWell(
    onTap: () {
      _searchController.text = label;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()));
    },
    child: Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 70,
          child: Text(
            label.length > 8 ? '${label.substring(0, 8)}...' : label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    ),
  );

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final catRow1 = [
      {"img": "assets/images/sarre.png", "label": "Sarees"},
      {"img": "assets/images/kurti.png", "label": "Kurtis"},
      {"img": "assets/images/mekup.png", "label": "Beauty"},
      {"img": "assets/images/home.png", "label": "Kitchen"},
      {"img": "assets/images/mens.png", "label": "Men"},
      {"img": "assets/images/tshirt.png", "label": "Fashion"},
      {"img": "assets/images/ysl.png", "label": "Jewellery"},
      {"img": "assets/images/baby.png", "label": "Kids"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            elevation: 1,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Profile icon removed
                  Expanded(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 18),
                                onPressed: _toggleListening,
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                                onPressed: _pickImageAndSearch,
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, size: 22),
                    color: isWishlisted ? Colors.red : Colors.black,
                    onPressed: () {
                      setState(() => isWishlisted = !isWishlisted);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isWishlisted ? "Added to Wishlist" : "Removed")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Location
                InkWell(
                  onTap: () => _showLocationSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.grey[50],
                    child: Row(
                      children: const [
                        Icon(Icons.location_on, size: 18),
                        SizedBox(width: 6),
                        Text("Lucknow - 226001", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Categories Row 1
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: catRow1.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _categoryCard(catRow1[i]['img']!, catRow1[i]['label']!),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/banner1.png', height: 120, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),

                // Flash Sale
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text("Flash Sale", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                        child: Text(_formatDuration(_remaining), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: const Text("See all", style: TextStyle(fontSize: 13))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(child: _filterBtn("Sort", _openFilterSortSheet)),
                      const SizedBox(width: 8),
                      Expanded(child: _filterBtn("Category", _openFilterSortSheet)),
                      const SizedBox(width: 8),
                      Expanded(child: _filterBtn("Filters", _openFilterSortSheet, icon: Icons.tune)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Products Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width > 600 ? 4 : 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, i) {
                      final p = filteredProducts[i];
                      final price = (p['price'] as num).toDouble();
                      final discount = 30;
                      final discounted = (price * (100 - discount) / 100).round();
                      final delivery = i % 3 == 0 ? 0 : 40;

                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuyNowPage(productName: p['name'], price: p['price'], image: p['image']),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.asset(p['image'], fit: BoxFit.cover, width: double.infinity),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text("₹$discounted", style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 4),
                                        Text("₹${price.toInt()}", style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 10, color: Colors.grey)),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                                          child: Text("$discount% OFF", style: const TextStyle(color: Colors.red, fontSize: 9)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(delivery == 0 ? "Free delivery" : "Delivery ₹$delivery", style: const TextStyle(fontSize: 10)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.star, size: 10, color: Colors.white),
                                              Text("4.5", style: TextStyle(color: Colors.white, fontSize: 9)),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                                          onPressed: () {
                                            addToCart(context, CartItem(name: p['name'], price: p['price'], image: p['image'], rating: 4.5, offer: '', disccount: ''));
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart")));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, "Home", () {}),
                _navItem(Icons.category, "Category", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()))),
                _navItem(Icons.store, "Mall", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MallPage()))),
                _navItem(Icons.play_circle_fill, "Videos", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideosPage()))),
                _navItem(Icons.receipt_long, "Orders", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersPage()))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _filterBtn(String text, VoidCallback onTap, {IconData? icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 16),
            if (icon != null) const SizedBox(width: 4),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showLocationSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Change Delivery Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "PIN / Address",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location: ${controller.text}")));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}