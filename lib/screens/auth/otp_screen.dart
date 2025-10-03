import 'package:flutter/material.dart';
import 'dart:async';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<String> _otpDigits = ['', '', '', ''];
  int _currentIndex = 0;
  int _resendTimer = 61;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _onNumberTap(String number) {
    if (_currentIndex < 4) {
      setState(() {
        _otpDigits[_currentIndex] = number;
        if (_currentIndex < 3) {
          _currentIndex++;
        }
      });

      // Auto verify when all digits are entered
      if (_currentIndex == 3 && _otpDigits.every((digit) => digit.isNotEmpty)) {
        _verifyOTP();
      }
    }
  }

  void _onBackspace() {
    if (_currentIndex > 0 || _otpDigits[_currentIndex].isNotEmpty) {
      setState(() {
        if (_otpDigits[_currentIndex].isEmpty && _currentIndex > 0) {
          _currentIndex--;
        }
        _otpDigits[_currentIndex] = '';
      });
    }
  }

  void _verifyOTP() {
    final otp = _otpDigits.join();
    // TODO: Implement OTP verification logic
    print('Verifying OTP: $otp');
    // Navigate to home screen on success
  }

  void _resendCode() {
    if (_resendTimer == 0) {
      setState(() {
        _resendTimer = 61;
        _otpDigits.fillRange(0, 4, '');
        _currentIndex = 0;
      });
      _startResendTimer();
      // TODO: Implement resend OTP logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                'OTP Code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A6FA5),
                ),
              ),

              const SizedBox(height: 20),

              // Description
              Text(
                'Please type a OTP verification code\nsent to (+966)XXXXXXXX',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _currentIndex == index
                            ? const Color(0xFF4A6FA5)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _otpDigits[index],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // Timer and Resend
              if (_resendTimer > 0)
                Text(
                  "Didn't receive SMS? resend in 0:${_resendTimer.toString().padLeft(2, '0')} sec",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                )
              else
                GestureDetector(
                  onTap: _resendCode,
                  child: const Text(
                    'Resend Code?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A6FA5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const Spacer(),

              // Number Pad
              _buildNumberPad(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('1'),
              _buildNumberButton('2'),
              _buildNumberButton('3'),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('4'),
              _buildNumberButton('5'),
              _buildNumberButton('6'),
            ],
          ),
          const SizedBox(height: 16),

          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('7'),
              _buildNumberButton('8'),
              _buildNumberButton('9'),
            ],
          ),
          const SizedBox(height: 16),

          // Row 4: symbols, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('+ #'),
              _buildNumberButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () {
        if (number != '+ #') {
          _onNumberTap(number);
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: number == '+ #' ? 18 : 24,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 24,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
