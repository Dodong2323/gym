import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final List<Map<String, dynamic>> workouts = [
    {
      "header": "PREVIOUS WORKOUT - PUSH",
      "title": "Chest, Shoulder, Triceps",
      "duration": "89 mins",
      "exercises": "8 exercises",
      "exerciseNames":
          "Plate-Loaded Incline Chest Press - Single Arm Dumbbell Bench Press - Cable Press-Around - Dumbbell Lateral Raise Seated",
    },
    {
      "header": "PREVIOUS WORKOUT - PUSH",
      "title": "Chest, Shoulder, Triceps",
      "duration": "89 mins",
      "exercises": "8 exercises",
      "exerciseNames":
          "Plate-Loaded Incline Chest Press - Single Arm Dumbbell Bench Press - Cable Press-Around - Dumbbell Lateral Raise Seated",
    },
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddWorkoutModal(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController exercisesController = TextEditingController();
    TextEditingController exerciseNamesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Workout"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Workout Type")),
              TextField(
                  controller: durationController,
                  decoration: InputDecoration(labelText: "Minutes"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: exercisesController,
                  decoration: InputDecoration(labelText: "Exercises")),
              TextField(
                  controller: exerciseNamesController,
                  decoration: InputDecoration(labelText: "Exercise Info")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  workouts.add({
                    "header": "NEW WORKOUT",
                    "title": titleController.text,
                    "duration": "${durationController.text} mins",
                    "exercises": "${exercisesController.text} exercises",
                    "exerciseNames": exerciseNamesController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
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
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/user_profile.png'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("user@example.com",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => _onItemTapped(0),
                        child: Text("My Workouts",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : Colors.grey[600])),
                      ),
                      GestureDetector(
                        onTap: () => _onItemTapped(1),
                        child: Text("Explore",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedIndex == 1
                                    ? Colors.white
                                    : Colors.grey[600])),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddWorkoutModal(context),
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text('New Workout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.share, color: Colors.white),
                          label: Text('Share Workout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectedIndex == 0
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final workout = workouts[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 16),
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange[800],
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(workout['header'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Icon(Icons.more_vert, color: Colors.white),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(workout['title'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text(
                                        "${workout['duration']} • ${workout['exercises']}",
                                        style:
                                            TextStyle(color: Colors.grey[400])),
                                    SizedBox(height: 16),
                                    Row(
                                      children: List.generate(
                                        4,
                                        (index) => Expanded(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(workout['exerciseNames'],
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12)),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.play_arrow,
                                            color: Colors.grey[400], size: 28),
                                        SizedBox(width: 20),
                                        Icon(Icons.refresh,
                                            color: Colors.grey[400], size: 28),
                                        SizedBox(width: 20),
                                        Icon(Icons.share,
                                            color: Colors.grey[400], size: 28),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Programs",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Card(
                            color: Colors.grey[900],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Arnold Split",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text("Gym Based Program",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text("Quick Actions",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Card(
                            color: Colors.grey[900],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("On-Demand",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text("Popular",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  SizedBox(height: 16),
                                  Text("Explore our Energy Gym programs",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  SizedBox(height: 16),
                                  Text("Recommendations",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16),
                                  Text("- Back beginning: 0.5 hours",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Text("- End",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  SizedBox(height: 16),
                                  Text("Specializations",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16),
                                  Text("- Back beginning: 1.0 hours",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Text("- End",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(RoutinePage());
}
