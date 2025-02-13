import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController heightLbsController = TextEditingController();
  final TextEditingController heightCmController = TextEditingController();
  final TextEditingController weightLbsController = TextEditingController();
  final TextEditingController weightKgController = TextEditingController();

  String? selectedGender;
  String? selectedExperience;
  String? selectedGoal;
  bool obscurePassword = true;

  void signUpUser() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up Successful!")),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : false,
      validator: (value) => value!.isEmpty ? "$label is required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                onPressed: () => setState(() => obscurePassword = !obscurePassword),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/gym_background.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.9)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(fullNameController, "Full Name", Icons.person),
                    SizedBox(height: 12),
                    _buildTextField(addressController, "Address", Icons.location_on),
                    SizedBox(height: 12),
                    _buildTextField(emailController, "Email", Icons.email),
                    SizedBox(height: 12),
                    _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
                    SizedBox(height: 12),
                    _buildTextField(dateOfBirthController, "Date of Birth", Icons.calendar_today),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(heightLbsController, "Height (Lbs)", Icons.height)),
                        SizedBox(width: 10),
                        Expanded(child: _buildTextField(heightCmController, "Height (Cm)", Icons.height)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(weightLbsController, "Weight (Lbs)", Icons.fitness_center)),
                        SizedBox(width: 10),
                        Expanded(child: _buildTextField(weightKgController, "Weight (Kg)", Icons.fitness_center)),
                      ],
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedExperience,
                      decoration: InputDecoration(
                        labelText: "Experience Level as a Lifter",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ["Beginner", "Intermediate", "Advanced", "Pro"].map((String level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? value) => setState(() => selectedExperience = value),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedGoal,
                      decoration: InputDecoration(
                        labelText: "Nutrition Goals",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ["Lose Weight", "Gain Mass", "Maintain Weight", "Just Exploring"].map((String goal) {
                        return DropdownMenuItem<String>(
                          value: goal,
                          child: Text(goal, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? value) => setState(() => selectedGoal = value),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: signUpUser,
                      child: Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
