import 'package:flutter/services.dart' show rootBundle;
import 'package:muscle_selector/muscle_selector.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:collection/collection.dart';
import 'size_controller.dart';
import 'constant.dart';

class Parser {
  static Parser? _instance;

  static Parser get instance {
    _instance ??= Parser._init();
    return _instance!;
  }

  final sizeController = SizeController.instance;

  Parser._init();

  static const muscleGroups = {
    // Front view muscles
    'front_head': ['front_head'],
    'front_neck': ['front_neck'],
    'front_right_neck': ['front_right_neck'],
    'front_left_neck': ['front_left_neck'],
    'front_right_chest': ['front_right_chest'],
    'front_left_chest': ['front_left_chest'],
    'right_obliques': ['right_obliques'],
    'left_obliques': ['left_obliques'],
    'abs': ['abs'],
    'right_forearm': ['right_forearm'],
    'left_forearm': ['left_forearm'],
    'right_biceps': ['right_biceps'],
    'left_biceps': ['left_biceps'],
    'right_front_deltoids': ['right_front_deltoids'],
    'left_front_deltoids': ['left_front_deltoids'],
    'left_knee': ['left_knee'],
    'right_knee': ['right_knee'],
    'left_calves1': ['left_calves1'],
    'left_calves2': ['left_calves2'],
    'right_calves1': ['right_calves1'],
    'right_calves2': ['right_calves2'],
    'right_quadriceps1': ['right_quadriceps1'],
    'right_quadriceps2': ['right_quadriceps2'],
    'right_quadriceps3': ['right_quadriceps3'],
    'right_quadriceps4': ['right_quadriceps4'],
    'left_quadriceps1': ['left_quadriceps1'],
    'left_quadriceps2': ['left_quadriceps2'],
    'left_quadriceps3': ['left_quadriceps3'],
    'left_quadriceps4': ['left_quadriceps4'],
    'right_abductors': ['right_abductors'],
    'left_abductors': ['left_abductors'],
    'front_right_foot': ['front_right_foot'],
    'front_left_foot': ['front_left_foot'],
    'front_right_hand': ['front_right_hand'],
    'front_left_hand': ['front_left_hand'],

    // Back view muscles
    'back_head': ['back_head'],
    'posterior_trapezius': ['posterior_trapezius'],
    'posterior_right_trapezius': ['posterior_right_trapezius'],
    'posterior_left_trapezius': ['posterior_left_trapezius'],
    'posterior_right_back_deltoids': ['posterior_right_back_deltoids'],
    'posterior_left_back_deltoids': ['posterior_left_back_deltoids'],
    'posterior_right_triceps': ['posterior_right_triceps'],
    'posterior_left_triceps': ['posterior_left_triceps'],
    'posterior_right_forearm': ['posterior_right_forearm'],
    'posterior_left_forearm': ['posterior_left_forearm'],
    'posterior_right_upper_back1': ['posterior_right_upper_back1'],
    'posterior_right_upper_back2': ['posterior_right_upper_back2'],
    'posterior_left_upper_back1': ['posterior_left_upper_back1'],
    'posterior_left_upper_back2': ['posterior_left_upper_back2'],
    'posterior_lower_back': ['posterior_lower_back'],
    'back_right_lower_back1': ['back_right_lower_back1'],
    'back_right_lower_back2': ['back_right_lower_back2'],
    'back_left_lower_back1': ['back_left_lower_back1'],
    'back_left_lower_back2': ['back_left_lower_back2'],
    'posterior_right_gluteal': ['posterior_right_gluteal'],
    'posterior_left_gluteal': ['posterior_left_gluteal'],
    'posterior_left_hamstring': ['posterior_left_hamstring'],
    'posterior_right_hamstring': ['posterior_right_hamstring'],
    'posterior_right_side_hamstring': ['posterior_right_side_hamstring'],
    'posterior_left_side_hamstring': ['posterior_left_side_hamstring'],
    'posterior_right1_calves': ['posterior_right1_calves'],
    'posterior_right2_calves': ['posterior_right2_calves'],
    'posterior_left1_calves': ['posterior_left1_calves'],
    'posterior_left2_calves': ['posterior_left2_calves'],
    'posterior_right_adductor': ['posterior_right_adductor'],
    'posterior_left_adductor': ['posterior_left_adductor'],
    'back_right_foot': ['back_right_foot'],
    'back_left_foot': ['back_left_foot'],
    'back_right_hand': ['back_right_hand'],
    'back_left_hand': ['back_left_hand'],
  };

  Set<Muscle> getMusclesByGroups(
      List<String> groupKeys, List<Muscle> muscleList) {
    final groupIds =
        groupKeys.expand((groupKey) => muscleGroups[groupKey] ?? []).toSet();
    return muscleList.where((muscle) => groupIds.contains(muscle.id)).toSet();
  }

  Future<List<Muscle>> svgToMuscleList(String body) async {
    final svgMuscle =
        await rootBundle.loadString('${Constants.ASSETS_PATH}/$body');
    List<Muscle> muscleList = [];

    final regExp = RegExp(Constants.MAP_REGEXP,
        multiLine: true, caseSensitive: false, dotAll: false);

    regExp.allMatches(svgMuscle).forEach((muscleData) {
      final id = muscleData.group(1)!;
      final title = muscleData.group(2)!;
      final path = parseSvgPath(muscleData.group(3)!);

      sizeController.addBounds(path.getBounds());

      final muscle = Muscle(id: id, title: title, path: path);

      muscleList.add(muscle);

      final group = muscleGroups.entries
          .firstWhereOrNull((entry) => entry.value.contains(id));
      if (group != null) {
        for (var groupId in group.value) {
          if (groupId != id) {
            final groupMuscle = Muscle(id: groupId, title: title, path: path);
            muscleList.add(groupMuscle);
          }
        }
      }
    });

    return muscleList;
  }
}
