import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_dashboard.dart';
import 'coach_dashboard.dart';
import 'guest.dart';
import 'Email.dart';
import 'SignUpScreen.dart';
import 'forgot_pass.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String role = prefs.getString('role') ?? '';

  print("Is Logged In: $isLoggedIn");
  print("Role: $role");

  runApp(MyApp(isLoggedIn: isLoggedIn, role: role));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;

  const MyApp({super.key, required this.isLoggedIn, required this.role});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? role == 'members'
              ? UserDashboard()
              : CoachDashboard()
          : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(), // Add this route
        '/userDashboard': (context) => UserDashboard(),
        '/coachDashboard': (context) => CoachDashboard(),
        '/guest': (context) => GuestScreen(),
        '/emailLogin': (context) => ContinueWithEmailScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
      },
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
  late Animation<Color?> _colorAnimation;
  late Animation<double> _textSizeAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  int failedAttempts = 0;
  bool isButtonDisabled = false;
  int countdownTime = 0;
  bool isAccountLocked = false;
  bool _isLocked = false;
  int totalAttempts = 5;
  DateTime? lastFailedAttemptTime;

  // CAPTCHA variables
  String captchaText = '';
  bool isCaptchaValid = false;
  bool showCaptcha = false;

  // Checkbox variable
  bool _acceptTerms = false;

  // Cookie storage
  final Map<String, String> _cookies = {};

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

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.orange,
    ).animate(_controller);

    _textSizeAnimation = Tween<double>(
      begin: 20.0,
      end: 28.0,
    ).animate(_controller);

    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    // Load session data on init
    _loadSessionData();

    // Generate initial CAPTCHA
    _generateCaptcha();
  }

  // Load session data from shared preferences
  Future<void> _loadSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLocked = prefs.getBool('isLocked') ?? false;
      failedAttempts = prefs.getInt('failedAttempts') ?? 0;
    });
  }

  // Save session data to shared preferences
  Future<void> _saveSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLocked', _isLocked);
    await prefs.setInt('failedAttempts', failedAttempts);
  }

  void toggleLoginView() {
    setState(() {
      showLogin = !showLogin;
    });
    if (showLogin) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  // Input sanitization function
  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>/\\]'), '');
  }

  // Middleware for request validation
  bool validateRequest(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Brute force defense: Rate limiting
  bool isRateLimited() {
    if (lastFailedAttemptTime != null) {
      final difference = DateTime.now().difference(lastFailedAttemptTime!);
      if (difference.inSeconds < 30) {
        return true;
      }
    }
    return false;
  }

  // Function to handle cookies
  void _updateCookies(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _cookies[rawCookie.split(';')[0].split('=')[0]] =
          rawCookie.split(';')[0].split('=')[1];
    }
  }

  // Function to include cookies in requests
  Map<String, String> _getCookies() {
    return _cookies;
  }

  // Generate CAPTCHA
  void _generateCaptcha() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    captchaText = String.fromCharCodes(Iterable.generate(
      6,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
    setState(() {});
  }

  // Validate CAPTCHA
  bool _validateCaptcha() {
    if (captchaController.text.trim() == captchaText) {
      setState(() {
        isCaptchaValid = true;
      });
      return true;
    } else {
      setState(() {
        isCaptchaValid = false;
      });
      Get.snackbar(
        "Error",
        "Invalid CAPTCHA. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _generateCaptcha();
      return false;
    }
  }

  void loginUser() async {
    if (isButtonDisabled || isAccountLocked) {
      return;
    }

    String email = sanitizeInput(emailController.text.trim());
    String password = sanitizeInput(passwordController.text.trim());

    if (!validateRequest(email, password)) {
      return;
    }

    if (!_validateCaptcha()) {
      return;
    }

    if (isRateLimited()) {
      Get.snackbar(
        "Error",
        "Too many attempts. Please wait before trying again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
      var response = await http.post(
        url,
        body: requestBody,
        headers: _getCookies(),
      );

      _updateCookies(response);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is Map && data.containsKey("error")) {
          Get.snackbar(
            "Error",
            data["error"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (data != 0) {
          String role =
              data['Role']; // Ensure this matches the backend response
          print("Role from backend: $role"); // Debug print

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', role);

          if (role == 'members') {
            print("Navigating to UserDashboard"); // Debug print
            if (data['user_failed_attempts'] == 1) {
              Get.snackbar(
                "Account Locked",
                "Your account is Locked",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              setState(() {
                _isLocked = true;
              });
              await _saveSessionData();
            } else {
              await _saveSessionData();
              Navigator.pushReplacementNamed(context, '/userDashboard');
            }
          } else if (role == 'coach') {
            print("Navigating to CoachDashboard"); // Debug print
            await _saveSessionData();
            Navigator.pushReplacementNamed(context, '/coachDashboard');
          } else {
            Get.snackbar(
              "Access Denied",
              "Access Denied",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          setState(() {
            failedAttempts++;
            lastFailedAttemptTime = DateTime.now();
          });
          handleFailedAttempts();
          await _saveSessionData();
          Get.snackbar(
            "Alert",
            "Invalid email or password!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Server Error",
          "Server error. Try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updateFailedAttempts() async {
    try {
      var url = Uri.parse('http://localhost/gym_php/login.php');

      Map<String, dynamic> jsonData = {
        "user_email": sanitizeInput(emailController.text),
        "user_failed_attempts": 1
      };

      Map<String, String> requestBody = {
        "operation": "updateFailedAttempts",
        "json": jsonEncode(jsonData),
      };

      var response = await http.post(
        url,
        body: requestBody,
        headers: _getCookies(),
      );
      _updateCookies(response);

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
        totalAttempts = 3;
        failedAttempts = 0;
        countdownTime = 30;
      });
      startCountdown();
    } else if (failedAttempts == 3 && totalAttempts == 3) {
      setState(() {
        isButtonDisabled = true;
        totalAttempts = 2;
        failedAttempts = 0;
        countdownTime = 60;
      });
      startCountdown();
    } else if (failedAttempts == 2 && totalAttempts == 2) {
      setState(() {
        isAccountLocked = true;
      });
      updateFailedAttempts();
      Get.snackbar(
        "Account Locked",
        "Account temporarily locked. Contact admin.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
    captchaController.dispose();
    super.dispose();
  }

  void navigateToEmailLogin() {
    Navigator.pushNamed(context, '/emailLogin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/gym.6.jpg',
            fit: BoxFit.cover,
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - _backgroundOpacityAnimation.value,
                child: Image.asset(
                  'assets/images/gym.2.jpeg',
                  fit: BoxFit.cover,
                ),
              );
            },
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
                const Spacer(flex: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: showLogin
                      ? Container()
                      : Image.asset(
                          'assets/images/gym.logo.png',
                          height: 100,
                          key: const ValueKey('logo'),
                        ),
                ),
                const SizedBox(height: 50),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome to\n",
                            style: TextStyle(
                                fontSize: _textSizeAnimation.value,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: "C",
                            style: TextStyle(
                              fontSize: _textSizeAnimation.value + 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          TextSpan(
                            text: "NERGY GYM",
                            style: TextStyle(
                              fontSize: _textSizeAnimation.value + 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                            parent: animation, curve: Curves.easeOut)),
                        child: child,
                      ),
                    );
                  },
                  child: showLogin ? _buildLoginFields() : _buildMainView(),
                ),
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
    return Card(
      color: const Color.fromARGB(15, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          key: const ValueKey('mainView'),
          children: [
            _buildButton(
              text: "Continue with Email",
              color: Colors.white,
              textColor: Colors.black,
              icon: Icons.mail,
              onPressed: navigateToEmailLogin,
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _controller.value * 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colorAnimation.value,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: toggleLoginView,
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "or",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildButton(
              text: "Continue as a Guest",
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/guest');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginFields() {
    return Card(
      color: Colors.black.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          key: const ValueKey('loginFields'),
          children: [
            Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    prefixIcon: const Icon(Icons.mail, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
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
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                          showCaptcha = _acceptTerms;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    const Text(
                      "Check CAPTCHA",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: showCaptcha
                      ? Row(
                          key: const ValueKey('captcha'),
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: captchaController,
                                decoration: InputDecoration(
                                  hintText: "Enter CAPTCHA",
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Correct placement of SizedBox
                            GestureDetector(
                              onTap: _generateCaptcha,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  captchaText,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(), // Added fallback widget for AnimatedSwitcher
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgotPassword');
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.white),
                      ),
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
                onPressed:
                    isButtonDisabled || isAccountLocked ? null : loginUser,
                child: const Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "You don't have an account? ",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: textColor),
          if (icon != null) const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
