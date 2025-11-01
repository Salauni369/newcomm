import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newcomm/views/ligin_view.dart';
import 'package:newcomm/views/signup_verification.dart';
import 'package:newcomm/views/signup_view.dart' hide Login;
import 'package:newcomm/views/otp_view.dart';
import 'package:newcomm/views/home.dart';
import 'package:newcomm/views/cart_page.dart';
import 'package:newcomm/views/buy_now.dart';
import 'package:newcomm'
    '/views/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
    home: Login(),
    );
  }
}
