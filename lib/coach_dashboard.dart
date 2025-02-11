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
              backgroundColor: Colors.orange,
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
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Gym Programs'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Members Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessagesPage()),
          );
        },
        backgroundColor: Colors.orange.shade600,
        child: Icon(Icons.message),
      ),
    );
  }
}
