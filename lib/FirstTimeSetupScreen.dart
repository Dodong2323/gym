import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeSetupScreen extends StatefulWidget {
  @override
  _FirstTimeSetupScreenState createState() => _FirstTimeSetupScreenState();
}

class _FirstTimeSetupScreenState extends State<FirstTimeSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Other controllers...

  String? selectedGender;
  bool _isLoading = false;
  bool _autoValidating = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to all text fields to auto-submit when complete
    fullNameController.addListener(_checkAutoSubmit);
    emailController.addListener(_checkAutoSubmit);
    passwordController.addListener(_checkAutoSubmit);
    // Add listeners for other controllers...
  }

  @override
  void dispose() {
    fullNameController.removeListener(_checkAutoSubmit);
    emailController.removeListener(_checkAutoSubmit);
    passwordController.removeListener(_checkAutoSubmit);
    // Remove other listeners...
    super.dispose();
  }

  void _checkAutoSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _completeSetup();
    }
  }

  Future<void> _completeSetup() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _autoValidating = true;
    });

    try {
      // Save profile data to backend
      // ...

      // Mark setup as complete
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('profileCompleted', true);

      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/userDashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Your Profile"),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidating
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              "Please complete your profile",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),

            // Required fields
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
              validator: (value) => value!.isEmpty ? "Required" : null,
            ),

            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) => value!.isEmpty
                  ? "Required"
                  : !value.contains('@')
                      ? "Invalid email"
                      : null,
            ),

            // Other required fields...

            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
