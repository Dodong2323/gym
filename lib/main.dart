import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_dashboard.dart';
import 'coach_dashboard.dart';
import 'guest.dart';
import 'Email.dart';
import 'SignUpScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool showLogin = false;
  bool obscurePassword = true;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int failedAttempts = 0;
  bool isButtonDisabled = false;
  int countdownTime = 0;
  bool isAccountLocked = false;
  bool _isLocked = false;
  int totalAttempts = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void toggleLoginView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

 void loginUser() async {
  if (isButtonDisabled || isAccountLocked) {
    return;
  }

  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
    return;
  }

  var url = Uri.parse('http://localhost/gym_php/login.php');

  Map<String, dynamic> jsonData = {
    "username": email,
    "password": password,
  };

  Map<String, String> requestBody = {
    "operation": "login",
    "json": jsonEncode(jsonData),
  };

  try {
    var response = await http.post(url, body: requestBody);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data is Map && data.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"])),
        );
        return;
      }

      if (data != 0) {
        String role = data['Role'];

        if (role == 'members') {
          if(data['user_failed_attempts'] == 1){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your account is Locked")),
            );
            setState(() {
              _isLocked = true;
            });
          } else{
                      Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserDashboard()),
          );
          }
        } else if (role == 'coach') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CoachDashboard()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Access Denied")),
          );
        }
      } else {
        setState(() {
          failedAttempts++;
        });
        handleFailedAttempts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error. Try again later.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}

void updateFailedAttempts() async {
  try {
    var url = Uri.parse('http://localhost/gym_php/login.php');

    Map<String, dynamic> jsonData = {
      "user_email": emailController.text,
      "user_failed_attempts": 1
    };

    Map<String, String> requestBody = {
      "operation": "updateFailedAttempts",
      "json": jsonEncode(jsonData),
    };

    var response = await http.post(url, body: requestBody);

    if (response.statusCode == 200) {
      print("Failed attempts updated successfully.");
    }
  } catch (e) {
    print(e);
  }
}

void handleFailedAttempts() {
  if (failedAttempts == 5 && totalAttempts == 5) {
    setState(() {
      isButtonDisabled = true;
      totalAttempts = 3; // Reset total attempts to 3
      failedAttempts = 0; // Reset failed attempts counter
      countdownTime = 3; // 2 minutes
    });
    startCountdown();
  } else if (failedAttempts == 3 && totalAttempts == 3) {
    setState(() {
      isButtonDisabled = true;
      totalAttempts = 2; // Reset total attempts to 2
      failedAttempts = 0; // Reset failed attempts counter
      countdownTime = 3; // 5 minutes
    });
    startCountdown();
  } else if (failedAttempts == 2 && totalAttempts == 2) {
    setState(() {
      isAccountLocked = true;
    });
    updateFailedAttempts(); // Call the function to update failed attempts in the database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account temporarily locked. Contact admin.")),
    );
  }
}
  void startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countdownTime > 0) {
        setState(() {
          countdownTime--;
        });
        startCountdown();
      } else {
        setState(() {
          isButtonDisabled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void navigateToEmailLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContinueWithEmailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/gym_background.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome to\n",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      TextSpan(
                        text: "C",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      TextSpan(
                        text: "NERGY GYM",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                showLogin ? _buildLoginFields() : _buildMainView(),
                const SizedBox(height: 20),
                const Text(
                  "By continuing, you agree to Fitness's Terms & Conditions and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    return Column(
      key: const ValueKey(1),
      children: [
        _buildButton(
          text: "Continue with Email",
          color: Colors.white,
          textColor: Colors.black,
          icon: Icons.mail,
          onPressed: navigateToEmailLogin,
        ),
        const SizedBox(height: 10),
        _buildButton(
          text: "Login",
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: toggleLoginView,
        ),
        const SizedBox(height: 10),
        const Text(
          "or",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _buildButton(
          text: "Continue as a Guest",
          color: Colors.orange,
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuestScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoginFields() {
    return Column(
      key: const ValueKey(2),
      children: [
        Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email Address",
                prefixIcon: const Icon(Icons.mail),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10, top: 5),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (isButtonDisabled)
          Text(
            "Try again in $countdownTime seconds",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 10),
        Visibility(
          visible: !_isLocked,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: isButtonDisabled || isAccountLocked ? null : loginUser,
            child: const Text("Login", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "You don't have an account? Sign up",
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: icon != null ? Icon(icon, color: textColor) : const SizedBox(),
      label: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
      onPressed: onPressed,
    );
  }
}