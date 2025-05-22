import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_dashboard.dart';
import 'coach_dashboard.dart';
import 'FirstTimeSetupScreen.dart';
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
  final bool profileCompleted = prefs.getBool('profileCompleted') ?? false;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    role: role,
    profileCompleted: profileCompleted,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;
  final bool profileCompleted;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.role,
    required this.profileCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? profileCompleted
              ? role == 'members'
                  ? UserDashboard()
                  : CoachDashboard()
              : FirstTimeSetupScreen() // Redirect to setup if not completed
          : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/userDashboard': (context) => UserDashboard(),
        '/coachDashboard': (context) => CoachDashboard(),
        '/FirstTimeSetup': (context) => FirstTimeSetupScreen(),
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

  String captchaText = '';
  bool isCaptchaValid = false;
  bool showCaptcha = false;

  bool _acceptTerms = false;

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

    _loadSessionData();
    _generateCaptcha();
  }

  Future<void> _loadSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLocked = prefs.getBool('isLocked') ?? false;
      failedAttempts = prefs.getInt('failedAttempts') ?? 0;
    });
  }

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

  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>/\\]'), '');
  }

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

  bool isRateLimited() {
    if (lastFailedAttemptTime != null) {
      final difference = DateTime.now().difference(lastFailedAttemptTime!);
      if (difference.inSeconds < 30) {
        return true;
      }
    }
    return false;
  }

  void _updateCookies(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _cookies[rawCookie.split(';')[0].split('=')[0]] =
          rawCookie.split(';')[0].split('=')[1];
    }
  }

  Map<String, String> _getCookies() {
    return _cookies;
  }

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
          String role = data['Role'];
          print("Role from backend: $role");

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', role);

          if (role == 'members') {
            print("Navigating to UserDashboard");
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
            print("Navigating to CoachDashboard");
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
          // Background layers (keep existing)
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

          // Main content column
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Shared logo widget
                _buildSharedLogo(),

                const Spacer(flex: 1),

                // Animated content switcher
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
                  child: showLogin ? _buildLoginContent() : _buildMainContent(),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Shared logo widget
  Widget _buildSharedLogo() {
    return Center(
      child: Image.asset(
        'assets/images/gym.logo.png',
        height: 150, // Consistent size
      ),
    );
  }

// Main view content without logo
  Widget _buildMainContent() {
    return Card(
      key: const ValueKey('mainView'),
      color: Colors.black.withOpacity(0.3),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text(
              "WELCOME TO",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "C",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  TextSpan(
                    text: "NERGY GYM",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "set a new standard today with training\nand nutrition from Cnergy Gym",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: toggleLoginView,
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Login content without logo
  Widget _buildLoginContent() {
    return Card(
      key: const ValueKey('loginFields'),
      color: Colors.black.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "START YOUR FITNESS JOURNEY HERE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// Email field (icon on right)
            TextFormField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email Address",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                suffixIcon: const Icon(Icons.mail, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[850], // Dark grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Password field (icon on right)
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.grey[850], // Dark grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// CAPTCHA checkbox
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

            /// CAPTCHA input
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showCaptcha
                  ? Row(
                      key: const ValueKey('captcha'),
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: captchaController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter CAPTCHA",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                  : const SizedBox(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/forgotPassword');
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
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
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Center(
              child: RichText(
                text: TextSpan(
                  text: "You don’t have an account? ",
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
