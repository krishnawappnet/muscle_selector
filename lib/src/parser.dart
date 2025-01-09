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
    'neck': ['neck'],
    'chest': ['chest'],
    'obliques': ['obliques',],
    'abs': ['abs'],
    'forearm': ['forearm'],
    'biceps': ['biceps'],
    'front_deltoids': ['front_deltoids'],
    'posterior_gluteal': ['gluteal'],
    'posterior_lower_back': ['lower_back'],
    'posterior_trapezius': ['trapezius',],
    'posterior_upper_back': ['upper_back'],
    'posterior_back_deltoids': ['back_deltoids'],
    'posterior_triceps': ['triceps'],
    "posterior_forearm": ['posterior_forearm'],
    'knees': ['knees', ],
    'calves': ['calves'],
    'posterior_calves': ['posterior_calves'],
    'posterior_hamstring': ['posterior_hamstring',],  
    'posterior_adductor': ['posterior_adductor',],
    'quadriceps': ['quadriceps'],
    'abductors': ['abductors'],
    'head': ['head'],
    'posterior_head': ['posterior_head'],

    'right_foot': ['right_foot'],
    'left_foot': ['left_foot'],
    'right_hand': ['right_hand'],
    'left_hand': ['left_hand'],
    
  };

  Set<Muscle> getMusclesByGroups(List<String> groupKeys, List<Muscle> muscleList) {
    final groupIds = groupKeys.expand((groupKey) => muscleGroups[groupKey] ?? []).toSet();
    return muscleList.where((muscle) => groupIds.contains(muscle.id)).toSet();
  }

  Future<List<Muscle>> svgToMuscleList(String body) async {
    final svgMuscle = await rootBundle.loadString('${Constants.ASSETS_PATH}/$body');
    List<Muscle> muscleList = [];

    final regExp = RegExp(Constants.MAP_REGEXP, multiLine: true, caseSensitive: false, dotAll: false);

    regExp.allMatches(svgMuscle).forEach((muscleData) {
      final id = muscleData.group(1)!;
      final title = muscleData.group(2)!;
      final path = parseSvgPath(muscleData.group(3)!);

      sizeController.addBounds(path.getBounds());

      final muscle = Muscle(id: id, title: title, path: path);

      muscleList.add(muscle);

      final group = muscleGroups.entries.firstWhereOrNull((entry) => entry.value.contains(id));
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
