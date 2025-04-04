import 'package:hive_flutter/hive_flutter.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String name = '';
  @HiveField(1)
  late bool isCompleted = false;
  @HiveField(2)
  Priority priority = Priority.low;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
}
