import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:newcomm/views/otp_view.dart';
import 'package:newcomm/views/signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool isPhoneValid = false;
  bool autoValidate = false;

  final RegExp _indiaPhoneRegex = RegExp(r'^[6-9]\d{9}$');

  void _onPhoneChanged(String value) {
    final phone = value.trim();
    final valid = _indiaPhoneRegex.hasMatch(phone);
    setState(() => isPhoneValid = valid);
  }

  Future<void> sendOtp() async {
    setState(() => autoValidate = true);

    if (!isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit mobile number.")),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP Sent (Mock) to ${phoneController.text.trim()}")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OtpFormlogin()),
    );

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() => _onPhoneChanged(phoneController.text));
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  String? _phoneValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter mobile number';
    if (!_indiaPhoneRegex.hasMatch(v)) return 'Enter valid 10-digit mobile number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                "Welcome\nBack ",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      autovalidateMode: autoValidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Mobile Number",
                          prefixText: "+91 ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: _phoneValidator,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                        (isPhoneValid && !isLoading) ? sendOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4c505b),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Send Otp",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xff4c505b),
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {

                            Get.to(() => const SignupScreen());
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4c505b),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
