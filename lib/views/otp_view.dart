import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newcomm/views/home.dart';

class OtpFormlogin extends StatefulWidget {
  const OtpFormlogin({super.key});

  @override
  State<OtpFormlogin> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpFormlogin> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController()); // 6 fields

  bool isLoading = false;

  Future<void> verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter 6 digit OTP")),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Verified (Mock)")),
    );
    Get.to(HomePage());
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const HomePage()),
    // );

    setState(() => isLoading = false);
  }

  void resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Resent (Mock)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    height: 68,
                    width: 50,
                    child: TextFormField(
                      controller: otpControllers[index],
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus(); // move next
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus(); // backspace
                        }
                      },
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : verifyOtp,
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Verify"),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: resendOtp,
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
