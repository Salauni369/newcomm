import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final TextEditingController _nameController = TextEditingController(text: "YashDeep Singh");
  final TextEditingController _emailController = TextEditingController(text: "yashdeep@example.com");

  Future<void> _pickImage() async {
    try {
      final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
      if (f == null) return;
      setState(() {
        _image = File(f.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to pick image")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: _image != null ? FileImage(_image!) as ImageProvider : const AssetImage('assets/images/profile_placeholder.png'),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _pickImage, child: const Text("Edit photo")),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 12),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated")));
              },
              child: const Text("Save"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
