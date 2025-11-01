import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:newcomm/views/home.dart';

class OtpFormlogin extends StatefulWidget {
  const OtpFormlogin({super.key});

  @override
  State<OtpFormlogin> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpFormlogin> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());

  bool isLoading = false;
  int _secondsRemaining = 0;
  bool _enableResend = true;
  Timer? _timer;

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
      const SnackBar(content: Text("OTP Verified ✅")),
    );
    Get.to(HomePage());

    setState(() => isLoading = false);
  }
  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _enableResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _enableResend = true;
        });
        timer.cancel();
      }
    });
  }
  void resendOtp() {
    if (!_enableResend) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP Resent ✅ (Mock)")),
    );

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
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
                  ? const CircularProgressIndicator(color: Colors.grey)
                  : const Text(
                "Verify",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _enableResend
                ? GestureDetector(
              onTap: resendOtp,
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
                : Text(
              "Resend in $_secondsRemaining sec",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
