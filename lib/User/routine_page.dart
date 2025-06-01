import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      cardColor: const Color(0xFF2A2A2A),
    ),
    home: RoutinePage(),
  ));
}

// ---------------------------
// Routine Page
// ---------------------------
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
          content: SingleChildScrollView(
            child: Column(
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _selectedIndex == 0
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkoutDetailPage(workout: workout),
                            ),
                          );
                        },
                        child: Card(
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
                                    style: TextStyle(color: Colors.grey[400])),
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
                                    style: TextStyle(color: Colors.grey[400])),
                                SizedBox(height: 16),
                                Text("Explore our Energy Gym programs",
                                    style: TextStyle(color: Colors.grey[400])),
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
    );
  }
}

// ---------------------------
// Workout Detail Page
// ---------------------------
class WorkoutDetailPage extends StatelessWidget {
  final Map<String, dynamic> workout;

  const WorkoutDetailPage({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout['title']),
        backgroundColor: Colors.orange[800],
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Duration: ${workout['duration']}",
                style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 8),
            Text("Exercises: ${workout['exercises']}",
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            SizedBox(height: 16),
            Text("Exercise List:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 8),
            Text(workout['exerciseNames'],
                style: TextStyle(color: Colors.grey[400])),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WorkoutDayScreen()),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
              child: Text("Start Today's Workout"),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------
// Workout Day Screen
// ---------------------------
class WorkoutDayScreen extends StatelessWidget {
  final List<Map<String, dynamic>> exercises = List.generate(4, (index) {
    return {
      "title": "Incline Chest Press",
      "setsReps": "3 sets x 12 reps",
      "rest": "Rest: 30 sec",
      "image": "https://via.placeholder.com/80x80.png?text=Exercise",
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Today's Workout"),
        backgroundColor: Colors.orange[800],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            color: Colors.grey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Image.network(exercise['image'], width: 60, height: 60),
              title: Text(exercise['title'],
                  style: TextStyle(color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise['setsReps'],
                      style: TextStyle(color: Colors.grey[400])),
                  Text(exercise['rest'],
                      style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
