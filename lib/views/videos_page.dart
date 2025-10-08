import 'package:flutter/material.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  final List<Map<String, String>> videos = const [
    {"thumb": "assets/images/video_thumb1.png", "title":"Styling tips for kurtis"},
    {"thumb": "assets/images/video_thumb2.png", "title":"Monsoon makeup routine"},
    {"thumb": "assets/images/video_thumb1.png", "title":"DIY home decor quick"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Videos"), backgroundColor: Colors.white
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: videos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final v = videos[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.asset(v['thumb']!, height: 100, width: 140, fit: BoxFit.cover),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(v['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
