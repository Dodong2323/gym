import 'package:flutter/material.dart';

class RoutinePage extends StatelessWidget {
  final List<Map<String, dynamic>> workouts = [
    {
      "header": "PREVIOUS WORKOUT - PUSH",
      "title": "Chest, Shoulder, Triceps",
      "duration": "89 mins",
      "exercises": "8 exercises",
      "exerciseNames": "Plate-Loaded Incline Chest Press - Single Arm Dumbbell Bench Press - Cable Press-Around - Dumbbell Lateral Raise Seated",
    },
    {
      "header": "PREVIOUS WORKOUT - PUSH",
      "title": "Chest, Shoulder, Triceps",
      "duration": "89 mins",
      "exercises": "8 exercises",
      "exerciseNames": "Plate-Loaded Incline Chest Press - Single Arm Dumbbell Bench Press - Cable Press-Around - Dumbbell Lateral Raise Seated",
    },
  ];

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
              Text("My Workout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Explore", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
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
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[800],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(workout['header'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Icon(Icons.more_vert, color: Colors.white),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workout['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("${workout['duration']} • ${workout['exercises']}", style: TextStyle(color: Colors.grey[400])),
                              SizedBox(height: 16),
                              Row(
                                children: List.generate(4, (index) => Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )),
                              ),
                              SizedBox(height: 12),
                              Text(workout['exerciseNames'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.play_arrow, color: Colors.grey[400], size: 28),
                                  SizedBox(width: 20),
                                  Icon(Icons.refresh, color: Colors.grey[400], size: 28),
                                  SizedBox(width: 20),
                                  Icon(Icons.share, color: Colors.grey[400], size: 28),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
