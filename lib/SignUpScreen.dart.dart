import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  bool stepOneCompleted = false;
  bool stepTwoCompleted = false;
  bool isStudent = false;
  bool isEmployee = false;

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
    schoolNameController.dispose();
    studentIDController.dispose();
    contactNumberController.dispose();
    employeeNameController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  void goToNextStep() {
    if (fullNameController.text.isEmpty) {
      showError("Full Name is required!");
      return;
    }
    if (addressController.text.isEmpty) {
      showError("Address is required!");
      return;
    }
    if (emailController.text.isEmpty) {
      showError("Email is required!");
      return;
    }
    if (passwordController.text.isEmpty) {
      showError("Password is required!");
      return;
    }
    setState(() {
      stepOneCompleted = true;
    });
  }

  void goToFinalStep() {
    if (dateOfBirthController.text.isEmpty) {
      showError("Date of Birth is required!");
      return;
    }
    if (selectedGender == null) {
      showError("Please select a gender!");
      return;
    }
    setState(() {
      stepTwoCompleted = true;
    });
  }

  void signUpUser() {
    if (isStudent && (schoolNameController.text.isEmpty || studentIDController.text.isEmpty || contactNumberController.text.isEmpty)) {
      showError("Please complete student details!");
      return;
    }
    if (isEmployee && (employeeNameController.text.isEmpty || jobTitleController.text.isEmpty)) {
      showError("Please complete employee details!");
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sign Up Successful!")),
    );
    Navigator.pop(context);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildGenderSelection() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black,
      value: selectedGender,
      decoration: InputDecoration(
        labelText: "Gender",
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: ["Male", "Female", "Other"].map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedGender = value;
        });
      },
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
                colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.8)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Row(
                  children: [
                    Text("C", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange)),
                    const Text("NERGY GYM", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const Text("START YOUR FITNESS JOURNEY HERE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Column(
                    children: stepTwoCompleted
                        ? [
                            CheckboxListTile(
                              title: const Text("Student (Requires valid student ID)", style: TextStyle(color: Colors.white)),
                              value: isStudent,
                              onChanged: (bool? value) {
                                setState(() {
                                  isStudent = value ?? false;
                                  if (isStudent) isEmployee = false;
                                });
                              },
                            ),
                            if (isStudent) ...[
                              _buildTextField(schoolNameController, "School Name", Icons.school),
                              _buildTextField(studentIDController, "Student ID Number", Icons.badge),
                              _buildTextField(contactNumberController, "Contact Number", Icons.phone),
                            ],
                            CheckboxListTile(
                              title: const Text("Non-Student/Employee", style: TextStyle(color: Colors.white)),
                              value: isEmployee,
                              onChanged: (bool? value) {
                                setState(() {
                                  isEmployee = value ?? false;
                                  if (isEmployee) isStudent = false;
                                });
                              },
                            ),
                            if (isEmployee) ...[
                              _buildTextField(employeeNameController, "Employee Name", Icons.work),
                              _buildTextField(jobTitleController, "Job Title", Icons.business),
                            ],
                            const SizedBox(height: 20),
                            ElevatedButton(onPressed: signUpUser, child: const Text("Sign Up")),
                          ]
                        : stepOneCompleted
                            ? [
                                _buildTextField(dateOfBirthController, "Date of Birth", Icons.calendar_today),
                                _buildGenderSelection(),
                                ElevatedButton(onPressed: goToFinalStep, child: const Text("Next")),
                              ]
                            : [
                                _buildTextField(fullNameController, "Full Name", Icons.person),
                                _buildTextField(addressController, "Address", Icons.location_on),
                                _buildTextField(emailController, "Email", Icons.email),
                                _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
                                ElevatedButton(onPressed: goToNextStep, child: const Text("Next")),
                              ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
