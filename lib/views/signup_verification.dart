import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());

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

    // Simulate OTP verification delay
    await Future.delayed(Duration(seconds: 2));

    // Mock success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP Verified (Mock)")),
    );

    // Navigate to home or next screen
    Navigator.pushReplacementNamed(context, '/home');

    setState(() => isLoading = false);
  }

  void resendOtp() {
    // Mock resend
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
                  ? CircularProgressIndicator(color: Colors.white)
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
            )
          ],
        ),
      ),
    );
  }
}
