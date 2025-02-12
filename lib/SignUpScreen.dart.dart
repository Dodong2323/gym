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
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  String? selectedGender;
  bool obscurePassword = true;
  int currentStep = 1;
  bool isStudent = false;
  bool isEmployee = false;

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (currentStep < 4) {
          currentStep++;
        } else {
          signUpUser();
        }
      });
    }
  }

  void signUpUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sign Up Successful!")),
    );
    Navigator.pop(context);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _buildStepContent(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: nextStep,
                      child: Text(currentStep < 4 ? "Next" : "Finish", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildStepContent() {
    switch (currentStep) {
      case 1:
        return Column(
          key: ValueKey(1),
          children: [
            _buildTextField(fullNameController, "Full Name", Icons.person),
            SizedBox(height: 12),
            _buildTextField(addressController, "Address", Icons.location_on),
            SizedBox(height: 12),
            _buildTextField(emailController, "Email", Icons.email),
            SizedBox(height: 12),
            _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
          ],
        );
      case 2:
        return Column(
          key: ValueKey(2),
          children: [
            _buildTextField(dateOfBirthController, "Date of Birth", Icons.calendar_today),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: InputDecoration(
                labelText: "Gender",
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ["Male", "Female", "Other"].map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? value) => setState(() => selectedGender = value),
            ),
          ],
        );
      case 3:
        return Column(
          key: ValueKey(3),
          children: [
            CheckboxListTile(
              title: Text("Student", style: TextStyle(color: Colors.white)),
              value: isStudent,
              onChanged: (bool? value) => setState(() => isStudent = value ?? false),
            ),
            if (isStudent) ...[
              _buildTextField(schoolNameController, "School Name", Icons.school),
              SizedBox(height: 12),
              _buildTextField(studentIDController, "Student ID Number", Icons.badge),
            ],
            CheckboxListTile(
              title: Text("Employee", style: TextStyle(color: Colors.white)),
              value: isEmployee,
              onChanged: (bool? value) => setState(() => isEmployee = value ?? false),
            ),
            if (isEmployee) ...[
              _buildTextField(employeeNameController, "Employee Name", Icons.work),
              SizedBox(height: 12),
              _buildTextField(jobTitleController, "Job Title", Icons.business),
            ],
          ],
        );
      case 4:
        return Column(
          key: ValueKey(4),
          children: [
            Text("Congratulations!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text("We've sent an email with instructions to verify your account.", style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        );
      default:
        return Container();
    }
  }
}
