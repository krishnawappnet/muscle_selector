import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:muscle_selector/src/parser.dart';

class SelectedMusclesChips extends StatelessWidget {
  final Set<Muscle> selectedMuscles;
  final Function(Muscle) onMuscleRemoved;

  const SelectedMusclesChips({
    Key? key,
    required this.selectedMuscles,
    required this.onMuscleRemoved,
  }) : super(key: key);

  Map<String, List<Muscle>> _groupSelectedMuscles() {
    Map<String, List<Muscle>> groupedMuscles = {};

    for (var muscle in selectedMuscles) {
      String? groupKey;
      for (var entry in Parser.muscleGroups.entries) {
        if (entry.value.contains(muscle.id)) {
          groupKey = entry.key;
          break;
        }
      }

      if (groupKey != null) {
        if (!groupedMuscles.containsKey(groupKey)) {
          groupedMuscles[groupKey] = [];
        }
        groupedMuscles[groupKey]!.add(muscle);
      }
    }

    return groupedMuscles;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMuscles = _groupSelectedMuscles();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: groupedMuscles.entries.map((entry) {
          final muscles = entry.value;
          final firstMuscle = muscles.first;
          return Chip(
            label: Text(
              firstMuscle.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () {
              // Remove all muscles in the group
              for (var muscle in muscles) {
                onMuscleRemoved(muscle);
              }
            },
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        }).toList(),
      ),
    );
  }
}
