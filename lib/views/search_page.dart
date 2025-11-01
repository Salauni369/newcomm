import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class SearchPage extends StatefulWidget {
  // we pass allProducts from caller to search across everything
  final List<Map<String, dynamic>> allProducts;
  const SearchPage({super.key, required this.allProducts});

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchHistory {
  static final List<String> items = [];
  static void add(String s) {
    if (s.trim().isEmpty) return;
    items.removeWhere((e) => e.toLowerCase() == s.toLowerCase());
    items.insert(0, s);
    if (items.length > 20) items.removeLast();
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  List<Map<String, dynamic>> results = [];
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    history = List.from(_SearchHistory.items);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focus);
    });
  }

  void _doSearch(String q) {
    final ql = q.trim().toLowerCase();
    if (ql.isEmpty) {
      setState(() {
        results = [];
      });
      return;
    }

    final matches = widget.allProducts.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final cat = (p['category'] ?? '').toString().toLowerCase();
      return name.contains(ql) || cat.contains(ql);
    }).toList();

    setState(() {
      results = matches;
    });
  }

  void _onSubmitted(String q) {
    final s = q.trim();
    if (s.isEmpty) return;
    _SearchHistory.add(s);
    setState(() {
      history = List.from(_SearchHistory.items);
    });
    _doSearch(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              focusNode: _focus,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSubmitted,
              onChanged: (v) {
                _doSearch(v);
              },
              decoration: InputDecoration(
                hintText: 'Search products or categories',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _ctrl.clear();
                    setState(() {
                      results = [];
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 12),
            if (history.isNotEmpty && _ctrl.text.isEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: const Text("Recent searches", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: history.map((h) {
                  return ActionChip(
                    label: Text(h),
                    onPressed: () {
                      _ctrl.text = h;
                      _onSubmitted(h);
                      FocusScope.of(context).unfocus();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
            ],
            Expanded(
              child: results.isEmpty
                  ? Center(
                child: _ctrl.text.isEmpty
                    ? const Text("Search for products across home & categories")
                    : const Text("No results found"),
              )
                  : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final p = results[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        p['image'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(p['name']),
                    subtitle: Text("₹${p['price']}"),
                    onTap: () {
                      _SearchHistory.add(p['name']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
