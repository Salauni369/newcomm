// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:newcomm/views/signup_verification.dart';
// import 'dart:convert';
// import 'otp_view.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   bool isLoading = false;
//
//   Future<void> sendOtp() async {
//     final phone = phoneController.text.trim();
//     if (phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter mobile number")),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final response = await http.post(
//         Uri.parse("https://api.gamsgroup.in/business-auth/signup-otp"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"phone": phone}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("OTP Sent ✅: $data");
//
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OtpForm(),
//           ),
//         );
//       } else {
//         print("Error: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Already have an Account ")),
//         );
//       }
//     } catch (e) {
//       print("Exception: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Something went wrong")),
//       );
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/login.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             Container(
//               padding: const EdgeInsets.only(left: 35, top: 130),
//               child: const Text(
//                 "Sign Up",
//                 style: TextStyle(color: Colors.white, fontSize: 33),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height * 0.5,
//                   right: 35,
//                   left: 35,
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 25),
//                     TextField(
//                       controller: phoneController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         fillColor: Colors.grey.shade100,
//                         filled: true,
//                         hintText: "Mobile Number",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: isLoading ? null : sendOtp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xff4c505b),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: isLoading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text(
//                           "Send OTP",
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
