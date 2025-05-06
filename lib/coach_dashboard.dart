import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Coach/routine_page.dart';
import 'Coach/gym_programs_page.dart';
import 'Coach/qr_page.dart';
import 'Coach/members_progress_page.dart';
import 'Coach/profile_page.dart';
import 'Coach/messages_page.dart';

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
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    });
  }

  Future<void> _saveSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications'),
        content: Text('You have no new notifications.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Color(0xFF1E1E1E),
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Christian Jay',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text('christian@example.com',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: _showNotificationsDialog,
                ),
              ],
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _saveSelectedIndex(index).then((_) {
            setState(() {
              _selectedIndex = index;
            });
          });
        },
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFFFF9800),
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
        ],
      ),
      floatingActionButton: Container(
        width: 45,
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.chat_bubble_outline,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
