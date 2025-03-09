import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: ForgotPasswordScreen(),
  ));
}

// 📌 1️⃣ Forgot Password Screen (Enter Email)
class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Future<void> forgotpass(String email) async {
    final url = Uri.parse('http:localhost/gym_php/send_email.php');
    final response = await http.post(
      url,
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        Get.snackbar(
            'Success', 'Password reset instructions sent to your email',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.to(() => OTPVerificationScreen(email: email));
      } else {
        Get.snackbar('Error', responseData['message'],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Failed to connect to the server',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text("Reset Password",
                style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Text(
                "Enter your email and we'll send instructions to reset your password.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.grey[700])),
            SizedBox(height: screenHeight * 0.04),
            TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email", border: OutlineInputBorder())),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                forgotpass(emailController.text.trim());
              },
              child: Text("Send Instructions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, screenHeight * 0.06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📌 2️⃣ OTP Verification Screen
class OTPVerificationScreen extends StatelessWidget {
  final String email;
  OTPVerificationScreen({required this.email});

  final List<TextEditingController> otpControllers =
      List.generate(5, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Back", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text("Check your email",
                style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Text("We sent a reset link to $email.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.black54)),
            SizedBox(height: screenHeight * 0.01),
            Text("Enter the 5-digit code mentioned in the email.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.black54)),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => SizedBox(
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.08,
                  child: TextField(
                    controller: otpControllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), counterText: ""),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                Get.to(() => PasswordResetConfirmationScreen());
              },
              child: Text("Verify Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, screenHeight * 0.06),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              onPressed: () {
                // Resend email logic
              },
              child: Text("Haven't got the email yet? Resend email",
                  style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}

// 📌 3️⃣ Password Reset Confirmation Screen
class PasswordResetConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Back", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text("Password Reset",
                style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Text(
                "Your password has been successfully reset. Click confirm to set a new password.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.black54)),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                Get.to(() => CreateNewPasswordScreen());
              },
              child: Text("Confirm"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, screenHeight * 0.06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📌 4️⃣ Create New Password Screen
class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Back", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text("Create new password",
                style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Text(
                "Your new password must be different from previous used passwords.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.black54)),
            SizedBox(height: screenHeight * 0.04),
            Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => isPasswordVisible = !isPasswordVisible),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
                "Password must have at least 6 characters, including a digit and both upper & lowercase letters.",
                style: TextStyle(color: Colors.black54)),
            SizedBox(height: screenHeight * 0.02),
            Text("Confirm Password",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: confirmPasswordController,
              obscureText: !isConfirmPasswordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () => setState(() =>
                      isConfirmPasswordVisible = !isConfirmPasswordVisible),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text("Both passwords must match.",
                style: TextStyle(color: Colors.black54)),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text == confirmPasswordController.text) {
                  Get.to(() => ConfirmationSuccessScreen());
                } else {
                  Get.snackbar("Error", "Passwords do not match",
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Text("Update Password"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, screenHeight * 0.06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📌 5️⃣ Confirmation Success Screen
class ConfirmationSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Back", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.1),
            Icon(Icons.check_circle,
                color: Colors.green, size: screenHeight * 0.1),
            SizedBox(height: screenHeight * 0.02),
            Text("Congratulations!",
                style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: screenHeight * 0.01),
            Text("Your account has been confirmed.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.black54)),
            SizedBox(height: screenHeight * 0.005),
            Text("You can now login to the application.",
                style: TextStyle(
                    fontSize: screenHeight * 0.018, color: Colors.black54)),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the login screen
                Get.offAll(() => ForgotPasswordScreen());
              },
              child: Text("Back to login"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, screenHeight * 0.06),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              onPressed: () {
                // Skip confirmation for later
                Get.offAll(() => ForgotPasswordScreen());
              },
              child: Text("Skip, I'll confirm later",
                  style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}
