import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:provider/provider.dart';
import 'muscle_selector_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MuscleSelectorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muscle Selector',
        home: const MuscleSelectionScreen(),
        theme: ThemeData.light(),
      ),
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
                    builder: (context) => const MuscleView(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Muscle Selector',
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

class MuscleView extends StatelessWidget {
  const MuscleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscle Selector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<MuscleSelectorProvider>().clearAllSelections();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle button for front/back view
          Consumer<MuscleSelectorProvider>(
            builder: (context, provider, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    provider.toggleView();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.isFrontView ? Colors.blue : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    provider.isFrontView ? 'Front View' : 'Back View',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          Consumer<MuscleSelectorProvider>(
              builder: (context, provider, child) {
                return MusclePickerMap(
                  key: ValueKey(provider.isFrontView), // Use ValueKey to force rebuild
                  map: provider.isFrontView ? Maps.BODY_FRONT : Maps.BODY_BACK,
                  isEditing: true,
                  initialSelectedMuscles: provider.selectedMuscles,
                  onChanged: (muscles) {
                    provider.setSelectedMuscles(muscles);
                  },
                  actAsToggle: true,
                  dotColor: Colors.black,
                  selectedColor: Colors.red,
                  strokeColor: Colors.black,
                );
              },
            ),
          
        ],
      ),
    );
  }
}
