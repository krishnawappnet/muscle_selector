import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:muscle_selector/src/widgets/muscle_painter.dart';
import '../parser.dart';
import '../size_controller.dart';

class MusclePickerMap extends StatefulWidget {
  final double? width;
  final double? height;
  final String map;
  final Function(List<Muscle> muscles) onChanged;
  final Color? strokeColor;
  final Color? selectedColor;
  final Color? dotColor;
  final bool? actAsToggle;

  const MusclePickerMap({
    Key? key,
    required this.map,
    required this.onChanged,
    this.width,
    this.height,
    this.strokeColor,
    this.selectedColor,
    this.dotColor,
    this.actAsToggle,
  }) : super(key: key);

  @override
  MusclePickerMapState createState() => MusclePickerMapState();
}

class MusclePickerMapState extends State<MusclePickerMap> {
  final List<Muscle> _muscleList = [];
  final List<Muscle> selectedMuscles = [];

  final _sizeController = SizeController.instance;
  Size? mapSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMuscleList();
    });
  }

  _loadMuscleList() async {
    final list = await Parser.instance.svgToMuscleList(widget.map);
    _muscleList.clear();
    setState(() {
      _muscleList.addAll(list);
      mapSize = _sizeController.mapSize;
    });
    print(list);
  }

  void clearSelect() {
    setState(() {
      selectedMuscles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var muscle in _muscleList) _buildStackItem(muscle),
      ],
    );
  }

  Widget _buildStackItem(Muscle muscle) {

    final bool isSelectable = muscle.id != 'human_body';

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () => {
        if (isSelectable) {
          (widget.actAsToggle ?? false) ? _toggleButton(muscle) : _useButton(muscle)
        }
      },
      child: CustomPaint(
        isComplex: true,
        foregroundPainter: MusclePainter(
          muscle: muscle,
          selectedMuscles: selectedMuscles,
          dotColor: widget.dotColor,
          selectedColor: widget.selectedColor,
          strokeColor: widget.strokeColor,
        ),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? double.infinity,
          constraints: BoxConstraints(
            maxWidth: mapSize?.width ?? 0,
            maxHeight: mapSize?.height ?? 0,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  void _toggleButton(Muscle muscle) {
    setState(() {
      if (selectedMuscles.contains(muscle)) {
        selectedMuscles.remove(muscle);
      } else {
        selectedMuscles.add(muscle);
      }
      widget.onChanged.call(selectedMuscles);
    });
  }

  void _useButton(Muscle muscle) {
    setState(() {
      if (!selectedMuscles.contains(muscle)) {
        selectedMuscles.add(muscle);
      }
      widget.onChanged.call(selectedMuscles);
    });
  }
}
