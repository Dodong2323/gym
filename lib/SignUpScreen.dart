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
    final TextEditingController employeeNameController = TextEditingController();
    final TextEditingController jobTitleController = TextEditingController();
    final TextEditingController heightLbsController = TextEditingController();
    final TextEditingController heightCmController = TextEditingController();
    final TextEditingController weightLbsController = TextEditingController();
    final TextEditingController weightKgController = TextEditingController();
  final TextEditingController trainingPreferenceController = TextEditingController();
final TextEditingController nutritionGoalsController = TextEditingController();
String? selectedLifterLevel;
String? selectedTraining;
String? selectedNutrition;


    String? selectedGender;
    bool obscurePassword = true;
    bool isStudent = false;
    bool isEmployee = false;

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
                      // Personal Information Card
                      Card(
                        color: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
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
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Student Information Card
                      Card(
                        color: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Employee Information Card
                      Card(
                        color: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
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
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Physical Attributes (Height & Weight) Card
                      Card(
                        color: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildTextField(heightLbsController, "Height (LBS)", Icons.height)),
                                  SizedBox(width: 12),
                                  Expanded(child: _buildTextField(heightCmController, "Height (CM)", Icons.height)),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildTextField(weightLbsController, "Weight (LBS)", Icons.monitor_weight)),
                                  SizedBox(width: 12),
                                  Expanded(child: _buildTextField(weightKgController, "Weight (KG)", Icons.monitor_weight)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Training Preference Section
Card(
  color: Colors.white.withOpacity(0.15),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("What's your experience level as a lifter?", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text("Beginner"),
              selected: selectedTraining == "Beginner",
              onSelected: (selected) => setState(() => selectedTraining = "Beginner"),
            ),
            ChoiceChip(
              label: Text("Intermediate"),
              selected: selectedTraining == "Intermediate",
              onSelected: (selected) => setState(() => selectedTraining = "Intermediate"),
            ),
            ChoiceChip(
              label: Text("Advanced"),
              selected: selectedTraining == "Advanced",
              onSelected: (selected) => setState(() => selectedTraining = "Advanced"),
            ),
             ChoiceChip(
              label: Text("Pro"),
              selected: selectedTraining == "Pro",
              onSelected: (selected) => setState(() => selectedTraining = "Pro"),
            ),
          ],
        ),
      ],
    ),
  ),
),

// Nutrition Goals Section
Card(
  color: Colors.white.withOpacity(0.15),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Nutrition Goals", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text("Weight Loss"),
              selected: selectedNutrition == "Weight Loss",
              onSelected: (selected) => setState(() => selectedNutrition = "Weight Loss"),
            ),
            ChoiceChip(
              label: Text("Maintain Weight"),
              selected: selectedNutrition == "Maintain Weight",
              onSelected: (selected) => setState(() => selectedNutrition = "Maintain Weight"),
            ),
            ChoiceChip(
              label: Text("Gain Mass"),
              selected: selectedNutrition == "Gain Mass",
              onSelected: (selected) => setState(() => selectedNutrition = "Gain Masse"),
            ),
             ChoiceChip(
              label: Text("Just for exploring"),
              selected: selectedNutrition == "Just for exploring",
              onSelected: (selected) => setState(() => selectedNutrition = "Just for exploring"),
            ),
          ],
        ),
      ],
    ),
  ),
),

// Lifter Level Section
Card(
  color: Colors.white.withOpacity(0.15),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Lifter Level", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text("Beginner"),
              selected: selectedLifterLevel == "Beginner",
              onSelected: (selected) => setState(() => selectedLifterLevel = "Beginner"),
            ),
            ChoiceChip(
              label: Text("Intermediate"),
              selected: selectedLifterLevel == "Intermediate",
              onSelected: (selected) => setState(() => selectedLifterLevel = "Intermediate"),
            ),
            ChoiceChip(
              label: Text("Advanced"),
              selected: selectedLifterLevel == "Advanced",
              onSelected: (selected) => setState(() => selectedLifterLevel = "Advanced"),
            ),
          ],
        ),
      ],
    ),
  ),
),


                      // Sign-Up Button
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
