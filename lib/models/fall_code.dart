import 'package:hive/hive.dart';

part 'fall_code.g.dart';

@HiveType(typeId: 1)
class FallCode {
  @HiveField(0)
  final int code;

  FallCode({required this.code});
}
