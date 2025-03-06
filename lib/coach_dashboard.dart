import 'package:flutter/material.dart';
import 'Coach/routine_page.dart';
import 'Coach/gym_programs_page.dart';
import 'Coach/qr_page.dart';
import 'Coach/members_progress_page.dart';
import 'Coach/profile_page.dart';
import 'Coach/messages_page.dart'; // Import MessagesPage

class CoachDashboard extends StatefulWidget {
  @override
  _CoachDashboardState createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RoutinePage(),
    GymProgramsPage(),
    QRPage(),
    MembersProgressPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            top: 40,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Notifications'),
                    content: Text('You have no new notifications.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.red,
              mini: true,
              child: Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Color(0xFF1E1E1E), // Dark background color
        selectedItemColor: Color(0xFFFF9800), // Orange for selected item
        unselectedItemColor: Colors.white,
        selectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list,
                color: _selectedIndex == 0 ? Colors.orange : Colors.white),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center,
                color:
                    _selectedIndex == 1 ? Colors.orangeAccent : Colors.white),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner,
                color: _selectedIndex == 2 ? Colors.deepOrange : Colors.white),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today,
                color: _selectedIndex == 3
                    ? Colors.deepOrangeAccent
                    : Colors.white),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,
                color: _selectedIndex == 4 ? Colors.white : Colors.white70),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 45, // Adjusted size to match the uploaded image
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.orange.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagesPage()),
            );
          },
          backgroundColor:
              Colors.transparent, // Keep transparent for gradient effect
          elevation: 0, // Remove default floating effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Keep circular
          ),
          child: Icon(
            Icons
                .chat_bubble_outline, // Outlined chat bubble similar to your image
            color: Colors.black, // Matches the uploaded design
            size: 20, // 🔹 Reduced size for a smaller icon
          ),
        ),
      ),
    );
  }
}
