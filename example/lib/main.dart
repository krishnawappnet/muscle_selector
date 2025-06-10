import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muscle Selector',
      home: const MuscleSelectionScreen(),
      theme: ThemeData.light(),
    );
  }
}

class MuscleSelectionScreen extends StatelessWidget {
  const MuscleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Muscle View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MuscleView(
                      isFrontView: true,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Body 1',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MuscleView(
                      isFrontView: false,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Body 2',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MuscleView extends StatefulWidget {
  final bool isFrontView;

  const MuscleView({
    super.key,
    required this.isFrontView,
  });

  @override
  MuscleViewState createState() => MuscleViewState();
}

class MuscleViewState extends State<MuscleView> {
  Set<Muscle>? selectedMuscles;
  final GlobalKey<MusclePickerMapState> _mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFrontView ? 'Body 1' : 'Body 2'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _mapKey.currentState?.clearSelect();
              setState(() {
                selectedMuscles = null;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: MusclePickerMap(
          key: _mapKey,
          map: widget.isFrontView ? Maps.BODY_FRONT : Maps.BODY_BACK,
          isEditing: false,
          onChanged: (muscles) {
            setState(() {
              selectedMuscles = muscles;
            });
          },
          actAsToggle: true,
          dotColor: Colors.black,
          selectedColor: Colors.red,
          strokeColor: Colors.black,
        ),
      ),
    );
  }
}
