import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User/gym_programs_page.dart';
import 'User/qr_page.dart';
import 'User/logs_progress_page.dart';
import 'User/profile_page.dart';
import 'User/messages_page.dart';
import 'User/routine_page.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  final List<Widget> _pages = [
    Container(), // Routine with Tabs
    GymProgramsPage(),
    QRPage(),
    LogsProgressPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSelectedIndex();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    int storedIndex = prefs.getInt('selectedIndex') ?? 0;
    if (storedIndex >= _pages.length) storedIndex = 0;
    setState(() {
      _selectedIndex = storedIndex;
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

  Widget _buildRoutineWithTabs() {
    return Column(
      children: [
        // Tab Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.orange,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: "My Workout"),
              Tab(text: "Explore"),
            ],
          ),
        ),

        // Create Program Button
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: ElevatedButton.icon(
            onPressed: () {
              // Add create program functionality
            },
            icon: Icon(Icons.add),
            label: Text("Create Program"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2A2A2A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Tab Content Area
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              RoutinePage(),
              Center(
                child: Text(
                  'Explore Section',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF2A2A2A),
      ),
      home: Scaffold(
        body: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 16, right: 16, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.orange,
                              child: Text('K',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showNotificationsDialog,
                    child: Stack(
                      children: [
                        Icon(Icons.notifications_none,
                            color: Colors.white, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: _selectedIndex == 0
                  ? _buildRoutineWithTabs()
                  : _pages[_selectedIndex],
            ),
          ],
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) async {
            await _saveSelectedIndex(index);
            setState(() {
              _selectedIndex = index;
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
                  color:
                      _selectedIndex == 2 ? Colors.deepOrange : Colors.white),
              label: 'QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today,
                  color: _selectedIndex == 3
                      ? Colors.deepOrangeAccent
                      : Colors.white),
              label: 'Logs & Progress',
            ),
          ],
        ),

        // Floating Chat Button
        floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 2)
            ? Container(
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
              )
            : null,
      ),
    );
  }
}
