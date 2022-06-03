import 'package:hive/hive.dart';

part 'setting.g.dart';

@HiveType(typeId: 2)
class Setting {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  Setting({
    required this.name,
    required this.email,
    required this.password,
  });
}
