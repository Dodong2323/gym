// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: GuestScreen(),
//     );
//   }
// }

// class GuestScreen extends StatefulWidget {
//   @override
//   _GuestScreenState createState() => _GuestScreenState();
// }

// class _GuestScreenState extends State<GuestScreen> {
//   String? selectedOption;

//   // Function to handle the skip action
//   void _handleSkip() {
//     Navigator.popUntil(context, (route) => route.isFirst);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.orange),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _handleSkip, // Use the skip function here
//             child: const Text("Skip", style: TextStyle(color: Colors.orange)),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             const _ProgressIndicator(0), // Step 1 of 3
//             const SizedBox(height: 30),
//             const Text(
//               "Who am I?",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Let us know if you’re a student or not a student.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.white70),
//             ),
//             const SizedBox(height: 40),
//             _buildOptionButton("I'm a Student"),
//             const SizedBox(height: 15),
//             _buildOptionButton("I'm not a Student"),
//             const Spacer(),
//             _buildContinueButton(context),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionButton(String text) {
//     bool isSelected = selectedOption == text;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedOption = text;
//         });
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange : Colors.black,
//           border: Border.all(color: Colors.orange, width: 2),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? Colors.black : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContinueButton(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedOption != null ? Colors.orange : Colors.grey,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       onPressed: selectedOption != null
//           ? () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => PersonalInformationScreen()),
//               );
//             }
//           : null,
//       child: const Text("Continue"),
//     );
//   }
// }

// class PersonalInformationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.orange),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   const Text(
//                     "Personal Information",
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   const SizedBox(height: 10),
//                   const _ProgressIndicator(1), // Step 2 of 3
//                   const SizedBox(height: 15),
//                   const Text(
//                     "Please fill out the required details below to get your First QR Code.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 14, color: Colors.white70),
//                   ),
//                   const SizedBox(height: 25),
//                 ],
//               ),
//             ),
//             _buildTextField(label: "First name"),
//             _buildTextField(label: "Middle name"),
//             _buildTextField(label: "Last name"),
//             Row(
//               children: [
//                 Expanded(child: _buildTextField(label: "Date of birth")),
//                 const SizedBox(width: 10),
//                 Expanded(child: _buildTextField(label: "Gender")),
//               ],
//             ),
//             _buildTextField(label: "School name"),
//             const SizedBox(height: 30),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => QrCodeScreen()),
//                   );
//                 },
//                 child: const Text("Continue"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({required String label}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextField(
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.white70),
//           filled: true,
//           fillColor: Colors.black,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Colors.orange),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class QrCodeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.download, color: Colors.orange),
//           onPressed: () {
//             // Implement download functionality here
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.privacy_tip, color: Colors.orange),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             const _ProgressIndicator(2), // Step 3 of 3
//             const SizedBox(height: 30),
//             const Text(
//               "Your QR Code",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Your QR code is ready for you to visit our fitness gym. "
//               "This QR code serves as for you by recognize us",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.white70),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Note: You can use this QR code once you try our session workout.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.white54),
//             ),
//             const SizedBox(height: 40),
//             // Placeholder for QR Code
//             Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Center(
//                 child: Text(
//                   "QR Code",
//                   style: TextStyle(color: Colors.black, fontSize: 18),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 // Navigate back to the login screen
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: const Text("Back into login"),
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 // Implement skip functionality here
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: const Text(
//                 "Skip, I'll save it later",
//                 style: TextStyle(color: Colors.orange, fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PrivacyPolicyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background Image
//           Image.asset(
//             'assets/images/gym_background.jpg', // Replace with your image path
//             fit: BoxFit.cover,
//           ),
//           // Dark overlay
//           Container(
//             color: Colors.black.withOpacity(0.5),
//           ),
//           // Content
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.orange),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Privacy Policy",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Chergy gym rules.",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "1. Conserve each on how to use the gym props.\n"
//                   "2. Use facilities and equipment at your own risk.\n"
//                   "3. Retourments to rack after use.\n"
//                   "4. Initiate under the age of 16 must have parents or guardians permission.\n"
//                   "5. Report any damages to the management immediately DO NOT USE.\n"
//                   "6. STOP exercising if you feel pain, discomfort, nausea, dizziness or short-ness of breath.\n"
//                   "7. Wear proper gym clothing. NO LIPPERS.\n"
//                   "8. NO LITTERING.\n"
//                   "9. NO SMOKING.\n"
//                   "10. NO LITTERING.\n"
//                   "11. Use provided sanitizer stations.\n"
//                   "12. Please be COURTEOUS AND RESPECTFUL of other gym users.",
//                   style: TextStyle(fontSize: 16, color: Colors.white70),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProgressIndicator extends StatelessWidget {
//   final int step;
//   const _ProgressIndicator(this.step);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(3, (index) {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           width: 20,
//           height: 5,
//           decoration: BoxDecoration(
//             color: index <= step ? Colors.orange : Colors.grey,
//             borderRadius: BorderRadius.circular(5),
//           ),
//         );
//       }),
//     );
//   }
// }
