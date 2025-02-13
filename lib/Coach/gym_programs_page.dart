import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GymProgramsPage(),
  ));
}

class GymProgramsPage extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {'exercise': 'Plate-Loaded Incline Chest Press', 'sets': '3', 'reps': '12', 'weight': '80.5kg', 'time': '10 mins'},
    {'exercise': 'Plate-Loaded Incline Chest Press', 'sets': '3', 'reps': '12', 'weight': '80.5kg', 'time': '10 mins'},
    {'exercise': 'Plate-Loaded Incline Chest Press', 'sets': '3', 'reps': '12', 'weight': '80.5kg', 'time': '10 mins'},
    {'exercise': 'Plate-Loaded Incline Chest Press', 'sets': '3', 'reps': '12', 'weight': '80.5kg', 'time': '10 mins'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Thursday'),
        backgroundColor: Colors.black,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications))],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Chest/Back', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {},
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add Exercise', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[800],
                      child: Icon(Icons.image, color: Colors.grey),
                    ),
                    title: Text(
                      exercises[index]['exercise']!,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${exercises[index]['sets']} sets x ${exercises[index]['reps']} reps - ${exercises[index]['weight']}',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.orange, size: 16),
                            SizedBox(width: 4),
                            Text(exercises[index]['time']!, style: TextStyle(color: Colors.grey[400])),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditExerciseDialog(context, exercises[index]);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              onPressed: () {},
              child: Text('STAR WORKOUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditExerciseDialog(BuildContext context, Map<String, String> exercise) {
    TextEditingController setsController = TextEditingController(text: exercise['sets']);
    TextEditingController repsController = TextEditingController(text: exercise['reps']);
    TextEditingController weightController = TextEditingController(text: exercise['weight']);
    TextEditingController timeController = TextEditingController(text: exercise['time']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets')),
              TextField(controller: repsController, decoration: InputDecoration(labelText: 'Reps')),
              TextField(controller: weightController, decoration: InputDecoration(labelText: 'Weight')),
              TextField(controller: timeController, decoration: InputDecoration(labelText: 'Time')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            TextButton(
              onPressed: () {
                exercise['sets'] = setsController.text;
                exercise['reps'] = repsController.text;
                exercise['weight'] = weightController.text;
                exercise['time'] = timeController.text;
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
