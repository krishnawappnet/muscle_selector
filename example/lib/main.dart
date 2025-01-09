import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muscle_selector/muscle_selector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeView(),
      theme: ThemeData.light(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Muscle>? selectedMuscles;
  final GlobalKey<MusclePickerMapState> _mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(child:   MusclePickerMap(
                  key: _mapKey,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height ,
                  map: Maps.BODY,
                  isEditing: false,
                  // initialSelectedGroups: const ['chest', 'glutes', 'neck', 'lower_back'],
                  onChanged: (muscles) {
                    setState(() {
                      selectedMuscles = muscles;
                    });
                  },
                  actAsToggle: true,
                  dotColor: Colors.black,
                  selectedColor: Colors.lightBlueAccent,
                  strokeColor: Colors.black,
                
    )));
  }
}
