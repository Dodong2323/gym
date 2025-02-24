import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GymProgramsPage(),
  ));
}

class GymProgramsPage extends StatefulWidget {
  @override
  _GymProgramsPageState createState() => _GymProgramsPageState();
}

class _GymProgramsPageState extends State<GymProgramsPage> {
  List<Map<String, dynamic>> programs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Programs'),
        backgroundColor: Colors.orange.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create program screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProgramExercisePage(
                    onSave: (program) {
                      setState(() {
                        programs.add(program); // Save the new program
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: programs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You don't have any programs yet.",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to create program screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProgramExercisePage(
                            onSave: (program) {
                              setState(() {
                                programs.add(program); // Save the new program
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange.shade600),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                    ),
                    child: const Text(
                      'Create Program',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: programs.length,
              itemBuilder: (context, index) {
                final program = programs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(program['title']),
                    subtitle:
                        Text('Exercises: ${program['exercises'].join(', ')}'),
                  ),
                );
              },
            ),
    );
  }
}

class CreateProgramExercisePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const CreateProgramExercisePage({super.key, required this.onSave});

  @override
  _CreateProgramExercisePageState createState() =>
      _CreateProgramExercisePageState();
}

class _CreateProgramExercisePageState extends State<CreateProgramExercisePage> {
  final List<Map<String, String>> exercises = [
    {
      'name': 'Dumbbell Bench Press',
      'muscle': 'Chest',
      'equipment': 'Dumbbells'
    },
    {
      'name': 'Incline Dumbbell Bench Press',
      'muscle': 'Chest',
      'equipment': 'Dumbbells'
    },
    {'name': 'Leg Press', 'muscle': 'Legs', 'equipment': 'Machine'},
    {'name': 'Squat', 'muscle': 'Legs', 'equipment': 'Barbell'},
    {'name': 'Deadlift', 'muscle': 'Legs', 'equipment': 'Barbell'},
    {'name': 'Lat Pulldown', 'muscle': 'Back', 'equipment': 'Machine'},
    {'name': 'Pull Over', 'muscle': 'Back', 'equipment': 'Machine'},
    {'name': 'T-Bar Row', 'muscle': 'Back', 'equipment': 'Machine'},
    {'name': 'Dumbbell Row', 'muscle': 'Back', 'equipment': 'Dumbbells'},
    {
      'name': 'Romanian Deadlift (RDL)',
      'muscle': 'Legs',
      'equipment': 'Barbell'
    },
  ];

  final List<String> muscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Arms',
    'Shoulders',
    'Core'
  ];
  final List<String> equipmentTypes = ['Dumbbells', 'Barbell', 'Machine'];

  List<String> selectedExercises = [];
  String? selectedMuscleGroup;
  String? selectedEquipment;
  final TextEditingController _programTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Program'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program Title Input
            TextField(
              controller: _programTitleController,
              decoration: InputDecoration(
                hintText: 'Enter Program Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Muscle Group and Equipment Dropdowns (Side by Side)
            Row(
              children: [
                // Muscle Group Dropdown
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100, // Orange background color
                      borderRadius: BorderRadius.circular(8), // Soft edges
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedMuscleGroup,
                            hint: const Text('Muscles',
                                style: TextStyle(color: Colors.grey)),
                            items: muscleGroups.map((muscle) {
                              return DropdownMenuItem(
                                value: muscle,
                                child: Text(muscle),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMuscleGroup = value; // Apply filter
                              });
                            },
                            underline:
                                const SizedBox(), // Remove default underline
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.grey),
                          ),
                        ),
                        if (selectedMuscleGroup != null)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                selectedMuscleGroup = null; // Clear filter
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Equipment Dropdown
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100, // Orange background color
                      borderRadius: BorderRadius.circular(8), // Soft edges
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedEquipment,
                            hint: const Text('Machine',
                                style: TextStyle(color: Colors.grey)),
                            items: equipmentTypes.map((equipment) {
                              return DropdownMenuItem(
                                value: equipment,
                                child: Text(equipment),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedEquipment = value; // Apply filter
                              });
                            },
                            underline:
                                const SizedBox(), // Remove default underline
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.grey),
                          ),
                        ),
                        if (selectedEquipment != null)
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                selectedEquipment = null; // Clear filter
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Exercise List
            Expanded(
              child: ListView(
                children: exercises.where((exercise) {
                  bool filterByMuscle = selectedMuscleGroup == null ||
                      exercise['muscle'] == selectedMuscleGroup;
                  bool filterByEquipment = selectedEquipment == null ||
                      exercise['equipment'] == selectedEquipment;
                  return filterByMuscle && filterByEquipment;
                }).map((exercise) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: CheckboxListTile(
                      title: Text(exercise['name']!),
                      value: selectedExercises.contains(exercise['name']),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedExercises.add(exercise['name']!);
                          } else {
                            selectedExercises.remove(exercise['name']!);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            // Save Program Button
            ElevatedButton(
              onPressed: () {
                if (_programTitleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a program title')),
                  );
                } else if (selectedExercises.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select at least one exercise')),
                  );
                } else {
                  // Save the program
                  widget.onSave({
                    'title': _programTitleController.text,
                    'exercises': selectedExercises,
                  });
                  Navigator.pop(context); // Go back to the Gym Programs page
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.orange.shade600),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
              ),
              child: const Text(
                'Save Program',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
